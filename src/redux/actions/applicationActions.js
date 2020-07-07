import * as types from './actionTypes';

export function updateApplicationState(state) {
    return {type: types.UPDATE_APP_STATE_REQUEST, state};
}
