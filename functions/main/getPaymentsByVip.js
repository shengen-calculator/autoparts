const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const getPaymentsByVip = async (data, context) => {

    util.CheckForManagerRole(context);

    if (!data) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with one argument "vip"');
    }

    try {
        const pool = await sql.connect(config);

        const result = await pool.request()
            .input('vip', sql.VarChar(10), data)
            .execute('sp_web_getpaymentplanbyvip');
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