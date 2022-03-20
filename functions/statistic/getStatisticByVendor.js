const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const getStatisticByVendor = async (data, context) => {

    util.checkForManagerRole(context);

    if (!data) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with one argument "vendorId"');
    }

    try {
        await sql.connect(config);

        const query = `            	
                SELECT TOP(200) [Запросы клиентов].ID_Запроса AS id    
                    ,TRIM([Запросы клиентов].Работник) AS vip		
                    ,TRIM(Брэнды.Брэнд) AS brand
                    ,TRIM([Каталог запчастей].[Номер запчасти]) AS number
                    ,[Запросы клиентов].Заказано AS quantity
                    ,[Запросы клиентов].Цена AS price
                    ,FORMAT([Запросы клиентов].Дата, 'd', 'de-de') AS date
                    ,ISNULL(Остаток_по_аналогу.Остаток,0) AS available
                FROM         [Каталог запчастей] INNER JOIN
                                 [Запросы клиентов] ON [Каталог запчастей].ID_Запчасти = [Запросы клиентов].ID_Запчасти INNER JOIN
                                  Брэнды ON [Каталог запчастей].ID_Брэнда = Брэнды.ID_Брэнда LEFT OUTER JOIN
                                  Остаток_по_аналогу ON [Каталог запчастей].ID_аналога = Остаток_по_аналогу.ID_аналога
                WHERE     ([Запросы клиентов].Подтверждение = 0) AND ([Запросы клиентов].Интернет = 1) AND ([Запросы клиентов].Обработано = 0) AND 
                                      ([Запросы клиентов].Заказано > 0) AND ([Запросы клиентов].ID_Клиента <> 378) AND ([Каталог запчастей].ID_Поставщика = ${data}) 
                ORDER BY [Запросы клиентов].Дата DESC
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

module.exports = getStatisticByVendor;