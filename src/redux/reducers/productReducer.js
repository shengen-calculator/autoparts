import initialState from "./initialState";
import * as types from "../actions/actionTypes";

export default function productReducer(state = initialState.products, action) {
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

        default:
            return state;
    }
}
