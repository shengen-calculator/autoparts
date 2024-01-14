const functions = require('firebase-functions');
const util = require('../util');
const {Datastore} = require('@google-cloud/datastore');

const unblockClient = async (data, context) => {
    util.checkForAdminRole(context);
    let recordDate;
    const currentDate = new Date();
    const datastore = new Datastore();
    try {
        const storeQuery = datastore
            .createQuery("unblock-records")
            .filter("vip", "=", data)
            .order("date", {
                descending: true
            })
            .limit(1);
        const queryResult = await datastore.runQuery(storeQuery);
        const [entities, info] = queryResult;
        if (entities.length) {
            recordDate = entities.pop().date;
        }
    } catch (err) {
        if (err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {err: err.message};
    }
    // check if user is already unblocked
    if (recordDate && recordDate.getFullYear() === currentDate.getFullYear() &&
        recordDate.getMonth() === currentDate.getMonth() &&
        recordDate.getDate() === currentDate.getDate()) {
        throw new functions.https.HttpsError('invalid-argument',
            'Client is already unblocked');
    }
    console.log(context.auth);

    try {

        // create unblock record
        const entityKey = datastore.key("unblock-records");
        return await datastore.insert({
            key: entityKey,
            data: {
                vip: data,
                date: new Date(),
                email: context.auth.token.email
            }
        });
    } catch (err) {
        if (err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {err: err.message};
    }
};
module.exports = unblockClient;
