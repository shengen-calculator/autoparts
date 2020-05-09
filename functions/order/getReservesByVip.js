const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const getReservesByVip = async (data, context) => {


    if (data) {
        util.checkForManagerRole(context);
    } else {
        util.checkForClientRole(context);
    }

//source
// склад = 0
// заказ = 1

    try {
        const pool = await sql.connect(config);

        const result = await pool.request()
            .input('vip', sql.VarChar(10), data ? data : context.auth.token.vip)
            .execute('sp_web_getreservesbyvip');
        return result.recordset;
    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {err: err.message};
    }

};

module.exports = getReservesByVip;