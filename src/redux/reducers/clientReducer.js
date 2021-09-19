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
                isCityDeliveryUsed: action.client.isCityDeliveryUsed,
                orders: [],
                isOrdersLoaded: false,
                orderLoadingTime: {},
                reserves: [],
                isReservesLoaded: false,
                reserveLoadingTime: {},
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
                isOrdersLoaded: true,
                orderLoadingTime: new Date()
            };

        case types.LOAD_RESERVES_SUCCESS:
            return {
                ...state,
                reserves: action.reserves,
                isReservesLoaded: true,
                reserveLoadingTime: new Date()
            };

        case types.LOAD_PAYMENT_HISTORY_SUCCESS:
            return {
                ...state,
                paymentHistory: action.payments
            };

        case types.LOAD_RETURN_HISTORY_SUCCESS:
            return {
                ...state,
                returnHistory: action.returns
            };

        case types.LOAD_SALE_HISTORY_SUCCESS:
            return {
                ...state,
                saleHistory: action.sales
            };

        case types.LOAD_RETURN_HISTORY_REQUEST:
            return {
                ...state,
                returnHistory: [],
                returnHistoryLoadingTime:
                    action.params.offset > 0 || action.params.rows > 20 ?
                        null :
                        new Date()
            };

        case types.LOAD_SALE_HISTORY_REQUEST:
            return {
                ...state,
                saleHistory: [],
                saleHistoryLoadingTime:
                    action.params.offset > 0 || action.params.rows > 20 ?
                        null :
                        new Date()
            };

        case types.LOAD_PAYMENT_HISTORY_REQUEST:
            return {
                ...state,
                paymentHistory: [],
                paymentHistoryLoadingTime:
                    action.params.offset > 0 || action.params.rows > 20 ?
                        null :
                        new Date()
            };

        case types.DELETE_ORDERS_REQUEST:
            return {
                ...state,
                orders: state.orders.filter((item) => !action.ids.includes(item.id))
            };

        case types.SHOW_CLIENT_PRICE:
            return {
                ...state,
                isPriceShown: true
            };

        case types.HIDE_CLIENT_PRICE:
            return {
                ...state,
                isPriceShown: false
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
                id: '',
                vip: '',
                fullName: '',
                isEuroClient: false,
                isCityDeliveryUsed: false,
                orders: [],
                isOrdersLoaded: false,
                orderLoadingTime: {},
                reserves: [],
                isReservesLoaded: false,
                reserveLoadingTime: {},
                payments: [],
                isPaymentsLoaded: false,
                isClientNotExists: false
            };

        default:
            return state;
    }
}
