const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;
const {Datastore} = require('@google-cloud/datastore');
const RoleEnum = require('../RoleEnum');

const searchByBrandAndNumber = async (data, context) => {

    if (data && data.clientId) {
        util.checkForManagerRole(context);
    } else {
        util.checkForClientRole(context);
    }

    if (!data ||!data.number ||!data.brand) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with at least two arguments "Brand and Number"');
    }

    try {
        const pool = await sql.connect(config);

        const requests = [
            pool.request()
                .input('number', sql.VarChar(25), data.number)
                .input('brand', sql.VarChar(18), data.brand)
                .input('clientId', sql.Int, data.clientId ? data.clientId : context.auth.token.clientId)
                .input('isVendorShown', sql.Bit, data.clientId ? 1 : 0)
                .input('isPartsFromAllVendorShown', sql.Bit, data.clientId ? 1 : 0)
                .execute('sp_web_getproductsbybrand'),

        ];
        if(data.analogId) {
            //check if present in order list by analog
            const query = `
                    SELECT RTRIM(dbo.Клиенты.VIP)                        AS vip,
                           RTRIM(dbo.Поставщики.[Сокращенное название])  AS vendor,
                           RTRIM(Брэнды_1.Брэнд)                         AS brand,
                           RTRIM([Каталог запчастей_1].[Номер запчасти]) AS number,
                           dbo.[Запросы клиентов].Заказано               AS quantity,
                           RTRIM(dbo.[Запросы клиентов].Примечание)      AS note,
                           dbo.[Запросы клиентов].Дата_заказа            AS date,
                           dbo.[Запросы клиентов].Срочно                 AS isUrgent,
                           dbo.[Заказы поставщикам].Предварительная_дата AS preliminaryDate,
                           AnalogTable.analogId                          AS analogId
                    FROM (SELECT MAX(dbo.[Каталог запчастей].ID_аналога) AS analogId
                          FROM dbo.[Каталоги поставщиков]
                                   INNER JOIN
                               dbo.Брэнды ON dbo.[Каталоги поставщиков].Брэнд = dbo.Брэнды.Брэнд
                                   INNER JOIN
                               dbo.[Каталог запчастей] ON dbo.Брэнды.ID_Брэнда = dbo.[Каталог запчастей].ID_Брэнда AND
                                                          dbo.[Каталоги поставщиков].Name = dbo.[Каталог запчастей].namepost
                          WHERE (dbo.[Каталог запчастей].ID_аналога = ${data.analogId})) AS AnalogTable
                             INNER JOIN
                         dbo.[Каталог запчастей] AS [Каталог запчастей_1] ON AnalogTable.analogId = [Каталог запчастей_1].ID_аналога
                             INNER JOIN
                         dbo.[Запросы клиентов] ON [Каталог запчастей_1].ID_Запчасти = dbo.[Запросы клиентов].ID_Запчасти
                             INNER JOIN
                         dbo.Клиенты ON dbo.[Запросы клиентов].ID_Клиента = dbo.Клиенты.ID_Клиента
                             INNER JOIN
                         dbo.Брэнды AS Брэнды_1 ON [Каталог запчастей_1].ID_Брэнда = Брэнды_1.ID_Брэнда
                             INNER JOIN
                         dbo.Поставщики ON [Каталог запчастей_1].ID_Поставщика = dbo.Поставщики.ID_Поставщика
                             LEFT OUTER JOIN
                         dbo.[Заказы поставщикам] ON dbo.[Запросы клиентов].ID_Заказа = dbo.[Заказы поставщикам].ID_Заказа
                    WHERE (dbo.[Запросы клиентов].Заказано <> 0)
                      AND (dbo.[Запросы клиентов].Доставлено = 0)
                      AND (dbo.[Запросы клиентов].Обработано = 0)
            `;
            requests.push(sql.query(query));
        } else {
            //check if present in order list by brand and number
            const query = `
                    SELECT RTRIM(dbo.Клиенты.VIP)                        AS vip,
                           RTRIM(dbo.Поставщики.[Сокращенное название])  AS vendor,
                           RTRIM(Брэнды_1.Брэнд)                         AS brand,
                           RTRIM([Каталог запчастей_1].[Номер запчасти]) AS number,
                           dbo.[Запросы клиентов].Заказано               AS quantity,
                           RTRIM(dbo.[Запросы клиентов].Примечание)      AS note,
                           dbo.[Запросы клиентов].Дата_заказа            AS date,
                           dbo.[Запросы клиентов].Срочно                 AS isUrgent,
                           dbo.[Заказы поставщикам].Предварительная_дата AS preliminaryDate,
                           AnalogTable.analogId                          AS analogId
                    FROM (SELECT MAX(dbo.[Каталог запчастей].ID_аналога) AS analogId
                          FROM dbo.[Каталоги поставщиков]
                                   INNER JOIN
                               dbo.Брэнды ON dbo.[Каталоги поставщиков].Брэнд = dbo.Брэнды.Брэнд
                                   INNER JOIN
                               dbo.[Каталог запчастей] ON dbo.Брэнды.ID_Брэнда = dbo.[Каталог запчастей].ID_Брэнда AND
                                                          dbo.[Каталоги поставщиков].Name = dbo.[Каталог запчастей].namepost
                          WHERE (dbo.Брэнды.Брэнд = '${data.brand}')
                            AND (dbo.[Каталоги поставщиков].Name = '${data.number}')) AS AnalogTable
                             INNER JOIN
                         dbo.[Каталог запчастей] AS [Каталог запчастей_1] ON AnalogTable.analogId = [Каталог запчастей_1].ID_аналога
                             INNER JOIN
                         dbo.[Запросы клиентов] ON [Каталог запчастей_1].ID_Запчасти = dbo.[Запросы клиентов].ID_Запчасти
                             INNER JOIN
                         dbo.Клиенты ON dbo.[Запросы клиентов].ID_Клиента = dbo.Клиенты.ID_Клиента
                             INNER JOIN
                         dbo.Брэнды AS Брэнды_1 ON [Каталог запчастей_1].ID_Брэнда = Брэнды_1.ID_Брэнда
                             INNER JOIN
                         dbo.Поставщики ON [Каталог запчастей_1].ID_Поставщика = dbo.Поставщики.ID_Поставщика
                             LEFT OUTER JOIN
                         dbo.[Заказы поставщикам] ON dbo.[Запросы клиентов].ID_Заказа = dbo.[Заказы поставщикам].ID_Заказа
                    WHERE (dbo.[Запросы клиентов].Заказано <> 0)
                      AND (dbo.[Запросы клиентов].Доставлено = 0)
                      AND (dbo.[Запросы клиентов].Обработано = 0)
            `;
            requests.push(sql.query(query));
        }

        const [search, inOrder] = await Promise.all(requests);


        if(context.auth.token.role === RoleEnum.Client && data.queryId) {
            const datastore = new Datastore();

            const queryKey = datastore.key(['queries', Number.parseInt(data.queryId)]);
            const query = {
                date: new Date(),
                brand: data.brand,
                number: data.originalNumber,
                available: getAvailability(search.recordset),
                success: true,
                vip: context.auth.token.vip
            };
            const entity = {
                key: queryKey,
                data: query,
            };
            datastore.update(entity);
        }
        const dateTimeFormat = new Intl.DateTimeFormat('en', { year: 'numeric', month: '2-digit', day: '2-digit' });

        return {
            search: search.recordset,
            inOrder: inOrder.recordset.map(x => {
                const [{ value: month },,{ value: day },,{ value: year }] = dateTimeFormat.formatToParts(x.preliminaryDate);
                return {
                    vip: x.vip,
                    vendor: x.vendor,
                    brand: x.brand,
                    number: x.number,
                    quantity: x.quantity,
                    note: x.note,
                    preliminaryDate: x.preliminaryDate ? `${day}-${month}-${year }` : '',
                    analogId: x.analogId
                }
            })
        };
    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {err: err.message};
    }
};

function getAvailability(data) {
    for (let i = 0; i < data.length; i++) {
        if(data[i].available > 0) {
            return true;
        }
    }
    return false;
}

module.exports = searchByBrandAndNumber;