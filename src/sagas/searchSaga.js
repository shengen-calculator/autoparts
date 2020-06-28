import {call, put} from "redux-saga/effects";
import * as types from "../redux/actions/actionTypes";
import SearchFunctionsApi from "../api/searchFunctions";

export function* searchByNumber(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const {data} = yield call(SearchFunctionsApi.searchByNumber, action.number);
        yield put({type: types.LOAD_BY_NUMBER_SUCCESS, products: data});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.LOAD_BY_NUMBER_FAILURE, text: e.message});
    }
}

export function* searchByBrandAndNumber(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const {data} = yield call(SearchFunctionsApi.searchByBrandAndNumber, action.params);
        yield put({type: types.LOAD_BY_BRAND_SUCCESS, products: data});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.LOAD_BY_BRAND_FAILURE, text: e.message});
    }
}

export function* updatePrice(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const {data} = yield call(SearchFunctionsApi.updatePrice, action.params);
        yield put({type: types.UPDATE_PRICE_SUCCESS, products: data});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.UPDATE_PRICE_FAILURE, text: e.message});
    }
}

export function* createOrder(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const {data} = yield call(SearchFunctionsApi.createOrder, action.params);
        yield put({type: types.CREATE_ORDER_SUCCESS, order: data[0]});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.CREATE_ORDER_FAILURE, text: e.message});
    }
}

export function* createReserve(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const {data} = yield call(SearchFunctionsApi.createReserve, action.params);
        yield put({type: types.CREATE_RESERVE_SUCCESS, reserve: data[0]});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.CREATE_RESERVE_FAILURE, text: e.message});
    }
}

export function* getByAnalog(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const {data} = yield call(SearchFunctionsApi.getByAnalog, action.analogId);
        yield put({type: types.LOAD_BY_ANALOG_SUCCESS, products: data});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.LOAD_BY_ANALOG_FAILURE, text: e.message});
    }
}
