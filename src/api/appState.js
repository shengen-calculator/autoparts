import {database} from "./database";

class AppStateApi {
    static updateApplicationState = function (state) {
        return new Promise(function (resolve, reject) {
            database.ref('app-settings').set(state).then(() => {
                resolve();
            }).catch((err) => {
                reject(new Error(err.message));
            });
        });
    };

    static subscribeAppStateUpdate(handler, errorHandler) {
        return database.ref('app-settings').on('child_changed', function (snapshot) {
            handler(snapshot);
        }, function (error) {
            errorHandler(error);
        })
    }
}

export default AppStateApi;