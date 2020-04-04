const functions = require('firebase-functions');
const admin = require('firebase-admin');
const processSignUp = require('./processSignUp');
const getClientByVip = require('./getClientByVip');
const getPaymentsByVip = require('./getPaymentsByVip');
const getQueryStatistic = require('./statistic/getQueryStatistic');
const getVendorStatistic = require('./statistic/getVendorStatistic');
const getStatisticByVendor = require('./statistic/getStatisticByVendor');
const getClientStatistic = require('./statistic/getClientStatistic');
const getStatisticByClient = require('./statistic/getStatisticByClient');
const getOrdersByVip = require('./getOrdersByVip');

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

exports.getQueryStatistic = functions.https.onCall(async (data, context) => {
    return getQueryStatistic(data, context);
});

exports.getVendorStatistic = functions.https.onCall(async (data, context) => {
    return getVendorStatistic(data, context);
});

exports.getStatisticByVendor = functions.https.onCall(async (data, context) => {
    return getStatisticByVendor(data, context);
});

exports.getClientStatistic = functions.https.onCall(async (data, context) => {
    return getClientStatistic(data, context);
});

exports.getStatisticByClient = functions.https.onCall(async (data, context) => {
    return getStatisticByClient(data, context);
});


exports.getOrdersByVip = functions.https.onCall(async (data, context) => {
    return getOrdersByVip(data, context);
});