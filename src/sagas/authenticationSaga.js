import {call, put} from 'redux-saga/effects';
import * as types from '../redux/actions/actionTypes';
import AuthenticationApi from '../api/authentication';

export function* logIn(action) {
    try {
        const data = yield call(AuthenticationApi.logIn, action.credentials);
        yield put({type: types.AUTHENTICATION_SUCCESS, data: data});
    } catch (e) {
        yield put({type: types.AUTHENTICATION_FAILURE, error: e});
    }
}

export function* logOut() {
    try {
        yield call(AuthenticationApi.logOut);
        yield put({type: types.LOG_OUT_SUCCESS});
    } catch (e) {
        yield put({type: types.LOG_OUT_FAILURE, message: e.message});
    }
}


export function* register(action) {
    try {
        yield call(AuthenticationApi.register, action.credentials);
        yield put({type: types.REGISTRATION_SUCCESS});
    } catch (e) {
        yield put({type: types.REGISTRATION_FAILURE, text: e.message});
    }
}