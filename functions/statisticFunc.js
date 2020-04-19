const functions = require('firebase-functions');
const getQueryStatistic = require('./statistic/getQueryStatistic');
const getVendorStatistic = require('./statistic/getVendorStatistic');
const getStatisticByVendor = require('./statistic/getStatisticByVendor');
const getClientStatistic = require('./statistic/getClientStatistic');
const getStatisticByClient = require('./statistic/getStatisticByClient');

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

exports.getQueryStatistic = functions.https.onCall(async (data, context) => {
    return getQueryStatistic(data, context);
});
