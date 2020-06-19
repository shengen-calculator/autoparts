const functions = require('firebase-functions');
const getVendorStatistic = require('./statistic/getVendorStatistic');
const getStatisticByVendor = require('./statistic/getStatisticByVendor');
const getClientStatistic = require('./statistic/getClientStatistic');
const getStatisticByClient = require('./statistic/getStatisticByClient');

exports.getVendorStatistic = functions.region('europe-west1').https.onCall(async (data, context) => {
    return getVendorStatistic(data, context);
});

exports.getStatisticByVendor = functions.region('europe-west1').https.onCall(async (data, context) => {
    return getStatisticByVendor(data, context);
});

exports.getClientStatistic = functions.region('europe-west1').https.onCall(async (data, context) => {
    return getClientStatistic(data, context);
});

exports.getStatisticByClient = functions.region('europe-west1').https.onCall(async (data, context) => {
    return getStatisticByClient(data, context);
});
