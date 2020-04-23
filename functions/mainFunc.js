const functions = require('firebase-functions');
const processSignUp = require('./main/processSignUp');
const getClientByVip = require('./main/getClientByVip');
const getPaymentsByVip = require('./main/getPaymentsByVip');

exports.processSignUp = functions.auth.user().onCreate((user) => {
    return processSignUp(user);
});

exports.getClientByVip = functions.region('europe-west1').https.onCall(async (data, context) => {
    return getClientByVip(data, context);
});

exports.getPaymentsByVip = functions.region('europe-west1').https.onCall(async (data, context) => {
    return getPaymentsByVip(data, context);
});