import {call, put} from "redux-saga/effects";
import * as types from "../redux/actions/actionTypes";
import AppStateApi from "../api/appState";

export function* updateAppState(action) {
    try {
        yield call(AppStateApi.updateApplicationState, action.state);
    } catch (error) {
        yield put({type: types.UPDATE_APP_STATE_FAILURE, text: error.message})
    }
}