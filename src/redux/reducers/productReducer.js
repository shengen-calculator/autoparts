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

        case types.LOAD_CLIENT_SUCCESS:
            return {
                ...state,
                productsGrouped: [],
                products: []
            };

        default:
            return state;
    }
}
