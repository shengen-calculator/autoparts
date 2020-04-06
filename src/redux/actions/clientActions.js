import * as types from './actionTypes';

export function getClient(vip) {
    return { type: types.LOAD_CLIENT_REQUEST, vip};
}

export function getPayments(vip) {
    return { type: types.LOAD_PAYMENTS_REQUEST, vip};
}

export function getOrders(vip) {
    return { type: types.LOAD_ORDERS_REQUEST, vip};
}

export function getReserves(vip) {
    return { type: types.LOAD_RESERVES_REQUEST, vip};
}

export function deleteOrdersByIds(ids) {
    return { type: types.DELETE_ORDERS_REQUEST, ids};
}

export function deleteReservesByIds(ids) {
    return { type: types.DELETE_RESERVES_REQUEST, ids};
}

export function updateReservePrice(params) {
    return { type: types.UPDATE_RESERVE_PRICE_REQUEST, params};
}
export function updateReserveQuantity(params) {
    return { type: types.UPDATE_RESERVE_QUANTITY_REQUEST, params};
}

export function updateOrderQuantityRequest(params) {
    return { type: types.UPDATE_ORDER_QUANTITY_REQUEST, params};
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