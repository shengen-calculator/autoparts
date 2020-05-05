const functions = require('firebase-functions');
const RoleEnum = require('./RoleEnum');

const checkForManagerRole = (context) => {

    if (!process.env.FUNCTIONS_EMULATOR) {
        if (!context.auth) {
            throw new functions.https.HttpsError('failed-precondition',
                'The function must be called while authenticated.');
        } else if(context.auth.token.role !== RoleEnum.Manager) {
            throw new functions.https.HttpsError('failed-precondition',
                'Only manager can call this function');
        }
    }
};


const checkForClientRole = (context) => {

    if (!process.env.FUNCTIONS_EMULATOR) {
        if (!context.auth) {
            throw new functions.https.HttpsError('failed-precondition',
                'The function must be called while authenticated.');
        } else if(context.auth.token.role !== RoleEnum.Manager && context.auth.token.role !== RoleEnum.Client) {
            throw new functions.https.HttpsError('failed-precondition',
                'Only manager or client can call this function');
        }
    }
};

module.exports.CheckForManagerRole = checkForManagerRole;
module.exports.checkForClientRole = checkForClientRole;