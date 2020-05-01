import initialState from "./initialState";
import * as types from "../actions/actionTypes";

export default function productReducer(state = initialState.product, action) {
    switch (action.type) {
        case types.LOAD_BY_NUMBER_SUCCESS:
            return {
                ...state,
                productsGrouped: action.products,
                products: []
            };

        case types.LOAD_BY_BRAND_SUCCESS:
            return {
                ...state,
                productsGrouped: [],
                products: action.products
            };

        case types.LOAD_CLIENT_REQUEST:
            return {
                ...state,
                productsGrouped: [],
                products: [],
                criteria: {
                    brand: '',
                    numb: ''
                }
            };

        case types.LOAD_BY_NUMBER_REQUEST:
            return {
                ...state,
                productsGrouped: [],
                products: [],
                criteria: {
                    numb: action.number,
                    brand: ''
                }
            };

        case types.LOAD_BY_BRAND_REQUEST:
            return {
                ...state,
                criteria: {
                    numb: action.params.numb,
                    brand: action.params.brand
                }
            };

        case types.DELETE_RESERVES_REQUEST:
            return {
                ...state,
                products: state.products.map((item, index) => {
                    if (action.params.reserves.some(x => item.id === x.productId)) {
                        const reserves = action.params.reserves.filter(x => x.productId === item.id);
                        const quantity = reserves.reduce((a,b) => a + b.quantity, 0);
                        return {
                            ...item,
                            available: item.available + quantity,
                            reserve: item.reserve - quantity
                        }
                    }
                    return item
                })
            };


        case types.CREATE_RESERVE_REQUEST:
            return {
                ...state,
                products: state.products.map((item) => {
                    if(item.id !== action.params.productId) {
                        return item
                    }
                    return {
                        ...item,
                        available: item.available - action.params.quantity,
                        reserve: action.params.quantity + item.reserve
                    }
                })
            };

        default:
            return state;
    }
}
