const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const updatePrice = async (data, context) => {

    util.checkForManagerRole(context);
    const {productId, price, discount} = data;

    if (!data || !productId || typeof price === 'undefined' || typeof discount === 'undefined') {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with the next arguments "ProductId, Price, Discount"');
    }

    try {
        await sql.connect(config);
        const retail = price / (100 - discount) * 100;

        const query = `
                UPDATE dbo.[Каталог запчастей]
                SET Скидка          = ${price === 0 ? null : discount},
                    Цена            = ${price === 0 ? null : retail},
                    Цена4           = ${price === 0 ? null : price / 1.04},
                    Цена14          = ${price === 0 ? null : price / 1.02},
                    Цена12          = ${price === 0 ? null : price / 1.06},
                    Цена5           = ${price === 0 ? null : (1 - (1 - 0.75) * discount / 35) * retail},
                    Цена6           = ${price === 0 ? null : (1 - (1 - 0.7) * discount / 35) * retail},
                    Цена1           = ${price === 0 ? null : (1 - (1 - 0.95) * discount / 35) * retail},
                    Цена2           = ${price === 0 ? null : (1 - (1 - 0.9) * discount / 35) * retail},
                    Цена3           = ${price === 0 ? null : (1 - (1 - 0.85) * discount / 35) * retail},
                    Цена10          = ${price === 0 ? null : (1 - (1 - 0.55) * discount / 40) * retail},
                    Цена7           = ${price === 0 ? null : price},
                    Цена13          = ${price === 0 ? null : price},
                    Цена_обработана = ${price === 0 ? 0 : 1}
                WHERE ID_Запчасти = ${productId}
        `;

        const result = await sql.query(query);
        return result.recordset;
    } catch (err) {
        if (err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {err: err.message};
    }
};

module.exports = updatePrice;
