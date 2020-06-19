import * as types from '../actions/actionTypes';
import initialState from './initialState';

export default function statisticReducer(state = initialState.statistic, action) {
    switch (action.type) {
        case types.LOAD_CLIENT_STATISTIC_REQUEST:
            return {
                ...state,
                clientStatistic: []
            };
        case types.LOAD_CLIENT_STATISTIC_SUCCESS:
            return {
                ...state,
                clientStatistic: action.result,
                queryStatistic: {
                    orderTotal: action.result.orderTotal,
                    order: action.result.order,
                    reserveTotal: action.result.reserveTotal,
                    reserve: action.result.reserve,
                    registration: action.result.registration,
                    queryTotal: action.result.queryTotal
                }
            };
        case types.LOAD_VENDOR_STATISTIC_REQUEST:
            return {
                ...state,
                vendorStatistic: []
            };
        case types.LOAD_VENDOR_STATISTIC_SUCCESS:
            return {
                ...state,
                vendorStatistic: action.result
            };
        case types.LOAD_STATISTIC_BY_CLIENT_REQUEST:
            return {
                ...state,
                statisticByClient: []
            };

        case types.LOAD_STATISTIC_BY_CLIENT_SUCCESS:
            return {
                ...state,
                statisticByClient: action.result
            };

        case types.LOAD_STATISTIC_BY_VENDOR_REQUEST:
            return {
                ...state,
                statisticByVendor: []
            };
        case types.LOAD_STATISTIC_BY_VENDOR_SUCCESS:
            return {
                ...state,
                statisticByVendor: action.result
            };
        case types.SET_STATISTIC_PERIOD:

            return {
                ...state,
                startDate: action.params.startDate,
                endDate: action.params.endDate
            };

        default:
            return state;
    }
}
