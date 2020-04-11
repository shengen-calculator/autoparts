import {functions} from "./database";

class SearchFunctionsApi {
    static checkIfPresentInOrderList(vip) {
        const func = functions.httpsCallable('checkIfPresentInOrderList');
        return func(vip);
    }
    static createOrder(vip) {
        const func = functions.httpsCallable('createOrder');
        return func(vip);
    }
    static createReserve(vip) {
        const func = functions.httpsCallable('createReserve');
        return func(vip);
    }
    static getByAnalog(vip) {
        const func = functions.httpsCallable('getByAnalog');
        return func(vip);
    }
    static getInfoByVendor(vip) {
        const func = functions.httpsCallable('getInfoByVendor');
        return func(vip);
    }
    static searchByBrandAndNumber(vip) {
        const func = functions.httpsCallable('searchByBrandAndNumber');
        return func(vip);
    }
    static searchByNumber(vip) {
        const func = functions.httpsCallable('searchByNumber');
        return func(vip);
    }
    static updatePrice(vip) {
        const func = functions.httpsCallable('updatePrice');
        return func(vip);
    }
}