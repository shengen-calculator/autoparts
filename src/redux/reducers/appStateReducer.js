import * as types from "../actions/actionTypes";
import initialState from "./initialState";

export default function appStateReducer(
    state = initialState.appState,
    action
) {
    if (action.type === types.UPDATE_APP_STATE_SUCCESS) {
        return action.state;
    } else {
        return state;
    }
}