const functions = require('firebase-functions');

const getPaymentsByVip = async (data, context) => {

    if (!process.env.FUNCTIONS_EMULATOR) {
        if (!context.auth) {
            throw new functions.https.HttpsError('failed-precondition',
                'The function must be called while authenticated.');
        }
    }

    if (!data) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with one argument "vip"');
    }


    function createData(vip, amount, date) {
        return { vip, amount, date };
    }

    const rows = [
        createData('1000',15.76, '28.02.2020'),
        createData('1000',9.84, '29.02.2020' ),
        createData('1000', 3.45, '01.03.2020'),
        createData('1000', 0,'02.03.2020'),
        createData('1000', 0, '03.03.2020'),
        createData('1000',0, '04.03.2020'),

        createData('3000',25.99, '28.02.2020'),
        createData('3000',15.26, '29.02.2020' ),
        createData('3000', 12.31, '01.03.2020'),
        createData('3000', 9.75,'02.03.2020'),
        createData('3000', 0, '03.03.2020'),
        createData('3000',0, '04.03.2020'),
    ];

    return rows.filter(v => v.vip === data);
};

module.exports = getPaymentsByVip;