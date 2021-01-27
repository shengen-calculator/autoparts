const functions = require('firebase-functions');

const getAttachment = require('./dataImport/getAttachment');

exports.getAttachment = functions.region('europe-west1').https.onCall(async (data, context) => {
    return getAttachment(data, context);
});
