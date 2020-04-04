const functions = require('firebase-functions');
const util = require('../util');

const getVendorStatistic = async (data, context) => {

    util.CheckForManagerRole(context);

    if (!data || !data.startDate || !data.endDate) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with two arguments "start date" and "end date"');
    }

    function createData(vendorId, vendor, quantity) {
        return { vendorId, vendor, quantity };
    }

    const rows = [
        createData(1,'PLANETA',  6),
        createData(2,'ADS',  4),
        createData(3,'WEST',  4),
        createData(4,'BAS',  3),
        createData(5,'OMEGA',  3),
        createData(6,'VA',  3),
        createData(7,'ES',  3),
        createData(8,'LIDER',  2),
        createData(9,'1707',  2),
        createData(10,'VLAD',  2),
        createData(11,'PITSTOP',  1),
        createData(12,'SZ',  1),
        createData(13,'BUS',  1),
    ];


    return rows;
};

module.exports = getVendorStatistic;