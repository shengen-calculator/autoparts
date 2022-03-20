const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;
const {Datastore} = require('@google-cloud/datastore');
const RoleEnum = require('../RoleEnum');

const searchByNumber = async (data, context) => {

    util.checkForClientRole(context);
    const special = ['@', '#', '_', '&', '-', '+', '(' , ')', '/', '*', '"', "'", ':', ';', '!', '?', '=', '[', ']', '©', '|', '\\', '%', ' ' ];

    if (!data) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with one argument "Number"');
    }

    special.forEach(el => {
        const tokens = data.split(el);
        data = tokens.join('');
    });

    try {
        await sql.connect(config);

        const query = `
                SELECT brand
                    ,number
                    ,shortNumber
                    ,description
                    ,productId
                    ,analogId
                    ,firstBrend
                FROM getPartsByNumber('${data}')
        `;

        const result = await sql.query(query);

        if(context.auth.token.role === RoleEnum.Client) {
            const datastore = new Datastore();
            const queryKey = datastore.key('queries');
            const query = {
                date: new Date(),
                query: data,
                success: result.recordset.length > 0,
                vip: context.auth.token.vip
            };
            const entity = {
                key: queryKey,
                data: query,
            };
            await datastore.insert(entity);
            return  result.recordset.map(obj => ({ ...obj, queryId: entity.key.id }));
        }
        return result.recordset;
    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {err: err.message};
    }
};

module.exports = searchByNumber;