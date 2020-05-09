const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const updateOrderQuantity = async (data, context) => {

    util.checkForManagerRole(context);

    if (!data || !data.orderId || typeof data.quantity === 'undefined') {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with argument "order Id and quantity"');
    }

    try {
        const pool = await sql.connect(config);

        await pool.request()
            .input('orderId', sql.Int, data.orderId)
            .input('quantity', sql.Int, data.quantity)
            .execute('sp_web_updateorderqty');
    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
    }
};

module.exports = updateOrderQuantity;