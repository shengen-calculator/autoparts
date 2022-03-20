const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;
const {Datastore} = require('@google-cloud/datastore');

const getClientStatistic = async (data, context) => {
    util.checkForManagerRole(context);

    if (!data || !data.startDate || !data.endDate) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with two arguments "start date" and "end date"');
    }

    try {
        await sql.connect(config);

        const datastore = new Datastore();

        const storeQuery = datastore
            .createQuery('queries','')
            .filter('date', '>=', new Date(`${data.startDate} 00:00:00:000`))
            .filter('date', '<=', new Date(`${data.endDate} 23:59:59:999`))
            .limit(2000);

        const sqlQuery = `
                SELECT ISNULL(RES.ID_Клиента, ORD.ID_Клиента) AS ClientId,
                       RTRIM(ISNULL(RES.VIP, ORD.VIP))        AS VIP,
                       RTRIM(ISNULL(RES.EMail, ORD.EMail))    AS Email,
                       ISNULL(RES.Reserves, 0)                AS Reserves,
                       ISNULL(ORD.Orders, 0)                  AS Orders
                FROM (SELECT dbo.Клиенты.ID_Клиента,
                             dbo.Клиенты.VIP,
                             dbo.Клиенты.EMail,
                             COUNT(dbo.[Подчиненная накладные].ID) AS Reserves
                      FROM dbo.Клиенты
                               LEFT OUTER JOIN
                           dbo.[Подчиненная накладные] ON dbo.Клиенты.ID_Клиента = dbo.[Подчиненная накладные].ID_Клиента
                      WHERE (CONVERT(date, dbo.[Подчиненная накладные].Дата) >= '${data.startDate}')
                        AND (CONVERT(date, dbo.[Подчиненная накладные].Дата) <= '${data.endDate}')
                        AND dbo.[Подчиненная накладные].Заказ IS NULL
                      GROUP BY dbo.Клиенты.ID_Клиента, dbo.Клиенты.VIP, dbo.Клиенты.EMail
                      HAVING (dbo.Клиенты.ID_Клиента <> 378)) AS RES
                         FULL OUTER JOIN (SELECT dbo.Клиенты.ID_Клиента,
                                                 dbo.Клиенты.VIP,
                                                 dbo.Клиенты.EMail,
                                                 COUNT(dbo.[Запросы клиентов].ID_Запроса) AS Orders
                                          FROM dbo.Клиенты
                                                   INNER JOIN
                                               dbo.[Запросы клиентов] ON dbo.Клиенты.ID_Клиента = dbo.[Запросы клиентов].ID_Клиента
                                          WHERE (dbo.[Запросы клиентов].Заказано > 0)
                                            AND (dbo.[Запросы клиентов].Интернет = 1)
                                            AND (CONVERT(date, dbo.[Запросы клиентов].Дата) <= '${data.endDate}')
                                            AND (CONVERT(date, dbo.[Запросы клиентов].Дата) >= '${data.startDate}')
                                          GROUP BY dbo.Клиенты.ID_Клиента, dbo.Клиенты.VIP, dbo.Клиенты.EMail
                                          HAVING (dbo.Клиенты.ID_Клиента <> 378)) AS ORD ON RES.ID_Клиента = ORD.ID_Клиента
        `;

        const [stat, totals] = await Promise.all([
            datastore.runQuery(storeQuery),
            sql.query(sqlQuery)
        ]);
        const dateTimeFormat = new Intl.DateTimeFormat('en', { year: 'numeric', month: '2-digit', day: '2-digit' });

        return  {
            statistic: stat[0].map(x => {
                const [{ value: month },,{ value: day },,{ value: year }] = dateTimeFormat.formatToParts(x.date);
                return {
                    vip: x.vip,
                    brand: x.brand,
                    number: x.number,
                    query: x.query,
                    available: x.available,
                    success: x.success,
                    date: `${day}-${month}-${year }`
                }
            }),
            totals: totals.recordset
        };

    } catch (err) {
        if (err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {error: err.message};
    }

};

module.exports = getClientStatistic;