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

const getReconciliationXlsLink = (data) => {
    if(data)
        return "https://firebasestorage.googleapis.com/v0/b/autoparts-95d56.appspot.com/o/alessio-lin--6LYjG0H32E-big.jpg?alt=media&token=8510d92b-ddcd-4eca-9022-c3226b844399";
    return null
};

module.exports.checkForManagerRole = checkForManagerRole;
module.exports.checkForClientRole = checkForClientRole;
module.exports.getReconciliationXlsLink = getReconciliationXlsLink;