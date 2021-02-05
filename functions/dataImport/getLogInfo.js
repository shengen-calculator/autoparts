const util = require('../util');
const functions = require('firebase-functions');
const {Datastore} = require('@google-cloud/datastore');

const getLogInfo = async (data, context) => {

    util.checkForManagerRole(context);

    try {

        const datastore = new Datastore();
        const limit = data.limit || 25;
        const start = data.start || 0;



    } catch (err) {
        if (err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {error: err.message};
    }
};

module.exports = getLogInfo;