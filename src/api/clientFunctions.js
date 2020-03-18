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
}

export default FunctionsApi;