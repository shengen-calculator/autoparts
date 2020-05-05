const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;
const searchByBrandAndNumber = async (data, context) => {

    if (data && data.clientId) {
        util.CheckForManagerRole(context);
    } else {
        util.checkForClientRole(context);
    }


    if (!data ||!data.number ||!data.brand) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with at least two arguments "Brand and Number"');
    }

    try {
        const pool = await sql.connect(config);
        const result = await pool.request()
            .input('number', sql.VarChar(25), data.number)
            .input('brand', sql.VarChar(18), data.brand)
            .input('clientId', sql.Int, data.clientId ? data.clientId : context.auth.token.clientId)
            .input('isVendorShown', sql.Bit, data.clientId ? 1 : 0)
            .execute('sp_web_getproductsbybrand');
        return result.recordset;
    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {err: err.message};
    }

};

module.exports = searchByBrandAndNumber;