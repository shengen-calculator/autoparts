const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const updateReserveQuantity = async (data, context) => {

    util.CheckForManagerRole(context);

    if (!data || !data.reserveId || typeof data.quantity === 'undefined') {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with argument "reserve Id and quantity"');
    }

    try {
        const pool = await sql.connect(config);

        await pool.request()
                .input('reserveId', sql.Int, data.reserveId)
            .input('quantity', sql.Int, data.quantity)
            .execute('sp_web_updatereserveqty');
    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
    }
};

module.exports = updateReserveQuantity;