const util = require('../util');
const sql = require('mssql');
const functions = require('firebase-functions');
const config = require('../mssql.connection').config;

const getDeliveryDate = async (data, context) => {

    util.checkForClientRole(context);

    if (!data || typeof data.warehouseId === 'undefined' || typeof data.term === 'undefined') {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with the next arguments "warehouseId, term"');
    }

    try {
        await sql.connect(config);
        const query =`
            SELECT dbo.GetArrivalDate(${data.warehouseId}, ${data.term}) as ArrivalDate, ArrivalTime 
            FROM SupplierWarehouse 
            WHERE Id = ${data.warehouseId}
        `;

        const result = await sql.query(query);
        return result.recordset;
    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {err: err.message};
    }
};

module.exports = getDeliveryDate;