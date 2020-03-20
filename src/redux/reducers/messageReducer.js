import * as types from '../actions/actionTypes';
import initialState from './initialState';

export default function messageReducer(state = initialState.message, action) {
    switch (action.type) {

        case types.REGISTRATION_SUCCESS:
            return {
                ...state,
                type: 'success',
                text: 'Вітаємо. Реєстрація успішна.'
            };

        case types.REGISTRATION_FAILURE:
            return {
                ...state,
                type: 'error',
                text: action.text
            };

        case types.AUTHENTICATION_FAILURE:
            return {
                ...state,
                type: 'error',
                text: action.text
            };

        case types.AUTHENTICATION_ROLE_FAILURE:
            return {
                ...state,
                type: 'error',
                text: 'Ваш обліковий запис не активовано'
            };

        case types.CLIENT_DOESNT_EXIST:
            return {
                ...state,
                type: 'error',
                text: 'Клієнта з зазначеним ВІП-ом не знайдено'
            };

        case types.AUTHENTICATION_SUCCESS:
            return {
                ...state,
                type: 'success',
                text: 'Вітаємо в системі'
            };

        default:
            return state;
    }
}