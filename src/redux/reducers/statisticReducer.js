import * as types from '../actions/actionTypes';
import initialState from './initialState';

export default function statisticReducer(state = initialState.statistic, action) {
    switch (action.type) {
        case types.LOAD_QUERY_STATISTIC_SUCCESS:
            return {
                ...state,
                queryStatistic: {
                    orderTotal: action.orderTotal,
                    order: action.order,
                    reserveTotal: action.reserveTotal,
                    reserve: action.reserve,
                    registration: action.registration,
                    queryTotal: action.queryTotal
                }
            };

        case types.LOAD_CLIENT_STATISTIC_SUCCESS:
            return {
                ...state,
                clientStatistic: action.clientStatistic
            };

        case types.LOAD_VENDOR_STATISTIC_SUCCESS:
            return {
                ...state,
                vendorStatistic: action.vendorStatistic
            };

        case types.LOAD_STATISTIC_BY_CLIENT_SUCCESS:
            return {
                ...state,
                statisticByClient: action.statisticByClient
            };

        case types.LOAD_STATISTIC_BY_VENDOR_SUCCESS:
            return {
                ...state,
                statisticByVendor: action.statisticByVendor
            };

        default:
            return state;
    }
}
