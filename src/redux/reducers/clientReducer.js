import * as types from '../actions/actionTypes';
import initialState from './initialState';

export default function clientReducer(state = initialState.client, action) {
    switch (action.type) {

        case types.LOAD_CLIENT_SUCCESS:
            return {
                ...state,
                vip: action.client.vip,
                fullName: action.client.fullName,
                orders: [],
                isOrdersLoaded: false,
                payments: [],
                isPaymentsLoaded: false
            };

        case types.LOAD_PAYMENTS_SUCCESS:
            return {
                ...state,
                payments: action.payments,
                isPaymentsLoaded: true
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
