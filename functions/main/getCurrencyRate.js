const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const getCurrencyRate = async (data, context) => {

    util.checkForClientRole(context);

    try {
        const pool = await sql.connect(config);

        const result = await pool.request()
            .execute('sp_web_getcurrencyrate');
        return result.recordset;
    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {err: err.message};
    }
};

module.exports = getCurrencyRate;