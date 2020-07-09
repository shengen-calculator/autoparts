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
                    handler({key: snapshot.key, value: snapshot.val()});
                },
                (err) => {
                    reject(new Error(err.message))
                });
        });
    };

    static unSubscribeToAppStateUpdate = () => {
        return new Promise(() => {
            database.ref('app-settings').off();
        });
    };

    static getInitialState = (handler) => {
        return new Promise((resolve, reject) => {
            database.ref('app-settings').once('value')
                .then((snapshot) => {
                    for (const [key, value] of Object.entries(snapshot.val())) {
                        handler({key, value});
                    }

                    resolve();
                }).catch((err)  => {
                    reject(new Error(err.message))
                });
        });
    }
}

export default AppStateApi;