import {database} from "./database";

class AppStateApi {
    static updateApplicationState(state) {
        database.ref('app-settings').set(state);
    }

    static subscribeAppStateUpdate(handler, errorHandler) {
        return database.ref('app-settings').on('child_changed', function (snapshot) {
            handler(snapshot);
        }, function (error) {
            errorHandler(error);
        })
    }
}

export default AppStateApi;