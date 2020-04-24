const functions = require('firebase-functions');
const searchByNumber = require('./search/searchByNumber');
const searchByBrandAndNumber = require('./search/searchByBrandAndNumber');
const checkIfPresentInOrderList = require('./search/checkIfPresentInOrderList');
const createOrder = require('./search/createOrder');
const createReserve = require('./search/createReserve');
const getByAnalog = require('./search/getByAnalog');
const updatePrice = require('./search/updatePrice');

exports.searchByNumber = functions.region('europe-west1').https.onCall(async (data, context) => {
    return searchByNumber(data, context);
});

exports.searchByBrandAndNumber = functions.region('europe-west1').https.onCall(async (data, context) => {
    return searchByBrandAndNumber(data, context);
});


exports.checkIfPresentInOrderList = functions.region('europe-west1').https.onCall(async (data, context) => {
    return checkIfPresentInOrderList(data, context);
});

exports.createOrder = functions.region('europe-west1').https.onCall(async (data, context) => {
    return createOrder(data, context);
});


exports.createReserve = functions.region('europe-west1').https.onCall(async (data, context) => {
    return createReserve(data, context);
});


exports.getByAnalog = functions.region('europe-west1').https.onCall(async (data, context) => {
    return getByAnalog(data, context);
});


exports.updatePrice = functions.region('europe-west1').https.onCall(async (data, context) => {
    return updatePrice(data, context);
});
