import * as types from '../actions/actionTypes';
import initialState from './initialState';

export default function clientReducer(state = initialState.client, action) {
    switch (action.type) {
        case types.LOAD_CLIENT_REQUEST:
            return {
                ...state,
                isClientNotExists: false
            };

        case types.LOAD_CLIENT_SUCCESS:
            return {
                ...state,
                vip: action.client.vip,
                fullName: action.client.fullName,
                orders: [],
                isOrdersLoaded: false,
                reserves: [],
                isReservesLoaded: false,
                payments: [],
                isPaymentsLoaded: false,
            };

        case types.LOAD_PAYMENTS_SUCCESS:
            return {
                ...state,
                payments: action.payments,
                isPaymentsLoaded: true
            };

        case types.LOAD_ORDERS_SUCCESS:
            return {
                ...state,
                orders: action.orders,
                isOrdersLoaded: true
            };

        case types.LOAD_RESERVES_SUCCESS:
            return {
                ...state,
                reserves: action.reserves,
                isReservesLoaded: true
            };

        case types.DELETE_ORDERS_SUCCESS:
            return {
                ...state,
                orders: action.orders,
                isOrdersLoaded: true
            };

        case types.DELETE_RESERVES_SUCCESS:
            return {
                ...state,
                reserves: action.reserves,
                isReservesLoaded: true
            };

        case types.UPDATE_ORDER_QUANTITY_SUCCESS:
            return {
                ...state,
                orders: action.orders,
                isOrdersLoaded: true
            };

        case types.UPDATE_RESERVE_PRICES_SUCCESS:
            return {
                ...state,
                reserves: action.reserves,
                isReservesLoaded: true
            };

        case types.UPDATE_RESERVE_QUANTITY_SUCCESS:
            return {
                ...state,
                reserves: action.reserves,
                isReservesLoaded: true
            };

        case types.CLIENT_DOESNT_EXIST:
            return {
                ...state,
                isClientNotExists: true
            };

        case types.LOAD_CLIENT_FAILURE:
            return {
                ...state,
                isClientNotExists: true
            };

        case types.LOG_OUT_SUCCESS:
            return {
                ...state,
                vip:'',
                fullName: ''
            };

        default:
            return state;
    }
}
