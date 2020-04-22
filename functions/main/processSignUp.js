const RoleEnum = require('../RoleEnum');
const admin = require('firebase-admin');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const managers = ['admin@fenix.com'];

const processSignUp = (user) => {
    // Check if user meets role criteria.
    let emailVerified = false;
    let customClaims = {};


    const dbUser =  sql.connect(config).then(pool => {
        return pool.request()
            .input('email', sql.VarChar(10), user.email)
            .execute('sp_web_getclientbyemail')
    }).then(result => {
        return result.recordset;
    }).catch(err => {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
    });



    if(managers.includes(user.email)) {
        emailVerified = true;
        customClaims = {
            role: RoleEnum.Manager,
            vip: dbUser.vip
        };
    } else if(dbUser.isWebUser) {
        emailVerified = true;
        customClaims = {
            role: RoleEnum.Client,
            vip: dbUser.vip
        };
    }

    if (user.email && emailVerified) {
        // Set custom user claims on this newly created user.
        return admin.auth().setCustomUserClaims(user.uid, customClaims)
            .then(() => {
                // Update real-time database to notify client to force refresh.
                const metadataRef = admin.database().ref("metadata/" + user.uid);
                // Set the refresh time to the current UTC timestamp.
                // This will be captured on the client to force a token refresh.
                return metadataRef.set({refreshTime: new Date().getTime()});
            })
            .catch(error => {
                console.log(error);
            });
    } else {
        return admin.auth().deleteUser(user.uid)
            .then(() => {
                // Update real-time database to notify client to force refresh.
                const metadataRef = admin.database().ref("metadata/" + user.uid);
                // Set the refresh time to the current UTC timestamp.
                // This will be captured on the client to force a token refresh.
                return metadataRef.set({refreshTime: new Date().getTime()});
            })
            .catch(error => {
                console.log(error);
            });
    }
};
module.exports = processSignUp;