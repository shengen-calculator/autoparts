const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const createOrder = async (data, context) => {


    if (data.clientId || data.price || data.vip) {
        util.checkForManagerRole(context);
    } else {
        util.checkForClientRole(context);
    }

    if (!data || !data.productId || typeof data.quantity === 'undefined' || typeof data.isEuroClient === 'undefined' || typeof data.onlyOrderedQuantity === 'undefined') {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with the next arguments "ProductId, Quantity, IsEuroClient, OnlyOrderedQuantity"');
    }

    const blocked = await util.isUserBlocked(data, context);

    if (blocked) {
        throw new functions.https.HttpsError('failed-precondition',
            'User account is blocked. Please contact administrator.');
    }

    try {
        const pool = await sql.connect(config);

        const result = await pool.request()
            .input('clientId', sql.Int, data.clientId ? data.clientId : context.auth.token.clientId)
            .input('productId', sql.Int, data.productId)
            .input('price', sql.Decimal(9, 2), data.price ? data.price : 0)
            .input('isEuroClient', sql.Bit, data.isEuroClient)
            .input('quantity', sql.Int, data.quantity)
            .input('onlyOrderedQuantity', sql.Bit, data.onlyOrderedQuantity)
            .input('currentUser', sql.VarChar(20), data.vip ? data.vip : context.auth.token.vip)
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
