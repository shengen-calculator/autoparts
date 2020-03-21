import {functions} from './database';

class FunctionsApi {
    static getClientByVip(vip){
        const func = functions.httpsCallable('getClientByVip');
        return func(vip);
    }
    static getPaymentsByVip(vip){
        const func = functions.httpsCallable('getPaymentsByVip');
        return func(vip);
    }
    static getClientStatistic({startDate, endDate}){
        const func = functions.httpsCallable('getClientStatistic');
        return func({startDate, endDate});
    }
    static getQueryStatistic({startDate, endDate}){
        const func = functions.httpsCallable('getQueryStatistic');
        return func({startDate, endDate});
    }
    static getStatisticByClient({startDate, endDate}){
        const func = functions.httpsCallable('getStatisticByClient');
        return func({startDate, endDate});
    }
    static getStatisticByVendor({startDate, endDate}){
        const func = functions.httpsCallable('getStatisticByVendor');
        return func({startDate, endDate});
    }
    static getVendorStatistic({startDate, endDate}){
        const func = functions.httpsCallable('getVendorStatistic');
        return func({startDate, endDate});
    }
}

export default FunctionsApi;