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
            const totals = new Map();
            action.result.totals.forEach((el) => {
                totals.set(el['VIP'], {
                    vip: el['VIP'],
                    reserves: el['Reserves'],
                    orders: el['Orders'],
                    requests: 0,
                    succeeded: 0,
                })
            });

            action.result.statistic.forEach((el) => {
                if (totals.has(el.vip)) {
                    const old = totals.get(el.vip);
                    totals.set(el.vip, {
                        vip: el.vip,
                        reserves: old.reserves,
                        orders: old.orders,
                        requests: old.requests + 1,
                        succeeded: el.success ? old.succeeded + 1 : old.succeeded
                    })
                } else {
                    totals.set(el.vip, {
                        vip: el.vip,
                        reserves: 0,
                        orders: 0,
                        requests: 1,
                        succeeded: el.success ? 1 : 0
                    })
                }
            });

            return {
                ...state,
                clientStatistic: [...totals.values()],
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
