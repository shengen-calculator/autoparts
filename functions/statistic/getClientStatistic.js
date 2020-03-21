const functions = require('firebase-functions');
const util = require('../util');

const getClientStatistic = async (data, context) => {

    util.CheckForManagerRole(context);

    if (!data || !data.startDate || !data.endDate) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with two arguments "start date" and "end date"');
    }


    function createData(id, vip, requests, succeeded, orders, reserves) {
        return { id, vip, requests, succeeded, orders, reserves };
    }

    const rows = [
        createData(1,'3825', 554, 439, 0, 0),
        createData(2,'3418', 210, 193, 0, 0),
        createData(3,'3149', 140, 127, 31, 18),
        createData(4,'3853', 111, 100, 1, 6),
        createData(5,'2708', 94, 81, 1, 2),
        createData(6,'2708A', 87, 79, 10, 10),
        createData(7,'3003', 78, 73, 2, 3),
        createData(8,'3147A', 68, 62, 3, 7),
        createData(9,'3749', 67, 63, 3, 9),
        createData(10,'4249', 67, 63, 6, 5),
        createData(11,'3537', 58, 48, 1, 1),
        createData(12,'3198', 54, 43, 6, 0),
        createData(13,'3136', 49, 31, 0, 0),
    ];


    return rows;
};

module.exports = getClientStatistic;