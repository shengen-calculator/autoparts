const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const getPayments = async (data, context) => {

    if (data && data.vip) {
        util.checkForManagerRole(context);
    } else {
        util.checkForClientRole(context);
    }

    try {
        await sql.connect(config);
        const query = `
                SELECT ID_Касса                             as id,
                       Цена                                 as amountEur,
                       Грн                                  as amountUah,
                       FORMAT(dbo.Касса.Дата, 'dd.MM.yyyy') AS date,
                       dbo.Касса.Примечание                 as description,
                       COUNT(*) OVER ()                     as totalCount
                FROM dbo.Касса
                         INNER JOIN
                     dbo.Клиенты ON dbo.Касса.ID_Клиента = dbo.Клиенты.ID_Клиента
                WHERE dbo.Клиенты.VIP LIKE '${data.vip ? data.vip : context.auth.token.vip}'
                ORDER BY dbo.[Касса].ID_Касса DESC OFFSET ${data.offset ? data.offset : 0} ROWS FETCH NEXT ${(data.rows && data.rows < 101) ? data.rows : 10} ROWS ONLY
        `;

        const result = await sql.query(query);
        return result.recordset;
    } catch (err) {
        if (err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {err: err.message};
    }
};

module.exports = getPayments;