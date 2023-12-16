const functions = require('firebase-functions');
const RoleEnum = require('./RoleEnum');

const checkForAdminRole = (context) => {

    if (!process.env.FUNCTIONS_EMULATOR) {
        if (!context.auth) {
            throw new functions.https.HttpsError('failed-precondition',
                'The function must be called while authenticated.');
        } else if(context.auth.token.role !== RoleEnum.Admin) {
            throw new functions.https.HttpsError('failed-precondition',
                'Only administrator can call this function');
        }
    }
};

const checkForManagerRole = (context) => {

    if (!process.env.FUNCTIONS_EMULATOR) {
        if (!context.auth) {
            throw new functions.https.HttpsError('failed-precondition',
                'The function must be called while authenticated.');
        } else if(context.auth.token.role !== RoleEnum.Manager && context.auth.token.role !== RoleEnum.Admin) {
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
        } else if(context.auth.token.role !== RoleEnum.Manager &&
            context.auth.token.role !== RoleEnum.Client &&
            context.auth.token.role !== RoleEnum.Admin) {
            throw new functions.https.HttpsError('failed-precondition',
                'Only manager or client can call this function');
        }
    }
};

module.exports.checkForAdminRole = checkForAdminRole;
module.exports.checkForManagerRole = checkForManagerRole;
module.exports.checkForClientRole = checkForClientRole;
