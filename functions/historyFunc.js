const functions = require('firebase-functions');
const getSales = require('./history/getSales');
const getReturns = require('./history/getReturns');
const getPayments = require('./history/getPayments');


exports.getSales = functions.region('europe-west1').https.onCall(async (data, context) => {
    return getSales(data, context);
});

exports.getReturns = functions.region('europe-west1').https.onCall(async (data, context) => {
    return getReturns(data, context);

});

exports.getPayments = functions.region('europe-west1').https.onCall(async (data, context) => {
    return getPayments(data, context);
});