const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const getVendorStatistic = async (data, context) => {

    util.checkForManagerRole(context);

    try {
        await sql.connect(config);

        const query = `
                SELECT        TOP (100) 
                dbo.[Каталог запчастей].ID_Поставщика AS vendorId
                ,TRIM(dbo.Поставщики.[Сокращенное название]) AS vendor
                ,COUNT(dbo.[Запросы клиентов].ID_Запроса) AS quantity
                FROM            dbo.[Каталог запчастей] INNER JOIN
                                         dbo.[Запросы клиентов] ON dbo.[Каталог запчастей].ID_Запчасти = dbo.[Запросы клиентов].ID_Запчасти INNER JOIN
                                         dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика
                WHERE        (dbo.[Запросы клиентов].Подтверждение = 0) AND (dbo.[Запросы клиентов].Интернет = 1) AND (dbo.[Запросы клиентов].Обработано = 0) AND (dbo.[Запросы клиентов].Заказано > 0) AND 
                                         (dbo.[Запросы клиентов].ID_Клиента <> 378)
                GROUP BY dbo.[Каталог запчастей].ID_Поставщика, dbo.Поставщики.[Сокращенное название]
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

module.exports = getVendorStatistic;