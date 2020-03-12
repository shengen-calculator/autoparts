import * as types from './actionTypes';

export function authenticationRequest(credentials) {
    return { type: types.AUTHENTICATION_REQUEST,  credentials};
}

export function logoutRequest() {
    return { type: types.LOG_OUT_REQUEST};
}

export function registrationRequest(credentials) {
    return { type: types.REGISTRATION_REQUEST,  credentials};
}