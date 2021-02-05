const configuration = require('../settings');
const {Datastore} = require('@google-cloud/datastore');
const Log = require('./log');

const getImportModel = async (req, res) => {

    const token = req.headers['authorization'];
    if(!token || token !== configuration.token) {
        res.status(401).send('Please provide correct credentials');
        return;
    }

    if(!req.body.email || !req.body.fileName) {
        res.status(400).send('Please provide correct email and fileName parameters');
        return;
    }

    try {
        const datastore = new Datastore();
        const log = new Log();
        const query = datastore
            .createQuery('import-model','')
            .filter('FileName', '=', req.body.fileName)
            .filter('From', '=', req.body.email)
            .limit(1);

        const result = await datastore.runQuery(query);

        if(!result[0].length) {
            await log.warning(`Model not found '${req.body.fileName}' - '${req.body.email}'`);
            res.status(404).send('Model not found');
            return;
        }
        log.vendor = result[0][0]['Vendor'];
        await log.info('Import model requested');
        res.status(200).send(result[0][0]);

    } catch (err) {
        res.status(500);
    }
};

module.exports = getImportModel;