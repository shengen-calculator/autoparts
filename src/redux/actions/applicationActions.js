import * as types from './actionTypes';

export function updateApplicationState(params) {
    return {type: types.UPDATE_APP_STATE_REQUEST, params};
}
