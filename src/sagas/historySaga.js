import {call, put} from 'redux-saga/effects';
import * as types from '../redux/actions/actionTypes';
import FunctionsApi from '../api/clientFunctions';

export function* getPaymentHistory(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const {data} = yield call(FunctionsApi.getPaymentHistory, action.params);
        yield put({type: types.LOAD_PAYMENT_HISTORY_SUCCESS, payments: data});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.LOAD_PAYMENT_HISTORY_FAILURE, text: e.message});
    }
}

export function* getSaleHistory(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const {data} = yield call(FunctionsApi.getSaleHistory, action.params);
        yield put({type: types.LOAD_SALE_HISTORY_SUCCESS, sales: data});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.LOAD_SALE_HISTORY_FAILURE, text: e.message});
    }
}

export function* getReturnHistory(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const {data} = yield call(FunctionsApi.getReturnHistory, action.params);
        yield put({type: types.LOAD_RETURN_HISTORY_SUCCESS, returns: data});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.LOAD_RETURN_HISTORY_FAILURE, text: e.message});
    }
}