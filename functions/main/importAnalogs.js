const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;
const {Datastore} = require('@google-cloud/datastore');

const importAnalogs = async (data, context) => {

    util.checkForManagerRole(context);

    try {
        const all = [];
        const pool = await sql.connect(config);
        const list = await pool.query`SELECT TRIM(Брэнд) as Brand, TRIM([NAME]) as Number FROM Поисковая WHERE ID_аналога = 3675 GROUP BY Брэнд, [NAME]`;
        const datastore = new Datastore();

        for (let i = 0; i < list.recordset.length; i++) {

            const analogs = await pool.query`SELECT * FROM [Таблица Аналогов] WHERE Брэнд = ${list.recordset[i]['Brand']} AND [Name] = ${list.recordset[i].Number}`;

            for(let j = 0; j < analogs.recordset.length; j++) {
                all.push(analogs.recordset[j]);
            }
        }

        const grouped = all.reduce((accumulator, currentValue) => {
            if(!accumulator.length) {
                accumulator = [];
                accumulator.push(currentValue);
            }
            if(!accumulator.find(x => x.Брэнд === currentValue.Брэнд && x.Name === currentValue.Name && x.Брэнд_ === currentValue.Брэнд_ && x.Name_ === currentValue.Name_ )) {
                accumulator.push(currentValue);
            }

            return accumulator;
        }, {});

        for (let i = 0; i < grouped.length; i++) {
            const analogKey = datastore.key('analogs');
            const entity = {
                key: analogKey,
                data: {
                    name: grouped[i]['Name'].trim(),
                    brand: grouped[i]['Брэнд'].trim(),
                    name_: grouped[i]['Name_'].trim(),
                    brand_: grouped[i]['Брэнд_'].trim()
                },
            };
            await datastore.insert(entity);
            console.log(i);
            console.log(entity);
        }
        console.log("Done");

    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {err: err.message};
    }
};

module.exports = importAnalogs;