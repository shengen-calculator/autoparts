const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;

const getCurrencyRate = async (data, context) => {

    util.checkForClientRole(context);

    try {
        await sql.connect(config);
        const query =`
            SELECT TOP (1) Дата, Доллар AS USD, Евро AS EUR 
            FROM dbo.[Внутренний курс валют] 
            ORDER BY Дата DESC
        `;

        const result = await sql.query(query);
        return result.recordset;
    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {err: err.message};
    }
};

module.exports = getCurrencyRate;