const functions = require('firebase-functions');
const util = require('../util');

const getClientByVip = async (data, context) => {

    util.CheckForManagerRole(context);

    if (!data) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with one argument "vip"');
    }

    function createData(vip, fullName) {
        return { vip, fullName };
    }

    const rows = [
        createData('1000','Юрий Петров'),
        createData('2000','Сергей Иванов'),
        createData('3000','Иван Сидоров'),
        createData('4000','Николай Пупкин'),
        createData('5000','Петр Комаровский'),
    ];

    return rows.find(x => x.vip === data);
};

module.exports = getClientByVip;