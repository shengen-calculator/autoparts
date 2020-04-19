const functions = require('firebase-functions');
const util = require('../util');

const createOrder = async (data, context) => {

    util.CheckForManagerRole(context);
    function createData(id, vendor, brand, number, description, note, ordered, approved, euro, uah, orderDate, shipmentDate, status) {
        return {id, vendor, brand, number, description, note, ordered, approved, euro, uah, orderDate, shipmentDate, status };
    }


    if (!data || !data.productId || typeof data.quantity === 'undefined' || !data.price || !data.vip || typeof data.onlyOrderedQuantity === 'undefined') {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with the next arguments "ProductId, Quantity, Price, Vip, OnlyOrderedQuantity"');
    }

    return createData(35, 'IC', 'CTR', 'CRN-73', 'Только что добавленая в заказ позиция', '', data.onlyOrderedQuantity, 0, 11.53, 416, '22.02.2020', '26.02.2020', 2);

};

module.exports = createOrder;