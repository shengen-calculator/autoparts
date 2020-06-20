export default {
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
        orders: [],
        isOrdersLoaded: false,
        reserves: [],
        isReservesLoaded: false,
        payments: [],
        isPaymentsLoaded: false,
        isClientNotExists: false
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
        }
    }
};