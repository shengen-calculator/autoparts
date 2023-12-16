const functions = require('firebase-functions');
const util = require('../util');
const {Datastore} = require('@google-cloud/datastore');

const getUnblockRecords = async (data, context) => {
    util.checkForAdminRole(context);
    try {
        const datastore = new Datastore();
        const storeQuery = datastore
            .createQuery("unblock-records")
            .filter("vip", "=", data)
            .order("date", {
                descending: true
            })
            .limit(10);
        const queryResult = await datastore.runQuery(storeQuery);
        const [entities, info] = queryResult;
        return entities.map(entity => {
            return {
                date: entity.date.getTime(),
                vip: entity.vip
            }
        })
    } catch (err) {
        if (err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {err: err.message};
    }
};
module.exports = getUnblockRecords;
