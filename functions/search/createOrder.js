const functions = require('firebase-functions');
const util = require('../util');

const createOrder = async (data, context) => {

    util.CheckForManagerRole(context);

    if (!data || !data.productId || typeof data.quantity === 'undefined' || !data.price || !data.vip || typeof data.onlyOrderedQuantity === 'undefined') {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with the next arguments "ProductId, Quantity, Price, Vip, OnlyOrderedQuantity"');
    }
};

module.exports = createOrder;