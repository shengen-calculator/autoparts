const initialState = {
    authentication: {
        role: '',
        vip: '',
        logging: false,
        registrating: false
    },
    message: {
        type: '',
        text: ''
    },
    client: {
        id: '',
        vip: '',
        fullName: '',
        isEuroClient: false,
        isCityDeliveryUsed: false,
        orders: [],
        isOrdersLoaded: false,
        orderLoadingTime: {},
        reserves: [],
        isReservesLoaded: false,
        reserveLoadingTime: {},
        payments: [],
        isPaymentsLoaded: false,
        isClientNotExists: false,
        isPriceShown: true,
        paymentHistoryLoadingTime: null,
        paymentHistory: [],
        returnHistoryLoadingTime: null,
        returnHistory: [],
        saleHistoryLoadingTime: null,
        saleHistory: [],
    },
    apiCallsInProgress: 0,
    statistic: {
        queryStatistic: {
            orderTotal: 0,
            reserveTotal: 0,
            queryTotal: 0
        },
        clientStatistic: [],
        vendorStatistic: [],
        statisticByClient: [],
        statisticByVendor: [],
        startDate:0,
        endDate:0

    },
    product: {
        productsGrouped: [],
        products: [],
        criteria: {
            brand: '',
            numb: ''
        },
        inOrder: [],
        analogs: [],
        photos: {
            urls: []
        },
        deliveryDate: {}
    },
    appState: {
        isSearchPaused: false
    }
};
export default initialState;