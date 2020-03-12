import {takeLatest} from 'redux-saga/effects';
import * as types from '../redux/actions/actionTypes';
import {logIn, logOut, register} from "./authenticationSaga";

function* mySaga() {
    yield takeLatest(types.LOG_OUT_REQUEST, logOut);
    yield takeLatest(types.AUTHENTICATION_REQUEST, logIn);
    yield takeLatest(types.REGISTRATION_REQUEST, register);
}

export default mySaga;