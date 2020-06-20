const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;
const {Datastore} = require('@google-cloud/datastore');

const getClientStatistic = async (data, context) => {
    util.checkForManagerRole(context);

    if (!data || !data.startDate || !data.endDate) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with two arguments "start date" and "end date"');
    }

    try {
        const pool = await sql.connect(config);

        const datastore = new Datastore();

        const query = datastore
            .createQuery('queries','')
            .filter('date', '>=', new Date(`${data.startDate} 00:00:00:000`))
            .filter('date', '<=', new Date(`${data.endDate} 23:59:59:999`))
            .limit(2000);

        const [stat, totals] = await Promise.all([
            datastore.runQuery(query),
            pool.request()
                .input('startDate', sql.Date, data.startDate)
                .input('endDate', sql.Date, data.endDate)
                .execute('sp_web_getclientstatistic')
        ]);
        const dateTimeFormat = new Intl.DateTimeFormat('en', { year: 'numeric', month: '2-digit', day: '2-digit' });

        return  {
            statistic: stat[0].map(x => {
                const [{ value: month },,{ value: day },,{ value: year }] = dateTimeFormat .formatToParts(x.date);
                return {
                    vip: x.vip,
                    brand: x.brand,
                    number: x.number,
                    query: x.query,
                    available: x.available,
                    date: `${day}-${month}-${year }`
                }
            }),
            totals: totals.recordset
        };

    } catch (err) {
        if (err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {error: err.message};
    }

};

module.exports = getClientStatistic;