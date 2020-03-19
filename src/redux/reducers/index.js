import {combineReducers} from 'redux';
import apiCallsInProgress from "./apiStatusReducer";
import { persistReducer } from 'redux-persist';
import authentication from './authenticationReducer';
import message from './messageReducer';
import client from './clientReducer';
import storage from 'redux-persist/lib/storage';

export const persistConfig = {
    key: 'root',
    storage,
    blacklist: ['message', 'authentication', 'client', 'apiCallsInProgress']
};

const authPersistConfig = {
    key: 'authentication',
    storage: storage,
    blacklist: ['logging', 'outing']
};
const clientPersistConfig = {
    key: 'client',
    storage: storage,
    blacklist: ['orders', 'isOrdersLoaded', 'payments', 'isPaymentsLoaded']
};

const rootReducer = combineReducers({
    authentication: persistReducer(authPersistConfig, authentication),
    client: persistReducer(clientPersistConfig, client),
    apiCallsInProgress,
    message
});

export default rootReducer;