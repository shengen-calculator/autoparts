const util = require('../util');
const functions = require('firebase-functions');
const {Datastore} = require('@google-cloud/datastore');

const getLogs = async (data, context) => {

    util.checkForManagerRole(context);
    try {

        const datastore = new Datastore();
        const limit = ((data.limit || 25) > 500) ? 500 : data.limit;

        const query = datastore
            .createQuery('import-log', '')
            .order('Date', {
                descending: true,
            })
            .limit(limit);

        const result = await datastore.runQuery(query);
        const dateTimeFormat = new Intl.DateTimeFormat('en', {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit'
        });
        return result[0].map(x => {
            const [
                {value: month}, , {value: day}, , {value: year}, ,
                {value: hour}, , {value: minute}, , {value: second}, ,
                {value: dayPeriod}]
                = dateTimeFormat.formatToParts(x.Date);

            return {
                level: x.Level,
                description: x.Description,
                company: x.Company,
                date: `${day}-${month}-${year}`,
                time: `${hour}:${minute}:${second} ${dayPeriod}`
            }
        });

    } catch (err) {
        if (err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {error: err.message};
    }
};

module.exports = getLogs;