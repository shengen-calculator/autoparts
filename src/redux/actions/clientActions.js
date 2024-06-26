import * as types from './actionTypes';

export function getClient(vip) {
    return { type: types.LOAD_CLIENT_REQUEST, vip};
}

export function unblockClient(vip) {
    return { type: types.UNBLOCK_CLIENT_REQUEST, vip};
}

export function getUnblockRecords(vip) {
    return { type: types.LOAD_UNBLOCK_RECORDS_REQUEST, vip};
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

export function getReconciliationData(params) {
    return { type: types.LOAD_RECONCILIATION_REQUEST, params};
}

export function deleteOrdersByIds(ids) {
    return { type: types.DELETE_ORDERS_REQUEST, ids};
}

export function deleteReservesByIds(params) {
    return { type: types.DELETE_RESERVES_REQUEST, params};
}

export function updateReserveQuantity(params) {
    return { type: types.UPDATE_RESERVE_QUANTITY_REQUEST, params};
}

export function updateOrderQuantity(params) {
    return { type: types.UPDATE_ORDER_QUANTITY_REQUEST, params};
}

export function getClientStatistic(params) {
    return { type: types.LOAD_CLIENT_STATISTIC_REQUEST, params};
}

export function getVendorStatistic() {
    return { type: types.LOAD_VENDOR_STATISTIC_REQUEST };
}

export function showClientPrice() {
    return { type: types.SHOW_CLIENT_PRICE };
}

export function hideClientPrice() {
    return { type: types.HIDE_CLIENT_PRICE };
}

export function getStatisticByVendor(vendorId) {
    return { type: types.LOAD_STATISTIC_BY_VENDOR_REQUEST, vendorId};
}

export function getCurrencyRate() {
    return { type: types.LOAD_CURRENCY_RATE_REQUEST };
}
