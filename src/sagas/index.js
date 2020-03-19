import {takeLatest} from 'redux-saga/effects';
import * as types from '../redux/actions/actionTypes';
import {logIn,
    getTokenResult,
    logOut,
    register
} from "./authenticationSaga";

import {getClient,
    getPayments
} from "./clientSaga";

function* mySaga() {
    yield takeLatest(types.LOG_OUT_REQUEST, logOut);
    yield takeLatest(types.AUTHENTICATION_GET_TOKEN, getTokenResult);
    yield takeLatest(types.AUTHENTICATION_REQUEST, logIn);
    yield takeLatest(types.REGISTRATION_REQUEST, register);
    yield takeLatest(types.LOAD_CLIENT_REQUEST, getClient);
    yield takeLatest(types.LOAD_PAYMENTS_REQUEST, getPayments);
}

export default mySaga;