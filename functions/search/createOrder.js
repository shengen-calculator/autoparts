const functions = require('firebase-functions');
const util = require('../util');

const createOrder = async (data, context) => {

    util.CheckForManagerRole(context);

    if (!data || !data.productId || !data.quantity || !data.price || !data.vip || typeof data.onlyOrderedQuantity === 'undefined') {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with the next arguments "ProductId, Quantity, Price, Vip, OnlyOrderedQuantity"');
    }

    function createData(id, vendor, brand, number, description, note, ordered, approved, euro, uah, orderDate, shipmentDate, status) {
        return {id, vendor, brand, number, description, note, ordered, approved, euro, uah, orderDate, shipmentDate, status };
    }

    const orders = [
        createData(1, 'IC', 'CTR', 'CRN-73', 'Свеча зажигания 3330', '', 4, 3, 0.53, 16, '22.02.2020', '26.02.2020', 2),
        createData(2, 'ELIT', 'RENAULT', '401604793R', 'Свеча зажигания 3330', '', 1, 1, 5.66, 150, '23.02.2020', '27.02.2020', 0),
        createData(3, 'V', 'HUTCHINSON', '590153', 'Свеча зажигания 3330', '', 2, 2, 5.28, 140, '21.02.2020', '26.02.2020', 0),
        createData(4, 'OMEGA', 'HUTCHINSON', '590153', 'Свеча зажигания 3330', '', 4, 0, 1.7, 45, '26.02.2020', '28.02.2020', 4),
        createData(5, 'ES', 'AKITAKA', '590153', '', '', 3, 3, 17.05, 448.42, '20.02.2020', '26.02.2020', 0),
        createData(6, 'AP-3512', 'PARTS-MALL', 'PKW-015', '', '', 2, 2, 1.69, 43.43, '11.02.2020', '', 0),
        createData(7, 'AND', 'NIPPARTS', 'N4961039', '', '', 1, 1, 6.75, 173.48, '26.02.2020', '02.03.2020', 0),
        createData(8, '3512', 'NIPPARTS', 'N4961039', 'Свеча зажигания 3330', '', 1, 0, 44.94, 1154.96, '18.02.2020', '', 1),
        createData(9, 'VA', 'FEBI', '45414', 'Свеча зажигания FR7DCE 0.8', '', 3, 0, 58.75, 1509.88, '24.02.2020', '01.03.2020', 1),
        createData(10, 'ELIT', 'HUTCHINSON', '532E02', 'Свеча зажигания FR7DCE 0.8', '', 4, 4, 6.61, 169.88, '22.02.2020', '', 0),
        createData(11, 'ORIG', 'DELPHI', 'TA2913', '(16:00, Сб. до 13:00) BERU 14FR-5DU Свеча зажигания ULTRA', '', 2, 0, 33.95, 872.52, '23.02.2020', '', 1),
        createData(12, 'VA', 'RTS', '017-00406', '(16:00, Сб. до 13:00) BERU 14FR-5DU Свеча зажигания ULTRA', '', 2, 0, 13.29, 358.83, '27.02.2020', '', 3)
    ];
};

module.exports = createOrder;