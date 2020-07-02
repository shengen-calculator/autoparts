import {functions} from "./database";
import {htmlDecode, removeAllSpecialCharacters} from "../util/Search";

class SearchFunctionsApi {
    static createOrder(params) {
        const func = functions.httpsCallable('search-createOrder');
        return func(params);
    }

    static createReserve(params) {
        const func = functions.httpsCallable('search-createReserve');
        return func(params);
    }

    static getAnalogs({analogId, brand, number}) {
        const func = functions.httpsCallable('search-getAnalogs');
        return func({
            analogId: analogId,
            brand: brand,
            number: removeAllSpecialCharacters(number)
        });
    }

    static searchByBrandAndNumber({brand, numb, clientId, queryId, analogId}) {
        const func = functions.httpsCallable('search-searchByBrandAndNumber');
        return func({
            brand: htmlDecode(brand),
            number: removeAllSpecialCharacters(numb),
            originalNumber: numb,
            clientId,
            queryId,
            analogId,
        });
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