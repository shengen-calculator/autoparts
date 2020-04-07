const functions = require('firebase-functions');
const util = require('../util');

const searchByBrandAndNumber = async (data, context) => {

    util.CheckForManagerRole(context);

    if (!data) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with two arguments "Brand and Number"');
    }

    function createData(id, brand, number, description, retail, cost, available, reserve, order, term, date, isGoodQuality, isGuaranteedTerm) {
        return {
            id,
            brand,
            number,
            description,
            retail,
            cost,
            available,
            reserve,
            order,
            term,
            date,
            isGoodQuality,
            isGuaranteedTerm
        };
    }

    return [
        createData(1, 'BERU', 'Z30', 'Свеча зажигания 3330', 64.53, 41.855, 1, 1, 0, '1дн', '20.02.2020', true, false),
        createData(2, 'BERU', 'Z30', '(16:00, Сб. до 13:00) BERU 14FR-5DU Свеча зажигания ULTRA', 51.30, 34.95, 5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(3, 'BERU', 'Z30', '(16:00, Сб. до 13:00) BERU 14FR-5DU Свеча зажигания ULTRA', 24.40, 26.10, 5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(4, 'BERU', 'Z30', '(Вт/Чт 17:00, Сб. до 13:00) SPARK PLUG (14 FR-5 DU EA 0,8)', 24.99, 34.10, 5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(5, 'BERU', 'Z30', '(Вт/Чт 17:00, Сб. до 13:00) SPARK PLUG (14 FR-5 DU EA 0,8)', 49.44, 43.29, 5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(6, 'BERU', 'Z30', '(13:00, Сб. до 11:00) ŚWIECA ZAPŁONOWA PSA/FIAT', 87.90, 46.50, 5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(7, 'BERU', 'Z30', '(13:00, Сб. до 11:00) ŚWIECA ZAPŁONOWA PSA/FIAT', 37.90, 44.33, 5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(8, 'NGK', 'BCPR7ES', '(13:00, Сб. до 11:00) ŚWIECA ZAPŁONOWA PSA/FIAT', 96.4, 60.10, 5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(9, 'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 65.23, 74.10, 5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(10, 'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 98.11, 50.10, 5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(11, 'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 81.21, 22.10, 5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(12, 'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 99.89, 37.60, 5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(13, 'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 63.01, 54.60, 5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(14, 'RUVILE', '5413', 'Свеча зажигания 3330', 64.53, 41.855, 1, 1, 0, '1дн', '20.02.2020', true, true),
        createData(15, 'RUVILE', '5413', '(16:00, Сб. до 13:00) BERU 14FR-5DU Свеча зажигания ULTRA', 51.30, 34.95, 0, 1, 0, '1дн', '20.02.2020', true, false),
        createData(16, 'RUVILE', '5413', '(16:00, Сб. до 13:00) BERU 14FR-5DU Свеча зажигания ULTRA', 24.40, 26.10, 0, 1, 0, '1дн', '20.02.2020', false, true),
        createData(17, 'RUVILE', '5413', '(Вт/Чт 17:00, Сб. до 13:00) SPARK PLUG (14 FR-5 DU EA 0,8)', 24.99, 34.10, 0, 1, 0, '1дн', '20.02.2020', false, true),
        createData(18, 'RUVILE', '5413', '(Вт/Чт 17:00, Сб. до 13:00) SPARK PLUG (14 FR-5 DU EA 0,8)', 49.44, 43.29, 0, 1, 0, '1дн', '20.02.2020', false, true),
        createData(19, 'RUVILE', '5413', '(13:00, Сб. до 11:00) ŚWIECA ZAPŁONOWA PSA/FIAT', 87.90, 46.50, 0, 0, 0, '1дн', '20.02.2020', false, false),
        createData(20, 'RUVILE', '5413', '(13:00, Сб. до 11:00) ŚWIECA ZAPŁONOWA PSA/FIAT', 37.90, 44.33, 0, 1, 0, '1дн', '20.02.2020', false, false),
        createData(21, 'NGK', 'BCPR7ES', '(13:00, Сб. до 11:00) ŚWIECA ZAPŁONOWA PSA/FIAT', 96.4, 60.10, 0, 1, 0, '1дн', '20.02.2020', false, false),
        createData(22, 'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 65.23, 74.10, 5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(23, 'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 98.11, 50.10, 5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(24, 'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 81.21, 22.10, 5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(25, 'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 99.89, 37.60, 5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(26, 'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 63.01, 54.60, 5, 1, 0, '1дн', '20.02.2020', true, false),
    ];

};

module.exports = searchByBrandAndNumber;