import {functions} from "./database";

class OtherFunctionsApi {
    static updateApplicationState(state) {
        const func = functions.httpsCallable('main-updateAppState');
        return func(state);
    }
}

export default OtherFunctionsApi;