const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const getReconciliationData = async (data, context) => {

    if (data.clientId) {
        util.checkForManagerRole(context);
    } else {
        util.checkForClientRole(context);
    }

    try {
        const pool = await sql.connect(config);

        const result = await pool.request()
            .input('clientId', sql.Int, data.clientId ? data.clientId : context.auth.token.clientId)
            .input('startDate', sql.Date, data.startDate)
            .input('endDate', sql.Date, data.endDate)
            .execute('sp_web_getreconciliationdata');
        return util.getReconciliationXlsLink(result.recordset);
    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {error: err.message};
    }

};

module.exports = getReconciliationData;