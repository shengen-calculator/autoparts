const functions = require('firebase-functions');
const util = require('../util');

const updateOrderQuantity = async (data, context) => {

    util.CheckForManagerRole(context);

    if (!data) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with argument "order Id and quantity"');
    }

};

module.exports = updateOrderQuantity;