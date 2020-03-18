import * as types from './actionTypes';

export function getClientRequest(params) {
    return { type: types.LOAD_CLIENT_REQUEST, params};
}

export function getPaymentsRequest(params) {
    return { type: types.LOAD_PAYMENTS_REQUEST, params};
}
