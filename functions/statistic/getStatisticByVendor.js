const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const getStatisticByVendor = async (data, context) => {

    util.checkForManagerRole(context);

    if (!data) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with one argument "vendorId"');
    }

    try {
        const pool = await sql.connect(config);

        const result = await pool.request()
            .input('vendorId', sql.Int, data)
            .execute('sp_web_getstatisticsbyvendor');
        return result.recordset;
    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {err: err.message};
    }
};

module.exports = getStatisticByVendor;