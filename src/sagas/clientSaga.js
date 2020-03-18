import {call, put} from 'redux-saga/effects';
import * as types from '../redux/actions/actionTypes';
import FunctionsApi from '../api/clientFunctions';
import {beginApiCall} from "../redux/actions/apiStatusActions";

export function* getClient(action) {
    try {
        yield call(beginApiCall);
        const data = yield call(FunctionsApi.getClientByVip, action.vip);
        yield put({type: types.LOAD_CLIENT_SUCCESS, data: data});
    } catch (e) {
        yield put({type: types.LOAD_CLIENT_FAILURE, text: e.message});
    }
}

export function* getPayments(action) {
    try {
        yield call(beginApiCall);
        const data = yield call(FunctionsApi.getPaymentsByVip, action.vip);
        yield put({type: types.LOAD_PAYMENTS_SUCCESS, data: data});
    } catch (e) {
        yield put({type: types.LOAD_PAYMENTS_FAILURE, text: e.message});
    }
}