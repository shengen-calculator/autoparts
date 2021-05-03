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
        const pool = await sql.connect(config);

        const result = await pool.request()
            .input('vip', sql.VarChar(10), data.vip ? data.vip : context.auth.token.vip)
            .input('offset', sql.Int, data.offset ? data.offset : 0)
            .input('rows', sql.Int, (data.rows && data.rows < 101) ? data.rows : 10)
            .execute('sp_web_getpaymenthistory');
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