import {database} from "./database";

class AppStateApi {
    static updateApplicationState = (state) => {
        return new Promise((resolve, reject) => {
            database.ref('app-settings').set(state).then(() => {
                resolve();
            }).catch((err) => {
                reject(new Error(err.message));
            });
        });
    };

    static subscribeToAppStateUpdate = (handler) => {
        return new Promise((resolve, reject) => {
            database.ref('app-settings').on('child_changed',
                (snapshot) => {
                    handler(snapshot);
                },
                (err) => {
                    reject(new Error(err.message))
                });
        });
    }
}

export default AppStateApi;