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

    static getPhotos({brand, number}) {
        const func = functions.httpsCallable('search-getPhotos');
        return func({
            brand: brand,
            number: removeAllSpecialCharacters(number)
        });
    }

    static getDeliveryDate({partId, term}) {
        const func = functions.httpsCallable('search-getDeliveryDate');
        return func({
            partId,
            term
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

    static updatePrice(params) {
        const func = functions.httpsCallable('search-updatePrice');
        return func(params);
    }
}

export default SearchFunctionsApi;