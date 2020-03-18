const functions = require('firebase-functions');
const admin = require('firebase-admin');
const processSignUp = require('./processSignUp');
const getClientByVip = require('./getClientByVip');
const getPaymentsByVip = require('./getPaymentsByVip');

admin.initializeApp();

exports.processSignUp = functions.auth.user().onCreate((user) => {
    return processSignUp(user);
});

exports.getClientByVip = functions.https.onCall(async (data, context) => {
    return getClientByVip(data, context);
});

exports.getPaymentsByVip = functions.https.onCall(async (data, context) => {
    return getPaymentsByVip(data, context);
});