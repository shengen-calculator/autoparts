const functions = require('firebase-functions');
const admin = require('firebase-admin');
const processSignUp = require('./processSignUp');
const getClientByVip = require('./getClientByVip');
const getPaymentsByVip = require('./getPaymentsByVip');
const getQueryStatistic = require('./statistic/getQueryStatistic');
const getVendorStatistic = require('./statistic/getVendorStatistic');
const getStatisticByVendor = require('./statistic/getStatisticByVendor');
const getClientStatistic = require('./statistic/getClientStatistic');
const getStatisticByClient = require('./statistic/getStatisticByClient');
const getOrdersByVip = require('./order/getOrdersByVip');
const getReservesByVip = require('./order/getReservesByVip');
const deleteOrdersByIds = require('./order/deleteOrdersByIds');
const deleteReservesByIds = require('./order/deleteReservesByIds');
const updateReservePrices = require('./order/updateReservePrices');
const updateOrderQuantity = require('./order/updateOrderQuantity');
const updateReserveQuantity = require('./order/updateReserveQuantity');
const getInfoByVendor = require('./search/getInfoByVendor');
const searchByNumber = require('./search/searchByNumber');
const searchByBrandAndNumber = require('./search/searchByBrandAndNumber');

admin.initializeApp();

exports.processSignUp = functions.auth.user().onCreate((user) => {
    return processSignUp(user);
});

exports.getClientByVip = functions.https.onCall(async (data, context) => {
    return getClientByVip(data, context);
});

exports.getPaymentsByVip = functions.https.onCall(async (data, context) => {
    return getPaymentsByVip(data, context);
});

exports.getQueryStatistic = functions.https.onCall(async (data, context) => {
    return getQueryStatistic(data, context);
});

exports.getVendorStatistic = functions.https.onCall(async (data, context) => {
    return getVendorStatistic(data, context);
});

exports.getStatisticByVendor = functions.https.onCall(async (data, context) => {
    return getStatisticByVendor(data, context);
});

exports.getClientStatistic = functions.https.onCall(async (data, context) => {
    return getClientStatistic(data, context);
});

exports.getStatisticByClient = functions.https.onCall(async (data, context) => {
    return getStatisticByClient(data, context);
});

exports.getOrdersByVip = functions.https.onCall(async (data, context) => {
    return getOrdersByVip(data, context);
});

exports.getReservesByVip = functions.https.onCall(async (data, context) => {
    return getReservesByVip(data, context);
});

exports.deleteOrdersByIds = functions.https.onCall(async (data, context) => {
    return deleteOrdersByIds(data, context);
});

exports.deleteReservesByIds = functions.https.onCall(async (data, context) => {
    return deleteReservesByIds(data, context);
});

exports.updateReservePrices = functions.https.onCall(async (data, context) => {
    return updateReservePrices(data, context);
});

exports.updateOrderQuantity = functions.https.onCall(async (data, context) => {
    return updateOrderQuantity(data, context);
});

exports.updateReserveQuantity = functions.https.onCall(async (data, context) => {
    return updateReserveQuantity(data, context);
});

exports.getInfoByVendor = functions.https.onCall(async (data, context) => {
    return getInfoByVendor(data, context);
});

exports.searchByNumber = functions.https.onCall(async (data, context) => {
    return searchByNumber(data, context);
});

exports.searchByBrandAndNumber = functions.https.onCall(async (data, context) => {
    return searchByBrandAndNumber(data, context);
});