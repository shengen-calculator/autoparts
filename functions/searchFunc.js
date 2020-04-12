const functions = require('firebase-functions');
const getInfoByVendor = require('./search/getInfoByVendor');
const searchByNumber = require('./search/searchByNumber');
const searchByBrandAndNumber = require('./search/searchByBrandAndNumber');
const checkIfPresentInOrderList = require('./search/checkIfPresentInOrderList');
const createOrder = require('./search/createOrder');
const createReserve = require('./search/createReserve');
const getByAnalog = require('./search/getByAnalog');
const updatePrice = require('./search/updatePrice');


exports.getInfoByVendor = functions.https.onCall(async (data, context) => {
    return getInfoByVendor(data, context);
});

exports.searchByNumber = functions.https.onCall(async (data, context) => {
    return searchByNumber(data, context);
});

exports.searchByBrandAndNumber = functions.https.onCall(async (data, context) => {
    return searchByBrandAndNumber(data, context);
});


exports.checkIfPresentInOrderList = functions.https.onCall(async (data, context) => {
    return checkIfPresentInOrderList(data, context);
});

exports.createOrder = functions.https.onCall(async (data, context) => {
    return createOrder(data, context);
});


exports.createReserve = functions.https.onCall(async (data, context) => {
    return createReserve(data, context);
});


exports.getByAnalog = functions.https.onCall(async (data, context) => {
    return getByAnalog(data, context);
});


exports.updatePrice = functions.https.onCall(async (data, context) => {
    return updatePrice(data, context);
});
