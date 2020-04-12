import {functions} from './database';

class FunctionsApi {
    static getClientByVip(vip){
        const func = functions.httpsCallable('main-getClientByVip');
        return func(vip);
    }
    static getOrdersByVip(vip){
        const func = functions.httpsCallable('order-getOrdersByVip');
        return func(vip);
    }
    static getReservesByVip(vip){
        const func = functions.httpsCallable('order-getReservesByVip');
        return func(vip);
    }
    static deleteOrdersByIds(ids){
        const func = functions.httpsCallable('order-deleteOrdersByIds');
        return func(ids);
    }
    static deleteReservesByIds(ids){
        const func = functions.httpsCallable('order-deleteReservesByIds');
        return func(ids);
    }
    static updateReservePrices(prices){
        const func = functions.httpsCallable('order-updateReservePrices');
        return func(prices);
    }
    static updateReserveQuantity({reserveId, quantity}){
        const func = functions.httpsCallable('order-updateReserveQuantity');
        return func({reserveId, quantity});
    }
    static updateOrderQuantity({orderId, quantity}){
        const func = functions.httpsCallable('order-updateOrderQuantity');
        return func({orderId, quantity});
    }
    static getPaymentsByVip(vip){
        const func = functions.httpsCallable('main-getPaymentsByVip');
        return func(vip);
    }
    static getClientStatistic({startDate, endDate}){
        const func = functions.httpsCallable('statistic-getClientStatistic');
        return func({startDate, endDate});
    }
    static getQueryStatistic({startDate, endDate}){
        const func = functions.httpsCallable('statistic-getQueryStatistic');
        return func({startDate, endDate});
    }
    static getStatisticByClient({startDate, endDate, vip}){
        const func = functions.httpsCallable('statistic-getStatisticByClient');
        return func({startDate, endDate, vip});
    }
    static getStatisticByVendor({startDate, endDate, vendorId}){
        const func = functions.httpsCallable('statistic-getStatisticByVendor');
        return func({startDate, endDate, vendorId});
    }
    static getVendorStatistic({startDate, endDate}){
        const func = functions.httpsCallable('statistic-getVendorStatistic');
        return func({startDate, endDate});
    }
}

export default FunctionsApi;