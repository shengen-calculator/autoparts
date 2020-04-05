const functions = require('firebase-functions');
const util = require('../util');

const updateReservePrices = async (data, context) => {

    util.CheckForManagerRole(context);

    if (!data) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with argument "array of new prices"');
    }

};

module.exports = updateReservePrices;