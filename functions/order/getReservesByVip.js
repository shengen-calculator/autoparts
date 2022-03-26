const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const getReservesByVip = async (data, context) => {


    if (data) {
        util.checkForManagerRole(context);
    } else {
        util.checkForClientRole(context);
    }

//source
// склад = 0
// заказ = 1

    try {
        await sql.connect(config);

        let query = `
                  SELECT TOP (100) [ID] as id
        `;

        if(data) {
                query += `
                  ,TRIM([Поставщик]) as vendor, TRIM([Статус]) as note
            `;
        }
        query += `
                  ,[ID_Накладной] as invoiceId
                      ,TRIM([VIP]) as vip
                      ,TRIM([Брэнд]) as brand
                      ,[Количество] as quantity
                      ,[Цена] as euro
                      ,[Грн] as uah
                      ,[ID_Клиента] as clientId
                      ,[ID_Запчасти] as productId
                      ,TRIM([Описание]) as description      
                      ,FORMAT([Дата резерва], 'dd.MM.yy HH:mm') as 'date'
                      ,FORMAT([Дата запроса], 'dd.MM.yy') as orderDate
                      ,[Интернет] as source
                      ,TRIM([Номер поставщика]) as number
                  FROM [dbo].[Накладные]
                  WHERE  VIP like '${data ? data : context.auth.token.vip}' AND [Обработано] = 0 AND [ID_Клиента] <> 378

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

module.exports = getReservesByVip;