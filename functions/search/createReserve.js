const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const createReserve = async (data, context) => {


    if (data.clientId) {
        util.checkForManagerRole(context);
    } else {
        util.checkForClientRole(context);
    }

    if (!data || !data.productId || typeof data.quantity === 'undefined' || !data.price || typeof data.isEuroClient === 'undefined') {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with the next arguments "ProductId, Quantity, Price, IsEuroClient"');
    }

//source
// склад = 0
// заказ = 1

    try {
        const pool = await sql.connect(config);

        const result = await pool.request()
            .input('clientId', sql.Int, data.clientId ? data.clientId : context.auth.token.clientId)
            .input('productId', sql.Int, data.productId)
            .input('price', sql.Decimal(9, 2), data.price)
            .input('isEuroClient', sql.Bit, data.isEuroClient)
            .input('quantity', sql.Int, data.quantity)
            .input('status', sql.VarChar(50), 'internet')
            .input('currentUser', sql.VarChar(20), context.auth.token.email)
            .execute('sp_web_addreserve');
        return result.recordset;
    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal', err.message);
        }
        return {err: err.message};
    }
};

module.exports = createReserve;