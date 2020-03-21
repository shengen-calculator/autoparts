import {call, put} from 'redux-saga/effects';
import * as types from '../redux/actions/actionTypes';
import AuthenticationApi from '../api/authentication';

export function* logIn(action) {
    try {
        yield call(AuthenticationApi.logIn, action.credentials);
        yield put({type: types.AUTHENTICATION_GET_TOKEN});
    } catch (e) {
        yield put({type: types.AUTHENTICATION_FAILURE, text: e.message});
    }
}


export function* getTokenResult() {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const data = yield call(AuthenticationApi.getTokenResult);
        if(data.claims.role) {
            yield put({type: types.AUTHENTICATION_SUCCESS, data: data});
        } else {
            yield put({type: types.API_CALL_ERROR});
            yield put({type: types.AUTHENTICATION_ROLE_FAILURE, data: data});
        }
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.AUTHENTICATION_FAILURE, error: e});
    }
}

export function* logOut() {
    try {
        yield put({type: types.BEGIN_API_CALL});
        yield call(AuthenticationApi.logOut);
        yield put({type: types.LOG_OUT_SUCCESS});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.LOG_OUT_FAILURE, message: e.message});
    }
}


export function* register(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        yield call(AuthenticationApi.register, action.credentials);
        yield put({type: types.REGISTRATION_SUCCESS});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.REGISTRATION_FAILURE, text: e.message});
    }
}