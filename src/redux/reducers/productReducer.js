import initialState from "./initialState";
import * as types from "../actions/actionTypes";

export default function productReducer(state = initialState.product, action) {
    switch (action.type) {
        case types.LOAD_BY_NUMBER_SUCCESS:
            return {
                ...state,
                productsGrouped: action.products,
                products: [],
                inOrder: []
            };

        case types.LOAD_BY_BRAND_SUCCESS:
            return {
                ...state,
                productsGrouped: [],
                products: action.products.search,
                inOrder: action.products.inOrder
            };

        case types.LOAD_CLIENT_REQUEST:
            return {
                ...state,
                productsGrouped: [],
                products: [],
                inOrder: [],
                criteria: {
                    brand: '',
                    numb: ''
                }
            };

        case types.LOAD_ANALOGS_REQUEST:
            return {
                ...state,
                analogs: []
            };

        case types.LOAD_ANALOGS_SUCCESS:
            return {
                ...state,
                analogs: action.analogs ? action.analogs : []
            };

        case types.LOAD_PHOTOS_REQUEST:
            return {
                ...state,
                photos: {
                    searchUrl: '',
                    urls: []
                }
            };

        case types.LOAD_PHOTOS_SUCCESS:
            return {
                ...state,
                photos: {
                    searchUrl: '',
                    urls: []
                }
            };

        case types.LOAD_BY_NUMBER_REQUEST:
            return {
                ...state,
                productsGrouped: [],
                products: [],
                inOrder: [],
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
                products: state.products.map((item) => {
                    if (action.params.reserves.some(x => item.id === x.productId)) {
                        const reserves = action.params.reserves.filter(x => x.productId === item.id);
                        const quantity = reserves.reduce((a, b) => a + b.quantity, 0);
                        return {
                            ...item,
                            available: item.available + quantity,
                            reserve: item.reserve - quantity
                        }
                    }
                    return item
                })
            };

        case types.UPDATE_RESERVE_QUANTITY_SUCCESS:
            return {
                ...state,
                products: state.products.map((item) => {
                    if (item.id !== action.params.productId) {
                        // This isn't the item we care about - keep it as-is
                        return item
                    }

                    // Otherwise, this is the one we want - return an updated value
                    return {
                        ...item,
                        available: item.available + action.params.prevQuantity - action.params.quantity,
                        reserve: item.reserve + action.params.quantity - action.params.prevQuantity
                    }
                })
            };

        case types.CREATE_RESERVE_REQUEST:
            return {
                ...state,
                products: state.products.map((item) => {
                    if (item.id !== action.params.productId) {
                        return item
                    }
                    return {
                        ...item,
                        available: item.available - action.params.quantity,
                        reserve: action.params.quantity + item.reserve
                    }
                })
            };
        case types.UPDATE_PRICE_REQUEST:
            return {
                ...state,
                analogs: state.analogs.map((item) => {
                    if (item.productId !== action.params.productId) {
                        return item
                    }
                    return {
                        ...item,
                        price: action.params.price ? action.params.price : '',
                        retail: action.params.discount && action.params.discount ?
                            (action.params.price / (100 - action.params.discount) * 100).toFixed(2) : '',
                        discount: action.params.discount ? action.params.discount : ''
                    }
                })
            };

        default:
            return state;
    }
}
