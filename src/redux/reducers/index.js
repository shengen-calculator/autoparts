import {combineReducers} from 'redux';
import authentication from './authenticationReducer';
import { persistReducer } from 'redux-persist'
import message from './messageReducer';
import storage from 'redux-persist/lib/storage';

export const rootPersistConfig = {
    key: 'root',
    storage: storage,
    blacklist: ['authentication']
};

const authPersistConfig = {
    key: 'authentication',
    storage: storage,
    blacklist: ['registrating', 'logging']
};


const rootReducer = combineReducers({
    authentication : persistReducer(authPersistConfig, authentication),
    message
});

export default rootReducer;