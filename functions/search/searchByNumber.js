const functions = require('firebase-functions');
const util = require('../util');

const searchByNumber = async (data, context) => {

    util.CheckForManagerRole(context);

    if (!data) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with one argument "Number"');
    }

    function createData(brand, number, description) {
        return {brand, number, description};
    }

    return [
        createData('BERU', 'Z30', 'Свеча зажигания 3330'),
        createData('RENAULT', '401604793R', 'Свеча зажигания 3330'),
        createData('HUTCHINSON', '590153', 'Свеча зажигания 3330'),
        createData('AKITAKA', '590153', '',),
        createData('BOSCH', '0242245536', 'Свеча зажигания FR7DCE 0.8'),
        createData('RUVILE', '5413', 'Свеча зажигания 3330'),
    ];
};

module.exports = searchByNumber;