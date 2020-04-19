const functions = require('firebase-functions');
const util = require('../util');

const createReserve = async (data, context) => {

    util.CheckForManagerRole(context);
    function createData(id, brand, number, description, note, quantity, vendor, euro, uah, orderDate, date, source) {
        return {id, brand, number, description, quantity, note, vendor, euro, uah, orderDate, date, source };
    }

    if (!data || !data.productId || typeof data.quantity === 'undefined' || !data.price || !data.vip ) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with the next arguments "ProductId, Quantity, Price, Vip"');
    }
    return createData(35, 'DELPHI', 'TA2913', 'Только что зарезервированая ŚWIECA ZAPŁONOWA PSA/FIAT', '', 2, '', 33.95, 872.52, '19.02.2020', '23.02.2020', 0)
};

module.exports = createReserve;