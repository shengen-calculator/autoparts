const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;
const {Datastore} = require('@google-cloud/datastore');
const RoleEnum = require('../RoleEnum');

const getProductsTest = async (data, context) => {

    if (data && data.clientId) {
        util.checkForManagerRole(context);
    } else {
        util.checkForClientRole(context);
    }

    if (!data || !data.number || !data.brand) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with at least two arguments "Brand and Number"');
    }
    const start = Date.now();

    try {
        const queries = [];
        const pool = await sql.connect(config);
        const list = await pool.query`SELECT firstBrend
         , shortNumber
         , productId
         , analogId
        FROM getPartsByNumber(${data.number})
        WHERE brand LIKE ${data.brand}`;

        const analogs = await pool.query`SELECT TRIM(Брэнд) as Brand, TRIM([NAME]) as Number 
        FROM Поисковая 
        WHERE ID_аналога = ${list.recordset[0].analogId} 
        GROUP BY Брэнд, [NAME]`;

        const datastore = new Datastore();

        console.log(1, Date.now() - start);

        for(let i = 0; i < analogs.recordset.length; i ++) {
            const query = datastore
                .createQuery('analogs','')
                .filter('brand', '=', analogs.recordset[i].Brand)
                .filter('name', '=', analogs.recordset[i].Number)
                .limit(2000);
            queries.push(datastore.runQuery(query));

        }

        const allRequests = await Promise.all(queries);
        console.log(2, Date.now() - start);
        const analogPositions = [];

        for(let i = 0; i < allRequests.length; i ++) {
            for (const task of allRequests[i][0]) {
                analogPositions.push(task);
            }
        }

        const grouped = analogPositions.reduce((accumulator, currentValue) => {
            if(!accumulator.length) {
                accumulator = [];
                accumulator.push(currentValue);
            }
            if(!accumulator.find(x => x.brand === currentValue.brand && x.name === currentValue.name && x.brand_ === currentValue.brand_ && x.name_ === currentValue.name_ )) {
                accumulator.push(currentValue);
            }

            return accumulator;
        }, {});
        console.log(3, Date.now() - start);

        let sqlQuery = 'SELECT * FROM [Каталоги поставщиков] WHERE';

        for (let i = 0; i < grouped.length; i++) {
            if (i === grouped.length - 1) {
                sqlQuery += ` ([Name] = '${grouped[i].name_}' AND [Брэнд] = '${grouped[i].brand_}')`
            } else {
                sqlQuery += ` ([Name] = '${grouped[i].name_}' AND [Брэнд] = '${grouped[i].brand_}') OR`
            }
        }
        const requests = [
            pool.query(sqlQuery)
        ];
        console.log(4, Date.now() - start);

        if (list.recordset[0].analogId) {
            requests.push(pool.request()
                .input('analogId', sql.Int, list.recordset[0].analogId)
                .execute('sp_web_checkifpresentinorderlistbyanalog'))
        } else {
            requests.push(pool.request()
                .input('number', sql.VarChar(25), data.number)
                .input('brand', sql.VarChar(18), data.brand)
                .execute('sp_web_checkifpresentinorderlist'))
        }

        const [search, inOrder] = await Promise.all(requests);
        console.log(5, Date.now() - start);
        const groupedRes = search.recordset.reduce((accumulator, currentValue) => {
            if(!accumulator.length) {
                accumulator = [];
                accumulator.push(currentValue);
            }
            if(!accumulator.find(x => x.Брэнд === currentValue.Брэнд &&
                x['Номер запчасти'] === currentValue['Номер запчасти'] && x['ID_Поставщика'] === currentValue['ID_Поставщика'])) {
                accumulator.push(currentValue);
            }

            return accumulator;
        }, {});

        const dateTimeFormat = new Intl.DateTimeFormat('en', {year: 'numeric', month: '2-digit', day: '2-digit'});

        return {
            search: {}, //groupedRes,
            inOrder: inOrder.recordset.map(x => {
                const [{ value: month },,{ value: day },,{ value: year }] = dateTimeFormat.formatToParts(x.preliminaryDate);
                return {
                    vip: x.vip,
                    vendor: x.vendor,
                    brand: x.brand,
                    number: x.number,
                    quantity: x.quantity,
                    note: x.note,
                    preliminaryDate: x.preliminaryDate ? `${day}-${month}-${year }` : '',
                    analogId: x.analogId
                }
            }),
            length: groupedRes.length
        };
    } catch (err) {
        if (err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {err: err.message};
    }
};

function getAvailability(data) {
    for (let i = 0; i < data.length; i++) {
        if (data[i].available > 0) {
            return true;
        }
    }
    return false;
}

module.exports = getProductsTest;