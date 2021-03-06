const functions = require('firebase-functions');
const util = require('../util');
const sql = require('mssql');
const config = require('../mssql.connection').config;
const {Datastore} = require('@google-cloud/datastore');
const RoleEnum = require('../RoleEnum');

const searchByBrandAndNumber = async (data, context) => {

    if (data && data.clientId) {
        util.checkForManagerRole(context);
    } else {
        util.checkForClientRole(context);
    }

    if (!data ||!data.number ||!data.brand) {
        throw new functions.https.HttpsError('invalid-argument',
            'The function must be called with at least two arguments "Brand and Number"');
    }

    try {
        const pool = await sql.connect(config);

        const requests = [
            pool.request()
                .input('number', sql.VarChar(25), data.number)
                .input('brand', sql.VarChar(18), data.brand)
                .input('clientId', sql.Int, data.clientId ? data.clientId : context.auth.token.clientId)
                .input('isVendorShown', sql.Bit, data.clientId ? 1 : 0)
                .input('isPartsFromAllVendorShown', sql.Bit, data.clientId ? 1 : 0)
                .execute('sp_web_getproductsbybrand'),

        ];
        if(data.analogId) {
            requests.push(pool.request()
                .input('analogId', sql.Int, data.analogId)
                .execute('sp_web_checkifpresentinorderlistbyanalog'))
        } else {
            requests.push(pool.request()
                .input('number', sql.VarChar(25), data.number)
                .input('brand', sql.VarChar(18), data.brand)
                .execute('sp_web_checkifpresentinorderlist'))
        }

        const [search, inOrder] = await Promise.all(requests);


        if(context.auth.token.role === RoleEnum.Client && data.queryId) {
            const datastore = new Datastore();

            const queryKey = datastore.key(['queries', Number.parseInt(data.queryId)]);
            const query = {
                date: new Date(),
                brand: data.brand,
                number: data.originalNumber,
                available: getAvailability(search.recordset),
                success: true,
                vip: context.auth.token.vip
            };
            const entity = {
                key: queryKey,
                data: query,
            };
            datastore.update(entity);
        }
        const dateTimeFormat = new Intl.DateTimeFormat('en', { year: 'numeric', month: '2-digit', day: '2-digit' });

        return {
            search: search.recordset,
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
            })
        };
    } catch (err) {
        if(err) {
            throw new functions.https.HttpsError('internal',
                err.message);
        }
        return {err: err.message};
    }
};

function getAvailability(data) {
    for (let i = 0; i < data.length; i++) {
        if(data[i].available > 0) {
            return true;
        }
    }
    return false;
}

module.exports = searchByBrandAndNumber;