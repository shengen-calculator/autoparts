const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const checkIfPresentInOrderList = async (data, context) => {
    util.checkForManagerRole(context);

    if (!data || !data.productId) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with the "ProductId" argument');
    }

    try {
        const pool = await sql.connect(config);

        const result = await pool.request()
            .input('productId', sql.Int, data.productId)
            .execute('sp_web_checkifpresentinorderlist');
        return result.recordset;
    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal', err.message);
        }
        return {err: err.message};
    }

};

module.exports = checkIfPresentInOrderList;