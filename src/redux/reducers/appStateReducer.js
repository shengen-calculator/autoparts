import * as types from "../actions/actionTypes";
import initialState from "./initialState";

export default function appStateReducer(
    state = initialState.appState,
    action
) {
    if (action.type === types.APP_STATE_UPDATED) {
        return {...state, [action.snapshot.key] : action.snapshot.value}
    } else {
        return state;
    }
}