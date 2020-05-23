const functions = require('firebase-functions');
const util = require('../util');

const getQueryStatistic = async (data, context) => {

    util.checkForManagerRole(context);

    if (!data || !data.startDate || !data.endDate) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with two arguments "start date" and "end date"');
    }

    return {
        orderTotal: 245,
        order: 99,
        reserveTotal: 286,
        reserve: 63,
        registration: 130,
        queryTotal: 3526
    }

};

module.exports = getQueryStatistic;