import {call, put} from "redux-saga/effects";
import * as types from "../redux/actions/actionTypes";
import AppStateApi from "../api/appState";

export function* updateAppState(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        yield call(AppStateApi.updateApplicationState, action.state);
        yield put({type: types.UPDATE_APP_STATE_SUCCESS});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.UPDATE_APP_STATE_FAILURE, text: e.message});
    }
}