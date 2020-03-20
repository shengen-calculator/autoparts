import {call, put} from 'redux-saga/effects';
import * as types from '../redux/actions/actionTypes';
import FunctionsApi from '../api/clientFunctions';

export function* getClient(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const data = yield call(FunctionsApi.getClientByVip, action.vip);
        if(data.data) {
            yield put({type: types.LOAD_CLIENT_SUCCESS, client: data.data});
        } else {
            yield put({type: types.API_CALL_ERROR});
            yield put({type: types.CLIENT_DOESNT_EXIST});
        }

    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.LOAD_CLIENT_FAILURE, text: e.message});
    }
}

export function* getPayments(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const data = yield call(FunctionsApi.getPaymentsByVip, action.vip);
        yield put({type: types.LOAD_PAYMENTS_SUCCESS, payments: data.data});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.LOAD_PAYMENTS_FAILURE, text: e.message});
    }
}