import {call, put} from "redux-saga/effects";
import * as types from "../redux/actions/actionTypes";
import OtherFunctionsApi from "../api/otherFunctions";

export function* updateAppState(action) {
    try {
        yield put({type: types.BEGIN_API_CALL});
        const {data} = yield call(OtherFunctionsApi.updateApplicationState, action.state);
        yield put({type: types.UPDATE_APP_STATE_SUCCESS, state: data});
    } catch (e) {
        yield put({type: types.API_CALL_ERROR});
        yield put({type: types.UPDATE_APP_STATE_FAILURE, text: e.message});
    }
}