const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;
const getOrdersByVip = async (data, context) => {


    if (data) {
        util.checkForManagerRole(context);
    } else {
        util.checkForClientRole(context);
    }


//status list
//подтвержден = 0
//в обработке = 1
//неполное количество = 2
//задерживается = 3
//нет в наличии = 4

    try {
        await sql.connect(config);

        let query = `
                SELECT DISTINCT TOP (100) TRIM(VIP) as vip
        `;

        if(data) {
            query += `
                ,TRIM([Сокращенное название]) AS vendor, Альтернатива as note
            `;
        }

        query += `
            ,ID_Запроса as id
            ,TRIM(Брэнд) as brand
            ,TRIM([Номер поставщика]) as number
            ,Заказано as ordered
            ,Подтверждение as approved
            ,FORMAT(ISNULL(Предварительная_дата, Дата_прихода), 'dd.MM.yyyy') as shipmentDate
            ,Цена as euro
            ,Грн as uah
            ,ID_Запчасти as productId
            ,ID_Заказа as orderId
            ,FORMAT (Дата, 'dd.MM.yyyy HH:mm') as orderDate
            ,TRIM(Описание) as description
            ,CASE
            WHEN Задерживается = 1 THEN 3  /* задерживается */
            WHEN Нет = 1 THEN 4  /* нету */
            WHEN Заказано = Подтверждение AND Подтверждение > 0 THEN 0 /* подтвержден */
            WHEN Подтверждение = 0 AND Нет = 0 THEN 1  /* в обработке */
            WHEN Заказано > Подтверждение AND Подтверждение > 0 THEN 2  /* неполное кол-во */
            ELSE 1
            END as status
            FROM   dbo.Запросы
            WHERE  VIP like '${data ? data : context.auth.token.vip}' AND [Обработано] = 0 AND [ID_Клиента] <> 378 AND ([Нет] = 0 OR DATEDIFF(hour, [Дата], SYSDATETIME()) < 168)
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

module.exports = getOrdersByVip;