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
            const totals = action.result.totals.map(x => {
                return {
                    vip: x['VIP'],
                    reserves: x['Reserves'],
                    orders: x['Orders'],
                    requests: action.result.statistic.filter(el => el.vip === x['VIP']).length,
                    succeeded: action.result.statistic.filter(el => el.vip === x['VIP'] && el.success).length,
                }
            });
            return {
                ...state,
                clientStatistic: totals.filter(el => el.requests > 0),
                statisticByClient: action.result.statistic,
                queryStatistic: {
                    orderTotal: action.result.totals.reduce((a, b) => a + b['Orders'], 0),
                    reserveTotal: action.result.totals.reduce((a, b) => a + b['Reserves'], 0),
                    queryTotal: action.result.statistic.length
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
