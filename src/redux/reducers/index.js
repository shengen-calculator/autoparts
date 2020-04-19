import {combineReducers} from 'redux';
import apiCallsInProgress from "./apiStatusReducer";
import { persistReducer } from 'redux-persist';
import authentication from './authenticationReducer';
import message from './messageReducer';
import client from './clientReducer';
import product from './productReducer';
import statistic from './statisticReducer';
import storage from 'redux-persist/lib/storage';

export const persistConfig = {
    key: 'root',
    storage,
    blacklist: ['message',
        'authentication',
        'client',
        'apiCallsInProgress',
        'statistic',
        'product'
    ]
};

const authPersistConfig = {
    key: 'authentication',
    storage: storage,
    blacklist: ['logging', 'outing']
};
const clientPersistConfig = {
    key: 'client',
    storage: storage,
    blacklist: [
        'orders',
        'isOrdersLoaded',
        'payments',
        'isPaymentsLoaded',
        'isClientNotExists',
        'isReservesLoaded',
        'reserves'
    ]
};

const rootReducer = combineReducers({
    authentication: persistReducer(authPersistConfig, authentication),
    client: persistReducer(clientPersistConfig, client),
    product,
    apiCallsInProgress,
    statistic,
    message
});

export default rootReducer;