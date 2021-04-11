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
    static getReconciliation({startDate, endDate, clientId, isEuroClient}){
        const func = functions.httpsCallable('main-getReconciliationData');
        return func({startDate, endDate, clientId, isEuroClient});
    }
    static deleteOrdersByIds(ids){
        const func = functions.httpsCallable('order-deleteOrdersByIds');
        return func(ids);
    }
    static deleteReservesByIds({selected}){
        const func = functions.httpsCallable('order-deleteReservesByIds');
        return func(selected);
    }
    static updateReserveQuantity({reserveId, quantity, productId}){
        const func = functions.httpsCallable('order-updateReserveQuantity');
        return func({reserveId, quantity, productId});
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
    static getStatisticByVendor(vendorId){
        const func = functions.httpsCallable('statistic-getStatisticByVendor');
        return func(vendorId);
    }
    static getVendorStatistic(){
        const func = functions.httpsCallable('statistic-getVendorStatistic');
        return func();
    }
    static getCurrencyRate(){
        const func = functions.httpsCallable('main-getCurrencyRate');
        return func();
    }
    static getPaymentHistory(params){
        const func = functions.httpsCallable('history-getPayments');
        return func(params);
    }
    static getReturnHistory(params){
        const func = functions.httpsCallable('history-getReturns');
        return func(params);
    }
    static getSaleHistory(params){
        const func = functions.httpsCallable('history-getSales');
        return func(params);
    }
}

export default FunctionsApi;