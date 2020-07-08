import {database} from "./database";

class AppStateApi {
    static updateApplicationState(state) {
        database.ref('app-settings').set(state);
    }
}

export default AppStateApi;