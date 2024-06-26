import * as types from '../actions/actionTypes';
import initialState from './initialState';

export default function messageReducer(state = initialState.message, action) {
    switch (action.type) {

        case types.MESSAGE_SHOW:
            return {
                ...state,
                type: action.msg.type,
                text: action.msg.message
            };

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

        case types.LOAD_ANALOGS_FAILURE:
            return {
                ...state,
                type: 'error',
                text: 'Виникла помилка під час завантаження аналогів для редагування цін'
            };

        case types.LOAD_PHOTOS_FAILURE:
            return {
                ...state,
                type: 'error',
                text: 'Виникла помилка під час завантаження зображень'
            };

        case types.LOAD_CLIENT_STATISTIC_FAILURE:
            return {
                ...state,
                type: 'error',
                text: 'Спробуйте завантажити загальну статистику для клієнтів ще раз'
            };

        case types.LOAD_RECONCILIATION_FAILURE:
            return {
                ...state,
                type: 'error',
                text: 'Спробуйте завантажити акт звірки ще раз'
            };

        case types.LOAD_VENDOR_STATISTIC_FAILURE:
            return {
                ...state,
                type: 'error',
                text: 'Спробуйте завантажити загальну статистику для постачальників ще раз'
            };

        case types.LOAD_ORDERS_FAILURE:
            return {
                ...state,
                type: 'error',
                text: 'Спробуйте завантажити замовлення клієнта ще раз'
            };

        case types.LOAD_RESERVES_FAILURE:
            return {
                ...state,
                type: 'error',
                text: 'Спробуйте завантажити резерви клієнта ще раз'
            };

        case types.DELETE_ORDERS_FAILURE:
            return {
                ...state,
                type: 'error',
                text: 'Не вдалось видалити замовлення, спробуйте ще раз'
            };

        case types.DELETE_RESERVES_FAILURE:
            return {
                ...state,
                type: 'error',
                text: 'Не вдалось скасувати резерви клієнта, спробуйте ще раз'
            };

        case types.UPDATE_ORDER_QUANTITY_FAILURE:
            return {
                ...state,
                type: 'error',
                text: 'Нажаль, не вдалось змінити кількість в замовленні. Спробуйте ще раз'
            };

        case types.UPDATE_RESERVE_QUANTITY_FAILURE:
            if(action.params.error && action.params.error === 'QUANTITY_NOT_ENOUGH') {
                return {
                    ...state,
                    type: 'error',
                    text: 'Недостатня кількість'
                };
            }
            return {
                ...state,
                type: 'error',
                text: 'Нажаль, не вдалось змінити кількість зарезервованих позицій. Спробуйте ще раз'
            };

        case types.LOAD_UNBLOCK_RECORDS_FAILURE:
            return {
                ...state,
                type: 'error',
                text: 'Невдалось завантажити дані по розблокуваннях.'
            };

        case types.UNBLOCK_CLIENT_SUCCESS:
            return {
                ...state,
                type: 'success',
                text: 'Клієнта успішно розблоковано.'
            };

        case types.UNBLOCK_CLIENT_FAILURE:
            if (action.text === 'Client is already unblocked') {
                return {
                    ...state,
                    type: 'error',
                    text: 'Клієнта вже розблоковао. Необхідності повторного розблокування не має.'
                }
            }
            return {
                ...state,
                type: 'error',
                text: 'Невдалось розблокувати клієнта.'
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
        case types.CREATE_ORDER_FAILURE:
            if (action.text === "User account is blocked. Please contact administrator.") {
                return {
                    ...state,
                    type: 'error',
                    text: 'Є протермінована заборгованість. Резервувавння та замовлення заблоковані.'
                }
            }
            return {
                ...state,
                type: 'error',
                text: 'Виникла помилка під час замовлення. Повторіть спробу'
            };
        case types.CREATE_RESERVE_FAILURE:
            if (action.text === "User account is blocked. Please contact administrator.") {
                return {
                    ...state,
                    type: 'error',
                    text: 'Є протермінована заборгованість. Резервувавння та замовлення заблоковані.'
                }
            }
            return {
                ...state,
                type: 'error',
                text: 'Виникла помилка під час резерву позиції. Повторіть спробу'
            };
        case types.LOAD_CURRENCY_RATE_FAILURE:
            return {
                ...state,
                type: 'error',
                text: 'Виникла помилка під час отримання актуальних курсів валют. Повторіть спробу'
            };
        case types.UPDATE_PRICE_FAILURE:
            return {
                ...state,
                type: 'error',
                text: 'Не вдалось встановити нові ціни для артикула. Повторіть спробу'
            };
        case types.UPDATE_APP_STATE_FAILURE:
            return {
                ...state,
                type: 'error',
                text: action.text
            };
        case types.SUBSCRIBE_TO_APP_STATE_UPDATE_FAILURE:
            return {
                ...state,
                type: 'error',
                text: action.text
            };
        case types.CREATE_RESERVE_SUCCESS:
            return {
                ...state,
                type: 'success',
                text: `${action.reserve.brand} ${action.reserve.number} додано в резерв`
            };
        case types.CREATE_ORDER_SUCCESS:
            return {
                ...state,
                type: 'success',
                text: `${action.order.brand} ${action.order.number} додано в замовлення`
            };
        case types.LOAD_CURRENCY_RATE_SUCCESS:
            return {
                ...state,
                type: 'success',
                text: `EUR: ${action.rate['EUR'].toFixed(2)} / USD: ${action.rate['USD'].toFixed(2)}`
            };
        default:
            return state;
    }
}
