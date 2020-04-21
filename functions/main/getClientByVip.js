const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const getClientByVip = async (data, context) => {

    util.CheckForManagerRole(context);

    if (!data) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with one argument "vip"');
    }

    sql.connect(config).then(pool => {
        return pool.request()
            .input('vip', sql.VarChar(10), data)
            .execute('sp_web_getclientbyvip')
    }).then(result => {
        return result.recordset;
    }).catch(err => {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
    });

};

module.exports = getClientByVip;