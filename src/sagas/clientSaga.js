import {call, put} from 'redux-saga/effects';
import * as types from '../redux/actions/actionTypes';
import FunctionsApi from '../api/clientFunctions';

export function* getClient(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const {data} = yield call(FunctionsApi.getClientByVip, action.vip);
        if(data) {
            yield put({type: types.LOAD_CLIENT_SUCCESS, client: data});
        } else {
            yield put({type: types.API_CALL_ERROR});
            yield put({type: types.CLIENT_DOESNT_EXIST});
        }

    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.LOAD_CLIENT_FAILURE, text: e.message});
    }
}

export function* getOrders(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const {data} = yield call(FunctionsApi.getOrdersByVip, action.vip);
        yield put({type: types.LOAD_ORDERS_SUCCESS, orders: data});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.LOAD_ORDERS_FAILURE, text: e.message});
    }
}


export function* deleteOrders(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        yield call(FunctionsApi.deleteOrdersByIds, action.ids);
        yield put({type: types.DELETE_ORDERS_SUCCESS, orders: data});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.DELETE_ORDERS_FAILURE, text: e.message});
    }
}


export function* updateOrderPrices(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const {data} = yield call(FunctionsApi.updateOrderPrices, action.vip);
        yield put({type: types.UPDATE_ORDERS_PRICE_SUCCESS, orders: data});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.UPDATE_ORDERS_PRICE_FAILURE, text: e.message});
    }
}

export function* updateOrderQuantity(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const {data} = yield call(FunctionsApi.updateOrderQuantity, action.params);
        yield put({type: types.UPDATE_ORDER_QUANTITY_SUCCESS});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.UPDATE_ORDER_QUANTITY_FAILURE, text: e.message});
    }
}

export function* getPayments(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const {data} = yield call(FunctionsApi.getPaymentsByVip, action.vip);
        yield put({type: types.LOAD_PAYMENTS_SUCCESS, payments: data});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.LOAD_PAYMENTS_FAILURE, text: e.message});
    }
}