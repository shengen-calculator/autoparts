const functions = require('firebase-functions');
const getImportModel = require('./dataImport/getImportModel');
const importVendorPrice = require('./dataImport/importVendorPrice');
const getLogInfo = require('./dataImport/getLogInfo');

exports.getImportModel = functions.https.onRequest((req, res) => {
    getImportModel(req, res);
});

exports.importVendorPrice = functions.https.onRequest((req, res) => {
    importVendorPrice(req, res);
});

exports.getLogInfo = functions.https.onRequest((req, res) => {
    getLogInfo(req, res);
});