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

        await sql.connect(config);
        const query = `
                  UPDATE dbo.[Запросы клиентов] 
                  SET Заказано = ${data.quantity} 
                  WHERE ID_Запроса = ${data.orderId}
        `;
        await sql.query(query);

    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
    }
};

module.exports = updateOrderQuantity;