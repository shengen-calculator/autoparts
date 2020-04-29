const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const deleteOrdersByIds = async (data, context) => {

    util.CheckForManagerRole(context);

    if (!data) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with argument "array of order Ids"');
    }

    try {
        const pool = await sql.connect(config);

        await pool.request()
            .input('ids', sql.VarChar(300), data)
            .execute('sp_web_deleteorders');
    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
    }
};

module.exports = deleteOrdersByIds;