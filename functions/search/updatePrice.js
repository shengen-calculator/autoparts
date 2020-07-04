const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const updatePrice = async (data, context) => {

    util.checkForManagerRole(context);

    if (!data || !data.productId || !data.price || !data.discount) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with the next arguments "ProductId, Price, Discount, Retail"');
    }

    try {
        const pool = await sql.connect(config);

        const result = await pool.request()
            .input('price', sql.Decimal(9, 2), data.price)
            .input('discount', sql.Int, data.discount)
            .input('productId', sql.Int, data.productId)
            .execute('sp_web_updateprice');
        return result.recordset;
    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {err: err.message};
    }

};

module.exports = updatePrice;