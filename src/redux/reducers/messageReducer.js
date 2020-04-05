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

        case types.LOAD_CLIENT_SUCCESS:
            return {
                ...state,
                type: 'success',
                text: 'Клієнта успішно завантажено'
            };

        case types.LOAD_CLIENT_FAILURE:
            return {
                ...state,
                type: 'error',
                text: 'Спробуйте завантажити клієнта ще раз'
            };

        case types.LOAD_CLIENT_STATISTIC_FAILURE:
            return {
                ...state,
                type: 'error',
                text: 'Спробуйте завантажити загальну статистику для клієнтів ще раз'
            };

        case types.LOAD_VENDOR_STATISTIC_FAILURE:
            return {
                ...state,
                type: 'error',
                text: 'Спробуйте завантажити загальну статистику для постачальників ще раз'
            };

        case types.LOAD_QUERY_STATISTIC_FAILURE:
            return {
                ...state,
                type: 'error',
                text: 'Спробуйте завантажити загальну статистику за запитами ще раз'
            };


        case types.LOAD_STATISTIC_BY_CLIENT_FAILURE:
            return {
                ...state,
                type: 'error',
                text: 'Спробуйте завантажити статистику клієнта ще раз'
            };

        case types.LOAD_ORDERS_FAILURE:
            return {
                ...state,
                type: 'error',
                text: 'Спробуйте завантажити замовлення клієнта ще раз'
            };

        case types.DELETE_ORDERS_FAILURE:
            return {
                ...state,
                type: 'error',
                text: 'Не вдалось видалити замовлення, спробуйте ще раз'
            };

        case types.UPDATE_ORDERS_PRICE_FAILURE:
            return {
                ...state,
                type: 'error',
                text: 'Нажаль, не вдалось змінити ціну. Спробуйте ще раз'
            };

        case types.UPDATE_ORDER_QUANTITY_FAILURE:
            return {
                ...state,
                type: 'error',
                text: 'Нажаль, не вдалось змінити кількість в замовленні. Спробуйте ще раз'
            };

        case types.LOAD_PAYMENTS_FAILURE:
            return {
                ...state,
                type: 'error',
                text: 'Спробуйте завантажити план платежів клієнта ще раз'
            };

        case types.LOAD_STATISTIC_BY_VENDOR_FAILURE:
            return {
                ...state,
                type: 'error',
                text: 'Спробуйте завантажити статистику постачальника ще раз'
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