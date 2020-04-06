const functions = require('firebase-functions');
const util = require('../util');

const updateOrderQuantity = async (data, context) => {

    util.CheckForManagerRole(context);

    if (!data) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with argument "order Id and quantity"');
    }


    function createData(id, vendor, brand, number, description, note, ordered, approved, euro, uah, orderDate, shipmentDate, status) {
        return {id, vendor, brand, number, description, note, ordered, approved, euro, uah, orderDate, shipmentDate, status };
    }

    return [
        createData(1, 'IC', 'CTR', 'CRN-73', 'Свеча зажигания 3330', '', 4, 3, 0.53, 16, '22.02.2020', '26.02.2020', 2),
        createData(2, 'ELIT', 'RENAULT', '401604793R', 'Свеча зажигания 3330', '', 1, 1, 5.66, 150, '23.02.2020', '27.02.2020', 0),
        createData(3, 'V', 'HUTCHINSON', '590153', 'Свеча зажигания 3330', '', 2, 2, 5.28, 140, '21.02.2020', '26.02.2020', 0),
        createData(4, 'OMEGA', 'HUTCHINSON', '590153', 'Свеча зажигания 3330', '', 4, 0, 1.7, 45, '26.02.2020', '28.02.2020', 4),
        createData(5, 'ES', 'AKITAKA', '590153', '', '', 3, 3, 17.05, 448.42, '20.02.2020', '26.02.2020', 0),
        createData(6, 'AP-3512', 'PARTS-MALL', 'PKW-015', '', '', 2, 2, 1.69, 43.43, '11.02.2020', '', 0),
    ];

};

module.exports = updateOrderQuantity;