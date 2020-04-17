const functions = require('firebase-functions');
const getOrdersByVip = require('./order/getOrdersByVip');
const getReservesByVip = require('./order/getReservesByVip');
const deleteOrdersByIds = require('./order/deleteOrdersByIds');
const deleteReservesByIds = require('./order/deleteReservesByIds');
const updateOrderQuantity = require('./order/updateOrderQuantity');
const updateReserveQuantity = require('./order/updateReserveQuantity');

exports.deleteOrdersByIds = functions.https.onCall(async (data, context) => {
    return deleteOrdersByIds(data, context);
});

exports.deleteReservesByIds = functions.https.onCall(async (data, context) => {
    return deleteReservesByIds(data, context);
});

exports.updateOrderQuantity = functions.https.onCall(async (data, context) => {
    return updateOrderQuantity(data, context);
});

exports.updateReserveQuantity = functions.https.onCall(async (data, context) => {
    return updateReserveQuantity(data, context);
});

exports.getOrdersByVip = functions.https.onCall(async (data, context) => {
    return getOrdersByVip(data, context);
});

exports.getReservesByVip = functions.https.onCall(async (data, context) => {
    return getReservesByVip(data, context);
});