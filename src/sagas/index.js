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
    getPayments
} from "./clientSaga";
import {getQueryStatistic,
    getClientStatistic,
    getVendorStatistic,
    getStatisticByVendor,
    getStatisticByClient
} from "./statisticSaga";

function* mySaga() {
    yield takeLatest(types.LOG_OUT_REQUEST, logOut);
    yield takeLatest(types.AUTHENTICATION_GET_TOKEN, getTokenResult);
    yield takeLatest(types.AUTHENTICATION_REQUEST, logIn);
    yield takeLatest(types.REGISTRATION_REQUEST, register);
    yield takeLatest(types.LOAD_CLIENT_REQUEST, getClient);
    yield takeLatest(types.LOAD_PAYMENTS_REQUEST, getPayments);
    yield takeLatest(types.LOAD_ORDERS_REQUEST, getOrders);
    yield takeLatest(types.LOAD_QUERY_STATISTIC_REQUEST, getQueryStatistic);
    yield takeLatest(types.LOAD_CLIENT_STATISTIC_REQUEST, getClientStatistic);
    yield takeLatest(types.LOAD_VENDOR_STATISTIC_REQUEST, getVendorStatistic);
    yield takeLatest(types.LOAD_STATISTIC_BY_VENDOR_REQUEST, getStatisticByVendor);
    yield takeLatest(types.LOAD_STATISTIC_BY_CLIENT_REQUEST, getStatisticByClient);
}

export default mySaga;