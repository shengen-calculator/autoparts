import * as types from './actionTypes';

export function getAnalogs(params) {
    return {type: types.LOAD_ANALOGS_REQUEST, params};
}

export function getPhotos(params) {
    return {type: types.LOAD_PHOTOS_REQUEST, params};
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

export function updatePrice(params) {
    return {type: types.UPDATE_PRICE_REQUEST, params};
}