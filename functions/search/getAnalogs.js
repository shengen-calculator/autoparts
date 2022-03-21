const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const getAnalogs = async (data, context) => {

    util.checkForManagerRole(context);

    try {
        await sql.connect(config);

        if(data.analogId === 0) {
            const query = `
                    SELECT TOP (1) dbo.[Каталог запчастей].ID_аналога AS analogId
                    FROM dbo.[Каталог запчастей]
                             INNER JOIN
                         dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда
                    WHERE (dbo.[Каталог запчастей].NAME = '${data.number}')
                      AND (dbo.Брэнды.Брэнд = '${data.brand}')
                    ORDER BY dbo.[Каталог запчастей].ID_аналога DESC
            `;
            const result = await sql.query(query);
            if(result.recordset.length) {
                data.analogId  = result.recordset[0]['analogId'];
            }
        }

        const query = `
                    SELECT TOP (500) dbo.[Каталог запчастей].ID_Запчасти               AS productId,
                             RTRIM(dbo.Поставщики.[Сокращенное название])              AS vendor,
                             RTRIM(dbo.Брэнды.Брэнд)                                   AS brand,
                             RTRIM(dbo.[Каталог запчастей].[Номер запчасти])           AS number,
                             dbo.[Каталог запчастей].Цена7                             AS price,
                             dbo.[Каталог запчастей].Цена                              AS retail,
                             dbo.[Каталог запчастей].Скидка                            AS discount,
                             ISNULL(dbo.Остаток_.Остаток, 0)                           AS stock,
                             dbo.GetVendorPrice(dbo.[Каталог запчастей].ID_Запчасти)   AS vendorPrice,
                             dbo.GetPurchasePrice(dbo.[Каталог запчастей].ID_Запчасти) AS purchasePrice
                    FROM dbo.[Каталог запчастей]
                             INNER JOIN
                         dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда
                             INNER JOIN
                         dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика
                             LEFT OUTER JOIN
                         dbo.Остаток_ ON dbo.[Каталог запчастей].ID_Запчасти = dbo.Остаток_.ID_Запчасти
                    WHERE (dbo.[Каталог запчастей].ID_аналога = ${data.analogId})

        `;
        const result = await sql.query(query);
        return result.recordset;
    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {err: err.message};
    }

};

module.exports = getAnalogs;