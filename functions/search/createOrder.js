const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const createOrder = async (data, context) => {

    util.CheckForManagerRole(context);

    if (!data || !data.productId || typeof data.quantity === 'undefined' || !data.price || !data.vip || !data.clientId || typeof data.isEuroClient === 'undefined' || typeof data.onlyOrderedQuantity === 'undefined') {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with the next arguments "ProductId, Quantity, Price, ClientId, IsEuroClient, OnlyOrderedQuantity"');
    }


    try {
        const pool = await sql.connect(config);

        const result = await pool.request()
            .input('clientId', sql.Int, data.clientId)
            .input('productId', sql.Int, data.productId)
            .input('price', sql.Decimal(9, 2), data.price)
            .input('isEuroClient', sql.Bit, data.isEuroClient)
            .input('quantity', sql.Int, data.quantity)
            .input('onlyOrderedQuantity', sql.Bit, data.onlyOrderedQuantity)
            .input('currentUser', sql.VarChar(20), data.vip)
            .execute('sp_web_addorder');
        return result.recordset;
    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal', err.message);
        }
        return {err: err.message};
    }

};

module.exports = createOrder;