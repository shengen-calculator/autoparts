import * as types from "./actionTypes";

export function getPaymentHistory(params) {
    return {type: types.LOAD_PAYMENT_HISTORY_REQUEST, params};
}

export function getSaleHistory(params) {
    return {type: types.LOAD_SALE_HISTORY_REQUEST, params};
}

export function getReturnHistory(params) {
    return {type: types.LOAD_RETURN_HISTORY_REQUEST, params};
}