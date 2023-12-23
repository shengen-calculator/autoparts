const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;
const {Datastore} = require('@google-cloud/datastore');

const createReserve = async (data, context) => {

    if (data.clientId || data.price) {
        util.checkForManagerRole(context);
    } else {
        util.checkForClientRole(context);
    }

    if (!data || !data.productId || typeof data.quantity === 'undefined' || typeof data.isEuroClient === 'undefined') {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with the next arguments "ProductId, Quantity, IsEuroClient"');
    }

//source
// склад = 0
// заказ = 1

    let userDebt = 0;
    let vip;
    let pool;
    let recordDate;
    let isUserBlocked = false;
    const currentDate = new Date();

    try {
        pool = await sql.connect(config);
        // check for debt
        const debtQuery = `
            SELECT dbo.Клиенты.VIP as vip,
                dbo.GetAmountOverdueDebt(dbo.Клиенты.ID_Клиента, - ISNULL(dbo.Клиенты.Количество_дней, 0)) AS OverdueDebt                
            FROM dbo.Должок INNER JOIN
                dbo.Клиенты ON dbo.Должок.ID_Клиента = dbo.Клиенты.ID_Клиента FULL OUTER JOIN
                dbo.Проплачено ON dbo.Должок.ID_Клиента = dbo.Проплачено.ID_Клиента
            WHERE (dbo.Клиенты.Выводить_просрочку = 1) AND 
                  (dbo.Клиенты.ID_Клиента like ${data.clientId ? data.clientId : context.auth.token.clientId})            
        `;

        const debtRecord = await sql.query(debtQuery);

        if (debtRecord.recordset.length) {
            userDebt = parseFloat(debtRecord.recordset[0]["OverdueDebt"]);
            vip = debtRecord.recordset[0]["vip"];
        }

        if (Math.sign(userDebt) === -1) {
            isUserBlocked = true;
            const datastore = new Datastore();
            const storeQuery = datastore
                .createQuery("unblock-records")
                .filter("vip", "=", vip.trimEnd())
                .order("date", {
                    descending: true
                })
                .limit(1);
            const queryResult = await datastore.runQuery(storeQuery);
            const [entities] = queryResult;
            console.log(JSON.stringify(entities));
            if (entities.length) {
                recordDate = entities.pop().date;
            }
        }

        if (recordDate && recordDate.getFullYear() === currentDate.getFullYear() &&
            recordDate.getMonth() === currentDate.getMonth() &&
            recordDate.getDate() === currentDate.getDate()) {
            isUserBlocked = false;
        }

    } catch (err) {
        if (err) {
            throw new functions.https.HttpsError('internal', err.message);
        }
        return {err: err.message};
    }

    if (isUserBlocked) {
        throw new functions.https.HttpsError('failed-precondition',
            'User account is blocked. Please contact administrator.');
    }

    try {
        const result = await pool.request()
            .input('clientId', sql.Int, data.clientId ? data.clientId : context.auth.token.clientId)
            .input('productId', sql.Int, data.productId)
            .input('price', sql.Decimal(9, 2), data.price ? data.price : 0)
            .input('isEuroClient', sql.Bit, data.isEuroClient)
            .input('quantity', sql.Int, data.quantity)
            .input('status', sql.VarChar(50), 'internet')
            .input('currentUser', sql.VarChar(20), context.auth.token.email)
            .execute('sp_web_addreserve');

        return result.recordset;

    } catch (err) {
        if (err) {
            throw new functions.https.HttpsError('internal', err.message);
        }
        return {err: err.message};
    }
};

module.exports = createReserve;
