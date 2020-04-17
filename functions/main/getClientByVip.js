const functions = require('firebase-functions');
const util = require('../util');

const getClientByVip = async (data, context) => {

    util.CheckForManagerRole(context);

    if (!data) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with one argument "vip"');
    }

    function createData(vip, fullName, isEuroClient) {
        return { vip, fullName, isEuroClient };
    }

    const rows = [
        createData('1000','Юрий Петров', true),
        createData('2000','Сергей Иванов', true),
        createData('3000','Иван Сидоров', true),
        createData('4000','Николай Пупкин', false),
        createData('5000','Петр Комаровский', false),
    ];

    return rows.find(x => x.vip === data);
};

module.exports = getClientByVip;