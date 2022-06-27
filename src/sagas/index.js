import {takeLatest} from 'redux-saga/effects';
import * as types from '../redux/actions/actionTypes';
import {logIn,
    getTokenResult,
    logOut,
    register
} from "./authenticationSaga";

import {
    getClient,
    getOrders,
    getReserves,
    deleteOrders,
    deleteReserves,
    updateOrderQuantity,
    updateReserveQuantity,
    getPayments, 
    getReconciliationData,
    getCurrencyRate
} from "./clientSaga";
import {
    getClientStatistic,
    getVendorStatistic,
    getStatisticByVendor
} from "./statisticSaga";
import {
    createOrder,
    createReserve,
    getAnalogs,
    getDeliveryDate,
    getPhotos,
    searchByBrandAndNumber,
    searchByNumber,
    updatePrice
} from "./searchSaga";
import {updateAppState,
    subscribeToAppState,
    unSubscribe
} from "./applicationSaga";
import {
    getPaymentHistory,
    getReturnHistory,
    getSaleHistory
} from "./historySaga";

function* mySaga() {
    yield takeLatest(types.LOG_OUT_REQUEST, logOut);
    yield takeLatest(types.AUTHENTICATION_GET_TOKEN, getTokenResult);
    yield takeLatest(types.AUTHENTICATION_REQUEST, logIn);
    yield takeLatest(types.REGISTRATION_REQUEST, register);
    yield takeLatest(types.LOAD_CLIENT_REQUEST, getClient);
    yield takeLatest(types.LOAD_PAYMENTS_REQUEST, getPayments);
    yield takeLatest(types.LOAD_ORDERS_REQUEST, getOrders);
    yield takeLatest(types.LOAD_RESERVES_REQUEST, getReserves);
    yield takeLatest(types.LOAD_RECONCILIATION_REQUEST, getReconciliationData);
    yield takeLatest(types.LOAD_PAYMENT_HISTORY_REQUEST, getPaymentHistory);
    yield takeLatest(types.LOAD_RETURN_HISTORY_REQUEST, getReturnHistory);
    yield takeLatest(types.LOAD_SALE_HISTORY_REQUEST, getSaleHistory);
    yield takeLatest(types.DELETE_RESERVES_REQUEST, deleteReserves);
    yield takeLatest(types.DELETE_ORDERS_REQUEST, deleteOrders);
    yield takeLatest(types.UPDATE_ORDER_QUANTITY_REQUEST, updateOrderQuantity);
    yield takeLatest(types.UPDATE_RESERVE_QUANTITY_REQUEST, updateReserveQuantity);
    yield takeLatest(types.LOAD_CLIENT_STATISTIC_REQUEST, getClientStatistic);
    yield takeLatest(types.LOAD_VENDOR_STATISTIC_REQUEST, getVendorStatistic);
    yield takeLatest(types.LOAD_STATISTIC_BY_VENDOR_REQUEST, getStatisticByVendor);
    yield takeLatest(types.LOAD_BY_NUMBER_REQUEST, searchByNumber);
    yield takeLatest(types.LOAD_BY_BRAND_REQUEST, searchByBrandAndNumber);
    yield takeLatest(types.UPDATE_PRICE_REQUEST, updatePrice);
    yield takeLatest(types.CREATE_ORDER_REQUEST, createOrder);
    yield takeLatest(types.CREATE_RESERVE_REQUEST, createReserve);
    yield takeLatest(types.LOAD_CURRENCY_RATE_REQUEST, getCurrencyRate);
    yield takeLatest(types.LOAD_ANALOGS_REQUEST, getAnalogs);
    yield takeLatest(types.LOAD_PHOTOS_REQUEST, getPhotos);
    yield takeLatest(types.LOAD_DELIVERY_DATE_REQUEST, getDeliveryDate);
    yield takeLatest(types.UPDATE_APP_STATE_REQUEST, updateAppState);
    yield takeLatest(types.SUBSCRIBE_TO_APP_STATE_UPDATE_REQUEST, subscribeToAppState);
    yield takeLatest(types.UNSUBSCRIBE_TO_APP_STATE_UPDATE_REQUEST, unSubscribe);

}

export default mySaga;