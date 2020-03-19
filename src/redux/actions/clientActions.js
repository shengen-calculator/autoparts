import * as types from './actionTypes';

export function getClientRequest(vip) {
    return { type: types.LOAD_CLIENT_REQUEST, vip};
}

export function getPaymentsRequest(vip) {
    return { type: types.LOAD_PAYMENTS_REQUEST, vip};
}
