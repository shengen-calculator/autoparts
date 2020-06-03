const functions = require('firebase-functions');
const reconciliationXls = require('./reconciliationXls');
const sql = require('mssql');
const config = require('../mssql.connection').config;
const util = require('../util');

const getReconciliationData = async (data, context) => {

    if (data.clientId) {
        util.checkForManagerRole(context);
    } else {
        util.checkForClientRole(context);
    }

    try {
        const pool = await sql.connect(config);

        const [records, balance] = await Promise.all([
            pool.request()
                .input('clientId', sql.Int, data.clientId ? data.clientId : context.auth.token.clientId)
                .input('startDate', sql.Date, data.startDate)
                .input('endDate', sql.Date, data.endDate)
                .execute('sp_web_getreconciliationdata'),
            pool.request()
                .input('clientId', sql.Int, data.clientId ? data.clientId : context.auth.token.clientId)
                .input('day', sql.Date, data.startDate)
                .query('SELECT dbo.GetBalanceOnDate(@clientId, @day) as balance')
        ]);

        return await reconciliationXls.getReconciliationXlsLink(records.recordset, balance.recordset[0]);

    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {error: err.message};
    }

};

module.exports = getReconciliationData;
