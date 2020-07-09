import * as types from './actionTypes';

export function updateApplicationState(state) {
    return {type: types.UPDATE_APP_STATE_REQUEST, state};
}

export function subscribeToApplicationStateUpdate(callback) {
    return {type: types.SUBSCRIBE_TO_APP_STATE_UPDATE_REQUEST, callback};
}

export function unSubscribe() {
    return {type: types.UNSUBSCRIBE_TO_APP_STATE_UPDATE_REQUEST};
}

export function appStateUpdated(snapshot) {
    return {type: types.APP_STATE_UPDATED, snapshot};
}
