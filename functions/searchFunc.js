const functions = require('firebase-functions');
const searchByNumber = require('./search/searchByNumber');
const searchByBrandAndNumber = require('./search/searchByBrandAndNumber');
const createOrder = require('./search/createOrder');
const createReserve = require('./search/createReserve');
const getAnalogs = require('./search/getAnalogs');
const updatePrice = require('./search/updatePrice');
const getPhotos = require('./search/getPhotos');
const getDeliveryDate = require('./search/getDeliveryDate');

exports.searchByNumber = functions.region('europe-west1').https.onCall(async (data, context) => {
    return searchByNumber(data, context);
});

exports.searchByBrandAndNumber = functions.region('europe-west1').https.onCall(async (data, context) => {
    return searchByBrandAndNumber(data, context);
});

exports.createOrder = functions.region('europe-west1').https.onCall(async (data, context) => {
    return createOrder(data, context);
});

exports.createReserve = functions.region('europe-west1').https.onCall(async (data, context) => {
    return createReserve(data, context);
});

exports.getAnalogs = functions.region('europe-west1').https.onCall(async (data, context) => {
    return getAnalogs(data, context);
});

exports.getPhotos = functions.region('europe-west1').https.onCall(async (data, context) => {
    return getPhotos(data, context);
});

exports.getDeilveryDate = functions.region('europe-west1').https.onCall(async (data, context) => {
    return getDeliveryDate(data, context);
});

exports.updatePrice = functions.region('europe-west1').https.onCall(async (data, context) => {
    return updatePrice(data, context);
});
