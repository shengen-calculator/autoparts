const functions = require('firebase-functions');
const util = require('../util');

const getInfoByVendor = async (data, context) => {

    util.CheckForManagerRole(context);

    if (!data) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with one argument "Number"');
    }

    return {orderTime: "Пон.-Пят. до 17:30, Сб. до 12:30", arrivalTime:"До 14:00"};
};

module.exports = getInfoByVendor;