import * as types from './actionTypes';

export function getClientRequest(vip) {
    return { type: types.LOAD_CLIENT_REQUEST, vip};
}

export function getPaymentsRequest(vip) {
    return { type: types.LOAD_PAYMENTS_REQUEST, vip};
}

export function getClientStatistic(params) {
    return { type: types.LOAD_CLIENT_STATISTIC_REQUEST, params};
}

export function getQueryStatistic(params) {
    return { type: types.LOAD_QUERY_STATISTIC_REQUEST, params};
}

export function getVendorStatistic(params) {
    return { type: types.LOAD_VENDOR_STATISTIC_REQUEST, params};
}

export function getStatisticByClient(params) {
    return { type: types.LOAD_STATISTIC_BY_CLIENT_REQUEST, params};
}

export function getStatisticByVendor(params) {
    return { type: types.LOAD_STATISTIC_BY_VENDOR_REQUEST, params};
}