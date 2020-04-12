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
        createData('CTR', 'CRN-73', 'Свеча зажигания 3330'),
        createData('RENAULT', '401604793R', 'Свеча зажигания 3330'),
        createData('HUTCHINSON', '590153', 'Свеча зажигания 3330'),
        createData('AKITAKA', '590153', '',),
        createData('PARTS-MALL', 'PKW-015', ''),
        createData('NIPPARTS', 'N4961039', 'Свеча зажигания 3330'),
    ];
};

module.exports = searchByNumber;