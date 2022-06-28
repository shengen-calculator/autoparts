const util = require('../util');
const sql = require('mssql');
const functions = require('firebase-functions');
const config = require('../mssql.connection').config;

const getDeliveryDate = async (data, context) => {

    util.checkForClientRole(context);

    if (!data || typeof data.productId === 'undefined' || typeof data.term === 'undefined') {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with the next arguments "productId, term"');
    }

    try {
        await sql.connect(config);
        const query =`
            SELECT FORMAT(dbo.GetArrivalDate((
                SELECT WarehouseId FROM [Каталоги поставщиков] WHERE ID_Запчасти = ${data.productId}
            ), ${data.term}), 'dd.MM.yyyy') as ArrivalDate, ArrivalTime 
            FROM SupplierWarehouse 
            WHERE Id = (
                SELECT WarehouseId FROM [Каталоги поставщиков] WHERE ID_Запчасти = ${data.productId}
            )
        `;

        const result = await sql.query(query);
        return result.recordset[0];
    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {err: err.message};
    }
};

module.exports = getDeliveryDate;