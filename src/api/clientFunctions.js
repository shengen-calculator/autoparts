import {functions} from './database';

class FunctionsApi {
    static getClientByVip(vip){
        const func = functions.httpsCallable('getClientByVip');
        return func(vip);
    }
    static getOrdersByVip(vip){
        const func = functions.httpsCallable('getOrdersByVip');
        return func(vip);
    }
    static getReservesByVip(vip){
        const func = functions.httpsCallable('getReservesByVip');
        return func(vip);
    }
    static deleteOrdersByIds(ids){
        const func = functions.httpsCallable('deleteOrdersByIds');
        return func(ids);
    }
    static deleteReservesByIds(ids){
        const func = functions.httpsCallable('deleteReservesByIds');
        return func(ids);
    }
    static updateReservePrices(prices){
        const func = functions.httpsCallable('updateReservePrices');
        return func(prices);
    }
    static updateReserveQuantity({reserveId, quantity}){
        const func = functions.httpsCallable('updateReserveQuantity');
        return func({reserveId, quantity});
    }
    static updateOrderQuantity({orderId, quantity}){
        const func = functions.httpsCallable('updateOrderQuantity');
        return func({orderId, quantity});
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
    static getStatisticByClient({startDate, endDate, vip}){
        const func = functions.httpsCallable('getStatisticByClient');
        return func({startDate, endDate, vip});
    }
    static getStatisticByVendor({startDate, endDate, vendorId}){
        const func = functions.httpsCallable('getStatisticByVendor');
        return func({startDate, endDate, vendorId});
    }
    static getVendorStatistic({startDate, endDate}){
        const func = functions.httpsCallable('getVendorStatistic');
        return func({startDate, endDate});
    }
}

export default FunctionsApi;