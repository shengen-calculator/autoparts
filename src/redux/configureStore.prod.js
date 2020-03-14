import {createStore, applyMiddleware} from 'redux';
import rootReducer, {rootPersistConfig} from './reducers';
import { persistStore, persistReducer } from 'redux-persist';
import createSagaMiddleware from 'redux-saga';
import mySaga from '../sagas';

export default function configureStore(initialState) {
    const persistedReducer = persistReducer(rootPersistConfig, rootReducer);
    const sagaMiddleware = createSagaMiddleware();
    const store = createStore(
        persistedReducer,
        initialState,
        applyMiddleware(
            sagaMiddleware)
    );
    // noinspection JSUnresolvedFunction
    sagaMiddleware.run(mySaga);
    let persistent = persistStore(store);
    return {store, persistent};
}