const RoleEnum = require('../RoleEnum');
const admin = require('firebase-admin');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const managers = ['puhach.alex@fenix.parts', 'ucin.sergiy@fenix.parts', 'test@fenix.parts'];

const processSignUp = async (user) => {
    // Check if user meets role criteria.
    let emailVerified = false;
    let customClaims = {};

    try {
        const pool = await sql.connect(config);

        const result = await pool.request()
            .input('email', sql.VarChar(40), user.email)
            .execute('sp_web_getclientbyemail');
        let client = {};

        if (result.recordset.length > 0) {
            client = result.recordset[0];
        }

        if (managers.includes(user.email)) {
            emailVerified = true;
            customClaims = {
                role: RoleEnum.Manager,
                vip: client.vip
            }
        } else if (client && client.isWebUser) {
            emailVerified = true;
            customClaims = {
                role: RoleEnum.Client,
                vip: client.vip
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