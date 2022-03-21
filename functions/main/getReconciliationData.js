const functions = require('firebase-functions');
const reconciliationXls = require('./reconciliationXls');
const sql = require('mssql');
const config = require('../mssql.connection').config;
const util = require('../util');

const getReconciliationData = async (data, context) => {

    if (data.clientId) {
        util.checkForManagerRole(context);
    } else {
        util.checkForClientRole(context);
    }
    try {
        const pool = await sql.connect(config);

        const [records, balance] = await Promise.all([
            pool.request()
                .input('clientId', sql.Int, data.clientId ? data.clientId : context.auth.token.clientId)
                .input('startDate', sql.Date, data.startDate)
                .input('endDate', sql.Date, data.endDate)
                .query(`
                        SELECT dbo.[Подчиненная накладные].ID                 AS id,
                               dbo.[Подчиненная накладные].ID_Накладной       AS invoiceNumber,
                               dbo.[Подчиненная накладные].Количество         AS quantity,
                               dbo.[Подчиненная накладные].Цена               AS priceEur,
                               dbo.[Подчиненная накладные].Грн                AS priceUah,
                               IIF(dbo.[Подчиненная накладные].Количество > 0,
                                   dbo.GetInvoiceDate(dbo.[Подчиненная накладные].ID_Накладной),
                                   dbo.[Подчиненная накладные].Дата_закрытия) AS invoiceDate,
                               dbo.Брэнды.Брэнд                               AS brand,
                               dbo.[Каталог запчастей].[Номер поставщика]     AS number,
                               dbo.[Каталог запчастей].Описание               AS description
                        FROM dbo.[Подчиненная накладные]
                                 INNER JOIN
                             dbo.[Каталог запчастей] ON dbo.[Подчиненная накладные].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти
                                 INNER JOIN
                             dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда
                        WHERE (dbo.[Подчиненная накладные].ID_Накладной IS NOT NULL)
                          AND (dbo.[Подчиненная накладные].Дата_закрытия IS NOT NULL)
                          AND (dbo.[Подчиненная накладные].ID_Клиента = @clientId)
                          AND (dbo.[Подчиненная накладные].Нету = 0)
                          AND (dbo.[Подчиненная накладные].Обработано = 1)
                          AND (IIF(dbo.[Подчиненная накладные].Количество > 0,
                                   dbo.GetInvoiceDate(dbo.[Подчиненная накладные].ID_Накладной),
                                   dbo.[Подчиненная накладные].Дата_закрытия) >= @startDate)
                          AND (IIF(dbo.[Подчиненная накладные].Количество > 0,
                                   dbo.GetInvoiceDate(dbo.[Подчиненная накладные].ID_Накладной),
                                   dbo.[Подчиненная накладные].Дата_закрытия) < DATEADD(day, 1, @endDate))
                        UNION
                    
                        SELECT ID_Касса            as id,
                               0                   as invoiceNumber,
                               0                   as quantity,
                               Цена                as priceEur,
                               Грн                 as priceUah,
                               CONVERT(date, Дата) AS invoiceDate,
                               ''                  as brand,
                               ''                  as number,
                               Примечание          as description
                        FROM dbo.Касса
                        WHERE (ID_Клиента = @clientId)
                          AND (CONVERT(date, Дата) >= @startDate)
                          AND (CONVERT(date, Дата) < DATEADD(day, 1, @endDate))
                        ORDER BY InvoiceDate, invoiceNumber
                `),
            pool.request()
                .input('clientId', sql.Int, data.clientId ? data.clientId : context.auth.token.clientId)
                .input('day', sql.Date, data.startDate)
                .query('SELECT dbo.GetBalanceOnDate(@clientId, @day) as result')
        ]);

        const fileName = data.clientId ? `K0000${context.auth ? context.auth.token.vip : 'test'}-${data.clientId}.xlsx` :
            `K0000${context.auth.token.vip}.xlsx`;
        const initialBalance = balance.recordset[0]['result'] ? balance.recordset[0]['result'] : 0;
        console.log(initialBalance);
        return await reconciliationXls.getReconciliationXlsLink(records.recordset,
            initialBalance, fileName, data.startDate, data.endDate, data.isEuroClient);

    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {error: err.message};
    }

};

module.exports = getReconciliationData;
