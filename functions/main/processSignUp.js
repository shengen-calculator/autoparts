const RoleEnum = require('../RoleEnum');
const admin = require('firebase-admin');

const managers = ['pete@mail.com'];
const clients = ['client@mail.com'];

const processSignUp = (user) => {
    // Check if user meets role criteria.
    let emailVerified = false;
    let customClaims = {};
    if(managers.includes(user.email)) {
        emailVerified = true;
        customClaims = {
            role: RoleEnum.Manager,
            vip: "3000"
        };
    }
    if(clients.includes(user.email)) {
        emailVerified = true;
        customClaims = {
            role: RoleEnum.Client,
            vip: "1000"
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