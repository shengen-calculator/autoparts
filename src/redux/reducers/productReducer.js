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
                products: []
            };

        case types.LOAD_BY_NUMBER_REQUEST:
            return {
                ...state,
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

        default:
            return state;
    }
}
