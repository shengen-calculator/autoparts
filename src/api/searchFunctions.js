import {functions} from "./database";

class SearchFunctionsApi {
    static checkIfPresentInOrderList(analogId) {
        const func = functions.httpsCallable('checkIfPresentInOrderList');
        return func(analogId);
    }
    static createOrder(vendorProductId) {
        const func = functions.httpsCallable('createOrder');
        return func(vendorProductId);
    }
    static createReserve(productId) {
        const func = functions.httpsCallable('createReserve');
        return func(productId);
    }
    static getByAnalog(analogId) {
        const func = functions.httpsCallable('getByAnalog');
        return func(analogId);
    }
    static getInfoByVendor(vendorId) {
        const func = functions.httpsCallable('getInfoByVendor');
        return func(vendorId);
    }
    static searchByBrandAndNumber({brand, number}) {
        const func = functions.httpsCallable('searchByBrandAndNumber');
        return func({brand, number});
    }
    static searchByNumber(number) {
        const func = functions.httpsCallable('searchByNumber');
        return func(number);
    }
    static updatePrice({productId, price, discount, retail}) {
        const func = functions.httpsCallable('updatePrice');
        return func({productId, price, discount, retail});
    }
}