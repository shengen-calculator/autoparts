const functions = require('firebase-functions');
const processSignUp = require('./main/processSignUp');
const getClientByVip = require('./main/getClientByVip');
const unblockClient = require('./main/unblockClient');
const getUnblockRecords = require('./main/getUnblockRecords');
const getPaymentsByVip = require('./main/getPaymentsByVip');
const getReconciliationData = require('./main/getReconciliationData');
const getCurrencyRate = require('./main/getCurrencyRate');

exports.processSignUp = functions.region('europe-west1').auth.user().onCreate((user) => {
    return processSignUp(user);
});

exports.getClientByVip = functions.region('europe-west1').https.onCall(async (data, context) => {
    return getClientByVip(data, context);
});

exports.getPaymentsByVip = functions.region('europe-west1').https.onCall(async (data, context) => {
    return getPaymentsByVip(data, context);
});

exports.getReconciliationData = functions.region('europe-west1').https.onCall(async (data, context) => {
    return getReconciliationData(data, context);

});

exports.getCurrencyRate = functions.region('europe-west1').https.onCall(async (data, context) => {
    return getCurrencyRate(data, context);
});

exports.unblockClient = functions.region('europe-west1').https.onCall(async (data, context) => {
    return unblockClient(data, context);
});

exports.getUnblockRecords = functions.region('europe-west1').https.onCall(async (data, context) => {
    return getUnblockRecords(data, context);
});
