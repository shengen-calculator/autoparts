import * as types from './actionTypes';


export function showToastrMessage(msg) {
    return { type: types.MESSAGE_SHOW, msg};
}