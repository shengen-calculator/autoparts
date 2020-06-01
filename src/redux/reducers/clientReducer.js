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
                id: action.client.id,
                vip: action.client.vip,
                fullName: action.client.fullName,
                isEuroClient: action.client.isEuroClient,
                orders: [],
                isOrdersLoaded: false,
                reserves: [],
                isReservesLoaded: false,
                payments: [],
                isPaymentsLoaded: false,
                reconciliationUrl: ''
            };

        case types.LOAD_PAYMENTS_SUCCESS:
            return {
                ...state,
                payments: action.payments,
                isPaymentsLoaded: true
            };

        case types.LOAD_RECONCILIATION_SUCCESS:
            return {
                ...state,
                reconciliationUrl: action.url
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

        case types.DELETE_ORDERS_REQUEST:
            return {
                ...state,
                orders: state.orders.filter((item) => !action.ids.includes(item.id))
            };

        case types.DELETE_RESERVES_REQUEST:
            return {
                ...state,
                reserves: state.reserves.filter((item) => !action.params.selected.includes(item.id))
            };

        case types.UPDATE_ORDER_QUANTITY_REQUEST:
            return {
                ...state,
                orders: state.orders.map((item) => {
                    if (item.id !== action.params.orderId) {
                        return item
                    }
                    return {
                        ...item,
                        ordered: action.params.quantity
                    }
                })
            };
        case types.CREATE_RESERVE_SUCCESS:
            return {
                ...state,
                reserves: [
                    action.reserve,
                    ...state.reserves
                ]
            };

        case types.CREATE_ORDER_SUCCESS:
            return {
                ...state,
                orders: [
                    action.order,
                    ...state.orders
                ]
            };

        case types.UPDATE_RESERVE_QUANTITY_REQUEST:
            return {
                ...state,
                reserves: state.reserves.map((item) => {
                    if (item.id !== action.params.reserveId) {
                        return item
                    }
                    return {
                        ...item,
                        quantity: action.params.quantity
                    }
                })
            };

        case types.UPDATE_RESERVE_QUANTITY_FAILURE:
            return {
                ...state,
                reserves: state.reserves.map((item) => {
                    if (item.id !== action.params.reserveId) {
                        return item
                    }
                    return {
                        ...item,
                        quantity: action.params.prevQuantity
                    }
                })
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
                vip: '',
                fullName: '',
                isEuroClient: false,
                orders: [],
                isOrdersLoaded: false,
                reserves: [],
                isReservesLoaded: false,
                payments: [],
                isPaymentsLoaded: false,
                isClientNotExists: false
            };

        default:
            return state;
    }
}
