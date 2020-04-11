import * as types from './actionTypes';

export function getByAnalog(analogId) {
    return {type: types.LOAD_BY_ANALOG_REQUEST, analogId};
}

export function getByNumber(number) {
    return {type: types.LOAD_BY_NUMBER_REQUEST, number};
}

export function getByBrand(params) {
    return {type: types.LOAD_BY_BRAND_REQUEST, params};
}

export function createOrder(params) {
    return {type: types.CREATE_ORDER_REQUEST, params};
}

export function createReserve(params) {
    return {type: types.CREATE_RESERVE_REQUEST, params};
}

export function checkIfPresentInOrder(analogId) {
    return {type: types.CHECK_ORDER_REQUEST, analogId};
}

export function getVendorInfo(vendorId) {
    return {type: types.LOAD_VENDOR_INFO_REQUEST, vendorId};
}

export function updatePrice(params) {
    return {type: types.UPDATE_PRICE_REQUEST, params};
}