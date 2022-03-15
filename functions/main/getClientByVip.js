const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const getClientByVip = async (data, context) => {

    if (data) {
        util.checkForManagerRole(context);
    } else {
        util.checkForClientRole(context);
    }

    try {
        await sql.connect(config);

        const query = `
                SELECT TOP (3)
                    ID_Клиента as id
                    ,TRIM([VIP]) as vip
                    ,TRIM([Фамилия]) + ' ' + TRIM([Имя]) as fullName     
                    ,[Расчет_в_евро] as isEuroClient      
                    ,[Интернет_заказы] as isWebUser
                    ,IsCityDeliveryUsed as isCityDeliveryUsed
                FROM [FenixParts].[dbo].[Клиенты]
                WHERE VIP like '${data ? data : context.auth.token.vip}'
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

module.exports = getClientByVip;