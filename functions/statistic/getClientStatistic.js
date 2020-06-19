const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;
const {Datastore} = require('@google-cloud/datastore');
const Managers = require('../managers');

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
            //.select(['available', 'brand', 'number', 'success', 'vip', 'query'])
            .limit(2000);

        const [stat, totals] = await Promise.all([
            datastore.runQuery(query),
            pool.request()
                .input('startDate', sql.Date, data.startDate)
                .input('endDate', sql.Date, data.endDate)
                .execute('sp_web_getclientstatistic')
        ]);
        return  {
            statistic: stat[0],
            totals: totals.recordset,
            managers: Managers
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