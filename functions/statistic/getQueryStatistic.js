const util = require('../util');

const getQueryStatistic = async (data, context) => {

    util.CheckForManagerRole(context);
    return {
        orderTotal: 245,
        order: 99,
        reserveTotal: 286,
        reserve: 63,
        registration: 130,
        queryTotal: 3526
    }

};

module.exports = getQueryStatistic;