const functions = require('firebase-functions');
const vendorPrice = require('./dataImport/vendorPrice');
const getLogInfo = require('./dataImport/getLogInfo');

exports.vendorPrice = functions.https.onRequest(async (req, res) => {
    await vendorPrice(req, res);
});

exports.getLogInfo = functions.https.onRequest( async (data, context) => {
    await getLogInfo(data, context);
});