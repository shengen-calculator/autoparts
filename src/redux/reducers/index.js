import {combineReducers} from 'redux';
import { persistReducer } from 'redux-persist';
import authentication from './authenticationReducer';
import message from './messageReducer';
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
    message
});

export default rootReducer;