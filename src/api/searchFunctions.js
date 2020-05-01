import {functions} from "./database";
import {htmlDecode, removeAllSpecialCharacters} from "../util/Search";

class SearchFunctionsApi {
    static checkIfPresentInOrderList(analogId) {
        const func = functions.httpsCallable('search-checkIfPresentInOrderList');
        return func(analogId);
    }
    static createOrder(params) {
        const func = functions.httpsCallable('search-createOrder');
        return func(params);
    }
    static createReserve({clientId, productId, price, isEuroClient, quantity}) {
        const func = functions.httpsCallable('search-createReserve');
        return func({clientId, productId, price, isEuroClient, quantity});
    }
    static getByAnalog(analogId) {
        const func = functions.httpsCallable('search-getByAnalog');
        return func(analogId);
    }
    static searchByBrandAndNumber({brand, numb, clientId}) {
        const func = functions.httpsCallable('search-searchByBrandAndNumber');
        return func({brand: htmlDecode(brand), number: removeAllSpecialCharacters(numb), clientId});
    }
    static searchByNumber(number) {
        const func = functions.httpsCallable('search-searchByNumber');
        return func(number);
    }
    static updatePrice({productId, price, discount, retail}) {
        const func = functions.httpsCallable('search-updatePrice');
        return func({productId, price, discount, retail});
    }
}
export default SearchFunctionsApi;