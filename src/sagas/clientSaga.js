import {call, put} from 'redux-saga/effects';
import * as types from '../redux/actions/actionTypes';
import FunctionsApi from '../api/clientFunctions';

export function* getClient(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const {data} = yield call(FunctionsApi.getClientByVip, action.vip);
        if(data.length > 0) {
            yield put({type: types.LOAD_CLIENT_SUCCESS, client: data[0]});
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

export function* getReserves(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const {data} = yield call(FunctionsApi.getReservesByVip, action.vip);
        yield put({type: types.LOAD_RESERVES_SUCCESS, reserves: data});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.LOAD_RESERVES_FAILURE, text: e.message});
    }
}

export function* deleteOrders(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const {data} = yield call(FunctionsApi.deleteOrdersByIds, action.ids);
        yield put({type: types.DELETE_ORDERS_SUCCESS, orders: data});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.DELETE_ORDERS_FAILURE, text: e.message});
    }
}

export function* deleteReserves(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const {data} = yield call(FunctionsApi.deleteReservesByIds, action.ids);
        yield put({type: types.DELETE_RESERVES_SUCCESS, reserves: data});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.DELETE_RESERVES_FAILURE, text: e.message});
    }
}

export function* updateOrderQuantity(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const {data} = yield call(FunctionsApi.updateOrderQuantity, action.params);
        yield put({type: types.UPDATE_ORDER_QUANTITY_SUCCESS, orders: data});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.UPDATE_ORDER_QUANTITY_FAILURE, text: e.message});
    }
}

export function* updateReserveQuantity(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const {data} = yield call(FunctionsApi.updateReserveQuantity, action.params);
        yield put({type: types.UPDATE_RESERVE_QUANTITY_SUCCESS, reserves: data});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.UPDATE_RESERVE_QUANTITY_FAILURE, text: e.message});
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