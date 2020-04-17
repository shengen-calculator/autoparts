const functions = require('firebase-functions');
const util = require('../util');

const searchByBrandAndNumber = async (data, context) => {

    util.CheckForManagerRole(context);

    if (!data ||!data.number ||!data.brand ) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with two arguments "Brand and Number"');
    }

    function createData(id, vendor, brand, number, description, retail, retailEur, cost, costEur, available, reserve, order, term, date, isGoodQuality, isGuaranteedTerm) {
        return {
            id,
            vendor,
            brand,
            number,
            description,
            retail,
            retailEur,
            cost,
            costEur,
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
        createData(1, 'ELIT','BERU', 'Z30', 'Свеча зажигания 3330', 64.53, 41.855, 1, 1, 0, '1дн', '20.02.2020', true, false),
        createData(2,'IC', 'BERU', 'Z30', '(16:00, Сб. до 13:00) BERU 14FR-5DU Свеча зажигания ULTRA', 51.30, 2.2, 34.95, 2.05, 5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(3,'ELIT',  'BERU', 'Z30', '(16:00, Сб. до 13:00) BERU 14FR-5DU Свеча зажигания ULTRA', 24.40, 1.05, 26.10,  0.95, 5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(4,'VA',  'BERU', 'Z30', '(Вт/Чт 17:00, Сб. до 13:00) SPARK PLUG (14 FR-5 DU EA 0,8)', 24.99, 0.85, 34.10,  0.75, 5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(5,'ELIT',  'BERU', 'Z30', '(Вт/Чт 17:00, Сб. до 13:00) SPARK PLUG (14 FR-5 DU EA 0,8)', 49.44, 2.11, 43.29, 2.06, 5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(6,'VA',  'BERU', 'Z30', '(13:00, Сб. до 11:00) ŚWIECA ZAPŁONOWA PSA/FIAT', 87.90, 3.05, 46.50, 5,1, 0, '1дн', '20.02.2020', true, false),
        createData(7,'V',  'BERU', 'Z30', '(13:00, Сб. до 11:00) ŚWIECA ZAPŁONOWA PSA/FIAT', 37.90, 1.25, 44.33, 5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(8,'IC',  'NGK', 'BCPR7ES', '(13:00, Сб. до 11:00) ŚWIECA ZAPŁONOWA PSA/FIAT', 96.4, 4.02, 60.10, 5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(9,'VA',  'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 65.23, 2.02, 74.10, 1.97, 5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(10,'ELIT',  'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 98.11, 2.02,50.10, 1.97,5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(11,'OMEGA',  'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 81.21, 2.02,22.10, 1.97,5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(12,'ELIT',  'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 99.89, 2.02,37.60, 1.97,5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(13,'VA',  'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 63.01, 2.02,54.60, 1.97,5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(14,'ELIT',  'RUVILE', '5413', 'Свеча зажигания 3330', 64.53, 2.02,41.855, 1.97,1, 1, 0, '1дн', '20.02.2020', true, true),
        createData(15,'IC',  'RUVILE', '5413', '(16:00, Сб. до 13:00) BERU 14FR-5DU Свеча зажигания ULTRA', 51.30, 2.02,34.95, 1.97,0, 1, 0, '1дн', '20.02.2020', true, false),
        createData(16,'VA',  'RUVILE', '5413', '(16:00, Сб. до 13:00) BERU 14FR-5DU Свеча зажигания ULTRA', 24.40, 2.02,26.10, 1.97,0, 1, 0, '1дн', '20.02.2020', false, true),
        createData(17,'ELIT',  'RUVILE', '5413', '(Вт/Чт 17:00, Сб. до 13:00) SPARK PLUG (14 FR-5 DU EA 0,8)', 24.99, 2.02,34.10, 1.97,0, 1, 0, '1дн', '20.02.2020', false, true),
        createData(18,'IC',  'RUVILE', '5413', '(Вт/Чт 17:00, Сб. до 13:00) SPARK PLUG (14 FR-5 DU EA 0,8)', 49.44, 2.02,43.29, 1.97,0, 1, 0, '1дн', '20.02.2020', false, true),
        createData(19,'ELIT',  'RUVILE', '5413', '(13:00, Сб. до 11:00) ŚWIECA ZAPŁONOWA PSA/FIAT', 87.90, 2.02,46.50, 1.97,0, 0, 0, '1дн', '20.02.2020', false, false),
        createData(20,'OMEGA',  'RUVILE', '5413', '(13:00, Сб. до 11:00) ŚWIECA ZAPŁONOWA PSA/FIAT', 37.90, 2.02,44.33, 1.97,0, 1, 0, '1дн', '20.02.2020', false, false),
        createData(21,'OMEGA',  'NGK', 'BCPR7ES', '(13:00, Сб. до 11:00) ŚWIECA ZAPŁONOWA PSA/FIAT', 96.4, 2.02,60.10, 1.97,0, 1, 0, '1дн', '20.02.2020', false, false),
        createData(22,'ELIT',  'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 65.23, 2.02,74.10, 1.97,5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(23,'OMEGA',  'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 98.11, 2.02,50.10, 1.97,5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(24,'V',  'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 81.21, 2.02,22.10, 1.97,5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(25,'OMEGA',  'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 99.89, 2.02,37.60, 1.97,5, 1, 0, '1дн', '20.02.2020', true, false),
        createData(26,'ELIT',  'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 63.01, 2.02,54.60, 1.97,5, 1, 0, '1дн', '20.02.2020', true, false),
    ];

};

module.exports = searchByBrandAndNumber;