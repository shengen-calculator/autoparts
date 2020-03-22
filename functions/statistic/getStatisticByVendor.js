const functions = require('firebase-functions');
const util = require('../util');

const getStatisticByVendor = async (data, context) => {

    util.CheckForManagerRole(context);

    if (!data || !data.startDate || !data.endDate || !data.vendorId) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with three arguments "start date", "end date" and "vendorId"');
    }

    function createData(id, vip, brand, number, quantity, available, price, date) {
        return {id, vip, brand, number, quantity, available, price, date};
    }

    const rows = [
        createData(1, '3412', 'G8G008PC', 'BERU', 2, 0, 15.67, '20.02.2020'),
        createData(2, '3149', '2112-GEMT', 'BERU', 1, 0, 1.16, '20.02.2020'),
        createData(3, '3137', '1662', 'BOSCH', 2, 0, 19.14, '20.02.2020'),
        createData(4, '3149', '22140', 'BERU', 3, 0, 5.66, '20.02.2020'),
        createData(5, '3149', '716 010 0016', 'BERU', 1, 3, 3.92, '20.02.2020'),
        createData(6, '4221', '301850', 'BOSCH', 1, 0, 6.14, '20.02.2020'),
        createData(7, '4218', 'D4099', 'BERU', 1, 5, 0.79, '20.02.2020'),
        createData(8, '3749', 'J42048AYMT', 'NGK', 1, 10, 6.27, '20.02.2020'),
        createData(9, '4003', 'CVT-26', 'BOSCH', 1, 0, 2.6, '20.02.2020'),
        createData(10, '1000', 'GOM-293', 'NGK', 1, 0, 2.32, '20.02.2020'),

    ];


    return rows;
};

module.exports = getStatisticByVendor;