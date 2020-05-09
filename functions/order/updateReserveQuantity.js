const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const updateReserveQuantity = async (data, context) => {

    util.checkForManagerRole(context);

    if (!data || !data.reserveId || typeof data.quantity === 'undefined' || !data.productId) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with argument "reserveId, quantity and productId"');
    }

    try {
        const pool = await sql.connect(config);

        await pool.request()
            .input('reserveId', sql.Int, data.reserveId)
            .input('quantity', sql.Int, data.quantity)
            .input('productId', sql.Int, data.productId)
            .execute('sp_web_updatereserveqty');
    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
    }
};

module.exports = updateReserveQuantity;