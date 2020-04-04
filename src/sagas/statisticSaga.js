import {call, put} from 'redux-saga/effects';
import * as types from '../redux/actions/actionTypes';
import FunctionsApi from '../api/clientFunctions';

export function* getQueryStatistic(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const {data} = yield call(FunctionsApi.getQueryStatistic, action.params);
        yield put({type: types.LOAD_QUERY_STATISTIC_SUCCESS, result: data});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.LOAD_QUERY_STATISTIC_FAILURE, text: e.message});
    }
}

export function* getClientStatistic(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const {data} = yield call(FunctionsApi.getClientStatistic, action.params);
        yield put({type: types.LOAD_CLIENT_STATISTIC_SUCCESS, result: data});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.LOAD_CLIENT_STATISTIC_FAILURE, text: e.message});
    }
}

export function* getVendorStatistic(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const {data} = yield call(FunctionsApi.getVendorStatistic, action.params);
        yield put({type: types.LOAD_VENDOR_STATISTIC_SUCCESS, result: data});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.LOAD_VENDOR_STATISTIC_FAILURE, text: e.message});
    }
}

export function* getStatisticByVendor(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const {data} = yield call(FunctionsApi.getStatisticByVendor, action.params);
        yield put({type: types.LOAD_STATISTIC_BY_VENDOR_SUCCESS, result: data});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.LOAD_STATISTIC_BY_VENDOR_FAILURE, text: e.message});
    }
}


export function* getStatisticByClient(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const {data} = yield call(FunctionsApi.getStatisticByClient, action.params);
        yield put({type: types.LOAD_STATISTIC_BY_CLIENT_SUCCESS, result: data});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.LOAD_STATISTIC_BY_CLIENT_FAILURE, text: e.message});
    }
}