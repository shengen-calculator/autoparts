const functions = require('firebase-functions');
const util = require('../util');

const getStatisticByClient = async (data, context) => {

    util.checkForManagerRole(context);

    if (!data || !data.startDate || !data.endDate || !data.vip) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with three arguments "start date", "end date" and "vip"');
    }

    function createData(id, request, brand, number, available, date) {
        return {id, request, brand, number, available, date};
    }

    const rows = [
        createData(1, 'G8G008PC', 'BERU', 'G8G008PC', true, '20.02.2020'),
        createData(2, '2112-GEMT', 'BERU', '2112GEMT', true, '20.02.2020'),
        createData(3, '1662', 'BOSCH', '1662', false, '20.02.2020'),
        createData(4, '22140', 'BERU', '22140', true, '20.02.2020'),
        createData(5, '716 010 0016', 'BERU', '7160100016', false, '20.02.2020'),
        createData(6, '301850', 'BOSCH', '301850', false, '20.02.2020'),
        createData(7, 'D4099', 'BERU', 'D4099', true, '20.02.2020'),
        createData(8, 'J42048AYMT', 'NGK', 'J42048AYMT', false, '20.02.2020'),
        createData(9, 'CVT-26', 'BOSCH', 'CVT26', false, '20.02.2020'),
        createData(10, 'GOM-293', 'NGK', 'GOM293', true, '20.02.2020'),
        createData(11, '160101', 'BOSCH', '160101', false, '20.02.2020'),
        createData(12, 'FDB4871', 'NGK', 'FDB4871', true, '20.02.2020'),
        createData(13, '512966', 'NGK', '512966', false, '20.02.2020'),
    ];

    return rows;
};

module.exports = getStatisticByClient;