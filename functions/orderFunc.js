const functions = require('firebase-functions');
const getOrdersByVip = require('./order/getOrdersByVip');
const getReservesByVip = require('./order/getReservesByVip');
const deleteOrdersByIds = require('./order/deleteOrdersByIds');
const deleteReservesByIds = require('./order/deleteReservesByIds');
const updateOrderQuantity = require('./order/updateOrderQuantity');
const updateReserveQuantity = require('./order/updateReserveQuantity');

exports.deleteOrdersByIds = functions.region('europe-west1').https.onCall(async (data, context) => {
    return deleteOrdersByIds(data, context);
});

exports.deleteReservesByIds = functions.region('europe-west1').https.onCall(async (data, context) => {
    return deleteReservesByIds(data, context);
});

exports.updateOrderQuantity = functions.region('europe-west1').https.onCall(async (data, context) => {
    return updateOrderQuantity(data, context);
});

exports.updateReserveQuantity = functions.region('europe-west1').https.onCall(async (data, context) => {
    return updateReserveQuantity(data, context);
});

exports.getOrdersByVip = functions.region('europe-west1').https.onCall(async (data, context) => {
    return getOrdersByVip(data, context);
});

exports.getReservesByVip = functions.region('europe-west1').https.onCall(async (data, context) => {
    return getReservesByVip(data, context);
});