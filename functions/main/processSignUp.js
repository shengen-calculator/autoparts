const RoleEnum = require('../RoleEnum');
const admin = require('firebase-admin');
const sql = require('mssql');
const Admins = require('../admins');
const Managers = require('../managers');
const config = require('../mssql.connection').config;

const processSignUp = async (user) => {
    // Check if user meets role criteria.
    let emailVerified = false;
    let customClaims = {};

    try {
        await sql.connect(config);

        const query = `
                  SELECT TOP (3)
                       ID_Клиента as id
                      ,TRIM([VIP]) as vip
                      ,TRIM([Фамилия]) + ' ' + TRIM([Имя]) as fullName     
                      ,[Расчет_в_евро] as isEuroClient      
                      ,[Интернет_заказы] as isWebUser
                  FROM [FenixParts].[dbo].[Клиенты]
                  WHERE EMail like '${user.email}'
        `;

        const result = await sql.query(query);
        let client = {};

        if (result.recordset.length > 0) {
            client = result.recordset[0];
        }

        if (Admins.includes(user.email)) {
            emailVerified = true;
            customClaims = {
                role: RoleEnum.Admin,
                vip: client.vip,
                clientId: client.id
            }
        } else if (Managers.includes(user.email)) {
            emailVerified = true;
            customClaims = {
                role: RoleEnum.Manager,
                vip: client.vip,
                clientId: client.id
            }
        } else if (client && client.isWebUser) {
            emailVerified = true;
            customClaims = {
                role: RoleEnum.Client,
                vip: client.vip,
                clientId: client.id
            }
        }
        console.log(client);

        if (user.email && emailVerified) {
            // Set custom user claims on this newly created user.
            await admin.auth().setCustomUserClaims(user.uid, customClaims);

            // Update real-time database to notify client to force refresh.
            const metadataRef = admin.database().ref("metadata/" + user.uid);
            // Set the refresh time to the current UTC timestamp.
            // This will be captured on the client to force a token refresh.
            return metadataRef.set({refreshTime: new Date().getTime()});

        } else {
            await admin.auth().deleteUser(user.uid);

            // Update real-time database to notify client to force refresh.
            const metadataRef = admin.database().ref("metadata/" + user.uid);
            // Set the refresh time to the current UTC timestamp.
            // This will be captured on the client to force a token refresh.
            return metadataRef.set({refreshTime: new Date().getTime()});
        }


    } catch (err) {
        if (err) {
            console.log(err.message);
        }
        return {error: err.message};
    }
};
module.exports = processSignUp;
