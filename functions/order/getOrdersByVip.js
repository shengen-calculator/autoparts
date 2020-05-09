const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;
const getOrdersByVip = async (data, context) => {


    if (data) {
        util.checkForManagerRole(context);
    } else {
        util.checkForClientRole(context);
    }


//status list
//подтвержден = 0
//в обработке = 1
//неполное количество = 2
//задерживается = 3
//нет в наличии = 4

    try {
        const pool = await sql.connect(config);

        const result = await pool.request()
            .input('vip', sql.VarChar(10), data ? data : context.auth.token.vip)
            .input('isVendorShown', sql.Bit, data ? 1 : 0)
            .execute('sp_web_getordersbyvip');
        return result.recordset;
    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {err: err.message};
    }

};

module.exports = getOrdersByVip;