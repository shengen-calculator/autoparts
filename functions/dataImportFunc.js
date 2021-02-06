const functions = require('firebase-functions');
const vendorPrice = require('./dataImport/vendorPrice');
const getLogs = require('./dataImport/getLogs');

exports.vendorPrice = functions.region('europe-west1').https.onRequest(async (req, res) => {
    return  vendorPrice(req, res);
});

exports.getLogs = functions.region('europe-west1').https.onCall( async (data, context) => {
    return getLogs(data, context);
});