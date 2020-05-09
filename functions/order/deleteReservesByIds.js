const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const deleteReservesByIds = async (data, context) => {

    util.checkForManagerRole(context);

    if (!data) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with argument "array of reserves Ids"');
    }

    try {
        const pool = await sql.connect(config);

        await pool.request()
            .input('ids', sql.VarChar(300), data)
            .execute('sp_web_deletereserves');

    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
    }
};

module.exports = deleteReservesByIds;