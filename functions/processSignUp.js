const admin = require('firebase-admin');

const processSignUp = (user) => {
    // Check if user meets role criteria.
    const emailVerified = true;
    if (user.email && emailVerified) {
        const customClaims = {
            role: "Manager",
            vip: "z0777"
        };
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
    }
};
module.exports = processSignUp;