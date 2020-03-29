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
        vip: '',
        fullName: '',
        orders: [],
        isOrdersLoaded: false,
        payments: [],
        isPaymentsLoaded: false,
        isClientNotExists: false
    },
    apiCallsInProgress: 0,
    statistic: {
        queryStatistic: {
            orderTotal: 0,
            order: 0,
            reserveTotal: 0,
            reserve: 0,
            registration: 0,
            queryTotal: 0
        },
        clientStatistic: [],
        vendorStatistic: [],
        statisticByClient: [],
        statisticByVendor: [],
        startDate:0,
        endDate:0

    },
    //products
};