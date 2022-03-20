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

        await sql.connect(config);

        const query = `
                DELETE FROM dbo.[Подчиненная накладные] 
                WHERE ID IN (
                    SELECT Name FROM dbo.SplitString('${data}')
                )
        `;

        await sql.query(query);

    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
    }
};

module.exports = deleteReservesByIds;