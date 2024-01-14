const functions = require('firebase-functions');
const config = require('./mssql.connection').config;
const RoleEnum = require('./RoleEnum');
const {Datastore} = require('@google-cloud/datastore');
const sql = require('mssql');

const checkForAdminRole = (context) => {

    if (!process.env.FUNCTIONS_EMULATOR) {
        if (!context.auth) {
            throw new functions.https.HttpsError('failed-precondition',
                'The function must be called while authenticated.');
        } else if (context.auth.token.role !== RoleEnum.Admin) {
            throw new functions.https.HttpsError('failed-precondition',
                'Only administrator can call this function');
        }
    }
};

const checkForManagerRole = (context) => {

    if (!process.env.FUNCTIONS_EMULATOR) {
        if (!context.auth) {
            throw new functions.https.HttpsError('failed-precondition',
                'The function must be called while authenticated.');
        } else if (context.auth.token.role !== RoleEnum.Manager && context.auth.token.role !== RoleEnum.Admin) {
            throw new functions.https.HttpsError('failed-precondition',
                'Only manager can call this function');
        }
    }
};


const checkForClientRole = (context) => {

    if (!process.env.FUNCTIONS_EMULATOR) {
        if (!context.auth) {
            throw new functions.https.HttpsError('failed-precondition',
                'The function must be called while authenticated.');
        } else if (context.auth.token.role !== RoleEnum.Manager &&
            context.auth.token.role !== RoleEnum.Client &&
            context.auth.token.role !== RoleEnum.Admin) {
            throw new functions.https.HttpsError('failed-precondition',
                'Only manager or client can call this function');
        }
    }
};

const isUserBlocked = async (data, context) => {
    try {
        const currentDate = new Date();
        await sql.connect(config);
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

        if (!debtRecord.recordset.length) {
            return false;
        }

        const userDebt = parseFloat(debtRecord.recordset[0]["OverdueDebt"]);
        const vip = debtRecord.recordset[0]["vip"];

        if (Math.sign(userDebt) !== 1) {
            return false;
        }

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

        if (!entities.length) {
            return true;
        }

        const recordDate = entities.pop().date;

        return recordDate.getFullYear() !== currentDate.getFullYear() ||
            recordDate.getMonth() !== currentDate.getMonth() ||
            recordDate.getDate() !== currentDate.getDate();

    } catch (err) {
        if (err) {
            throw new functions.https.HttpsError('internal', err.message);
        }
        return {err: err.message};
    }
};

module.exports.isUserBlocked = isUserBlocked;
module.exports.checkForAdminRole = checkForAdminRole;
module.exports.checkForManagerRole = checkForManagerRole;
module.exports.checkForClientRole = checkForClientRole;
