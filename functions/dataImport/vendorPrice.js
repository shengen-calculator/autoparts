const configuration = require('../settings');
const {Datastore} = require('@google-cloud/datastore');
const Log = require('./log');
const DataImport = require('./import');

const vendorPrice = async (req, res) => {

    const token = req.headers['authorization'];
    if(!token || token !== configuration.token) {
        res.status(401).send('Please provide correct credentials');
        return;
    }

    if(req.method === 'POST') {
        if(!req.body.vendor) {
            res.status(400).send('Please provide correct vendor parameter');
            return;
        }
        const log = new Log();
        log.vendor = req.body.vendor;
        const dataImport = new DataImport();
        const rows = dataImport.start(req.body.vendor);
        await log.info(`Successfully imported ${rows} rows`);
        res.status(200).send({rows: rows});
    }

    if(req.method === 'GET') {
        if(!req.query.email || !req.query.file) {
            res.status(400).send('Please provide correct email and file (name) parameters');
            return;
        }

        try {
            const datastore = new Datastore();
            const log = new Log();
            const query = datastore
                .createQuery('import-model','')
                .filter('FileName', '=', req.query.file)
                .filter('From', '=', req.query.email)
                .limit(1);

            const result = await datastore.runQuery(query);

            if(!result[0].length) {
                await log.warning(`Model not found '${req.query.file}' - '${req.query.email}'`);
                res.status(404).send('Model not found');
                return;
            }
            log.vendor = result[0][0]['Vendor'];
            await log.info('Import model requested');
            res.status(200).send(result[0][0]);

        } catch (err) {
            res.status(500);
        }
    }
};

module.exports = vendorPrice;