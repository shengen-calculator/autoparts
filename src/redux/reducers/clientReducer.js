import * as types from '../actions/actionTypes';
import initialState from './initialState';

export default function clientReducer(state = initialState.message, action) {
    switch (action.type) {

        case types.LOAD_CLIENT_SUCCESS:
            return {
                ...state,
                vip: action.vip,
                fullName: action.fullName,
                orders: [],
                isOrdersLoaded: false,
                payments: [],
                isPaymentsLoaded: false
            };

        default:
            return state;
    }
}
