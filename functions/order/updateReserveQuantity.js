const functions = require('firebase-functions');
const util = require('../util');

const updateReserveQuantity = async (data, context) => {

    util.CheckForManagerRole(context);

    if (!data) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with argument "reserve Id and quantity"');
    }
    function createData(id, brand, number, description, note, quantity, vendor, euro, uah, orderDate, date, source) {
        return {id, brand, number, description, quantity, note, vendor, euro, uah, orderDate, date, source };
    }

    return [
        createData(1, 'CTR', 'CRN-73', '(16:00, Сб. до 13:00) BERU 14FR-5DU Свеча зажигания ULTRA', 'отгружено', 4, 'С2', 0.53, 16, '11.02.2020', '22.02.2020', 0),
        createData(2, 'RENAULT', '401604793R', '(16:00, Сб. до 13:00) BERU 14FR-5DU Свеча зажигания ULTRA', 'отгружено', 1, 'С2', 5.66, 150, '11.02.2020', '23.02.2020', 1),
        createData(8, 'NIPPARTS', 'N4961039', 'Свеча зажигания 3330', '', 1, '', 44.94, 1154.96, '16.02.2020', '18.02.2020', 0),
        createData(9, 'FEBI', '45414', '', 'internet', 3, 'ES', 58.75, 1509.88, '11.02.2020', '24.02.2020', 0),
        createData(10, 'HUTCHINSON', '532E02', 'ŚWIECA ZAPŁONOWA PSA/FIAT', '', 4, 'ES', 6.61, 169.88, '15.02.2020', '22.02.2020', 1),
        createData(11, 'DELPHI', 'TA2913', 'ŚWIECA ZAPŁONOWA PSA/FIAT', '', 2, '', 33.95, 872.52, '19.02.2020', '23.02.2020', 0),
        createData(12, 'RTS', '017-00406', '', 'internet', 2, 'ES', 13.29, 358.83, '18.02.2020', '27.02.2020', 0)
    ];

};

module.exports = updateReserveQuantity;