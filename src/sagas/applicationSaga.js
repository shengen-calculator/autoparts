import {call, put} from "redux-saga/effects";
import * as types from "../redux/actions/actionTypes";
import AppStateApi from "../api/appState";

export function* updateAppState(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        yield call(AppStateApi.updateApplicationState, action.state);
        yield put({type: types.UPDATE_APP_STATE_SUCCESS});
    } catch (error) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.UPDATE_APP_STATE_FAILURE, text: error.message})
    }
}

export function* subscribeToAppState(action) {
    try {
        yield call(AppStateApi.subscribeToAppStateUpdate, action.callback);
    } catch (error) {
        yield put({type: types.SUBSCRIBE_TO_APP_STATE_UPDATE_FAILURE, text: error.message})
    }
}