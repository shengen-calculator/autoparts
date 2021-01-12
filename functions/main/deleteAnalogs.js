const functions = require('firebase-functions');
const util = require('../util');
const {Datastore} = require('@google-cloud/datastore');

const deleteAnalogs = async (data, context) => {
    util.checkForManagerRole(context);

    try {
        const datastore = new Datastore();
        const analogsKey = datastore.createQuery('analogs').limit(2000);
        const [analogs] = await datastore.runQuery(analogsKey);
        let i = 1;

        for (const a of analogs) {
            const aKey = a[datastore.KEY];
            await datastore.delete(aKey);
            console.log(i);
            i++;
        }

        console.log('Done');

    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {err: err.message};
    }

};




module.exports = deleteAnalogs;