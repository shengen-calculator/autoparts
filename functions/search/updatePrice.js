const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const updatePrice = async (data, context) => {

    util.checkForManagerRole(context);

    if (!data || !data.productId || typeof data.price === 'undefined' || typeof data.discount === 'undefined') {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with the next arguments "ProductId, Price, Discount"');
    }

    try {
        await sql.connect(config);
        const retail = data.price / (100 - data.discount) * 100;

        const query = `
                UPDATE dbo.[Каталог запчастей]
                SET Скидка          = ${data.price === 0 ? null : data.discount},
                    Цена            = ${data.price === 0 ? null : retail},
                    Цена4           = ${data.price === 0 ? null : data.price / 1.04},
                    Цена14          = ${data.price === 0 ? null : data.price / 1.02},
                    Цена12          = ${data.price === 0 ? null : data.price / 1.06},
                    Цена5           = ${data.price === 0 ? null : (1 - (1 - 0.75) * data.discount / 35) * retail},
                    Цена6           = ${data.price === 0 ? null : (1 - (1 - 0.7) * data.discount / 35) * retail},
                    Цена1           = ${data.price === 0 ? null : (1 - (1 - 0.95) * data.discount / 35) * retail},
                    Цена2           = ${data.price === 0 ? null : (1 - (1 - 0.9) * data.discount / 35) * retail},
                    Цена3           = ${data.price === 0 ? null : (1 - (1 - 0.85) * data.discount / 35) * retail},
                    Цена10          = ${data.price === 0 ? null : (1 - (1 - 0.55) * data.discount / 40) * retail},
                    Цена7           = ${data.price === 0 ? null : data.price},
                    Цена13          = ${data.price === 0 ? null : data.price},
                    Цена_обработана = ${data.price === 0 ? 0 : 1}
                WHERE ID_Запчасти = ${data.productId}
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
