const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const getAnalogs = async (data, context) => {

    util.checkForManagerRole(context);

    try {
        const pool = await sql.connect(config);

        const result = await pool.request()
            .input('number', sql.VarChar(25), data.number)
            .input('brand', sql.VarChar(18), data.brand)
            .input('analogId', sql.Int, data.analogId)
            .execute('sp_web_getanalogs');
        return result.recordset;
    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {err: err.message};
    }

};

module.exports = getAnalogs;