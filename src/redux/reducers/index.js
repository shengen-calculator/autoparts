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
    blacklist: ['message', 'authentication']
};

const authPersistConfig = {
    key: 'authentication',
    storage: storage,
    blacklist: ['logging', 'outing']
};

const rootReducer = combineReducers({
    authentication: persistReducer(authPersistConfig, authentication),
    message,
    apiCallsInProgress,
    client
});

export default rootReducer;