const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const getPaymentsByVip = async (data, context) => {

    if (data) {
        util.checkForManagerRole(context);
    } else {
        util.checkForClientRole(context);
    }

    try {
        await sql.connect(config);
        const clientQuery = `                
                SELECT TOP (1) ID_Клиента as id
                              ,ISNULL([Количество_дней], 0) as days
                FROM [dbo].[Клиенты]
                WHERE VIP like '${data ? data : context.auth.token.vip}';
        `;
        const client = await sql.query(clientQuery);
        const id = parseInt(client.recordset[0]['id']);
        const days = parseInt(client.recordset[0]['days']);

        const paymentQuery = `
                    WITH gen AS (
                        SELECT DATEADD(day, 0, CURRENT_TIMESTAMP) AS PaymentDate,
                               dbo.GetAmountOverdueDebt(${id}, ${-days}) - 0 AS Amount,
                               0 AS num
                        UNION ALL
                        SELECT DATEADD(day, num + 1, CURRENT_TIMESTAMP)                                                        as PaymentDate,
                               (dbo.GetAmountOverdueDebt(${id}, ${-days} + num + 1) -
                                dbo.GetAmountOverdueDebt(${id}, ${-days} + num))                                                   as Amount,
                               num + 1
                        FROM gen
                        WHERE num + 1 <= ${days}
                    )
                    SELECT FORMAT(PaymentDate, 'd', 'de-de') as date, Amount as amount
                    FROM gen
        `;

        const result = await sql.query(paymentQuery);
        return result.recordset;
    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {error: err.message};
    }

};

module.exports = getPaymentsByVip;