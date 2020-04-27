const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;
const searchByBrandAndNumber = async (data, context) => {

    util.CheckForManagerRole(context);

    if (!data ||!data.number ||!data.brand  ||!data.clientId) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with three arguments "Brand, Number and ClientId"');
    }

    try {
        const pool = await sql.connect(config);
        const result = await pool.request()
            .input('number', sql.VarChar(25), data.number)
            .input('brand', sql.VarChar(18), data.brand.replace('%2F', '/'))
            .input('clientId', sql.Int, data.clientId)
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