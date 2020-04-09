const functions = require('firebase-functions');
const util = require('../util');

const checkIfPresentInOrderList = async (data, context) => {

    util.CheckForManagerRole(context);

    if (!data) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with one argument "AnalogId"');
    }

    function createData(id, vip, brand, number, quantity, alternative, orderDate, isUrgent, date) {
        return {id, vip, brand, number, quantity, alternative, orderDate, isUrgent, date };
    }

    return [
        createData(1, '0020', 'FAG', 'FAG713610230', 4, '', '11.02.2020', false, '11.02.2020')
    ];
};

module.exports = checkIfPresentInOrderList;