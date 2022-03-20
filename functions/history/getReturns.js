const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const getReturns = async (data, context) => {

    if (data && data.vip) {
        util.checkForManagerRole(context);
    } else {
        util.checkForClientRole(context);
    }

    try {
        await sql.connect(config);

        const query = `
            SELECT dbo.[Подчиненная накладные].ID                                          AS id,
                   dbo.[Подчиненная накладные].ID_Накладной                                AS invoiceNumber,
                   dbo.[Подчиненная накладные].Количество                                  AS quantity,
                   dbo.[Подчиненная накладные].Цена                                        AS priceEur,
                   dbo.[Подчиненная накладные].Грн                                         AS priceUah,
                   FORMAT(dbo.GetInvoiceDate(
                                  dbo.[Подчиненная накладные].ID_Накладной), 'dd.MM.yyyy') AS invoiceDate,
                   TRIM(dbo.Брэнды.Брэнд)                                                  AS brand,
                   TRIM(dbo.[Каталог запчастей].[Номер поставщика])                        AS number,
                   TRIM(dbo.[Каталог запчастей].Описание)                                  AS description,
                   COUNT(*) OVER ()                                                        AS totalCount
            FROM dbo.[Подчиненная накладные]
                     INNER JOIN
                 dbo.[Каталог запчастей] ON dbo.[Подчиненная накладные].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти
                     INNER JOIN
                 dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда
                     INNER JOIN
                 dbo.Клиенты ON dbo.[Подчиненная накладные].ID_Клиента = dbo.Клиенты.ID_Клиента
            WHERE (dbo.[Подчиненная накладные].ID_Накладной IS NOT NULL)
              AND (dbo.[Подчиненная накладные].Дата_закрытия IS NOT NULL)
              AND (dbo.Клиенты.VIP LIKE ${data.vip ? data.vip : context.auth.token.vip})
              AND (dbo.[Подчиненная накладные].Нету = 0)
              AND (dbo.[Подчиненная накладные].Обработано = 1)
              AND (dbo.[Подчиненная накладные].Количество < 0)
            ORDER BY dbo.[Подчиненная накладные].ID DESC OFFSET ${data.offset ? data.offset : 0} ROWS FETCH NEXT ${(data.rows && data.rows < 101) ? data.rows : 10} ROWS ONLY
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

module.exports = getReturns;