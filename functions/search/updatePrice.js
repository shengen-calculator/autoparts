const functions = require('firebase-functions');
const util = require('../util');

const updatePrice = async (data, context) => {

    util.checkForManagerRole(context);

    if (!data || !data.productId || !data.price || !data.discount || !data.retail) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with the next arguments "ProductId, Price, Discount, Retail"');
    }

    function createData(id, vendor, brand, number, retail, price, available, discount) {
        return {
            id,
            vendor,
            brand,
            number,
            retail,
            price,
            available,
            discount
        };
    }

    return [
        createData(1, 'ELIT','BERU', 'Z30',  64.53, 41.855, 1, 35 ),
        createData(2,'IC', 'BERU', 'Z30',  51.30, 34.95, 5, 35),
        createData(3,'ELIT',  'BERU', 'Z30', 24.40, 26.10, 5, 30),
        createData(4,'VA',  'BERU', 'Z30',  24.99, 34.10, 5, 30),
        createData(17,'ELIT',  'RUVILE', '5413',  24.99, 34.10, 0, 0),
        createData(18,'IC',  'RUVILE', '5413',  49.44, 43.29, 0, 0),
        createData(19,'ELIT',  'RUVILE', '5413', 87.90, 46.50, 0, 0)
    ];

};

module.exports = updatePrice;