const excel = require('exceljs');
const os = require('os');
const fs = require('fs');
const admin = require('firebase-admin');
const path = require('path');
const configuration = require('../settings');


const getReconciliationXlsLink = async (data) => {
    const workbook = new excel.Workbook();
    const worksheet = workbook.addWorksheet('sheet1', {
        pageSetup: {paperSize: 15, orientation: 'landscape'}
    });
    worksheet.columns = [
        {header: 'Номер', key: 'invoice', width: 10},
        {header: 'Дата', key: 'date', width: 5},
        {header: 'Бренд', key: 'brand', width: 18},
        {header: 'Номер запчастини', key: 'number', width: 18},
        {header: 'Опис', key: 'description', width: 52},
        {header: 'Ціна', key: 'price', width: 5},
        {header: 'Кількість', key: 'quantity', width: 2},
    ];
    const rowEValues = [];
    rowEValues[1] = 'Накладна №215';
    rowEValues[2] = '20-02-2020';
    rowEValues[3] = 'Ruvile';
    rowEValues[4] = '5413';
    rowEValues[5] = 'Подшипник ступицы';
    rowEValues[6] = '10.34';
    rowEValues[7] = '3';
    worksheet.addRow(rowEValues);

    const resultFileName = "K0000321.xlsx";
    const resultFilePath = `OutBox/${resultFileName}`;
    const tempLocalResultFile = path.join(os.tmpdir(), resultFileName);
    const contentType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    const metadata = {
        contentType: contentType,
        contentDisposition: `filename="${resultFileName}"`
    };

    await workbook.xlsx.writeFile(tempLocalResultFile);

    await getBucket().upload(tempLocalResultFile, {destination: resultFilePath, metadata: metadata});

    fs.unlinkSync(tempLocalResultFile);

    const config = {
        action: 'read',
        expires: '03-01-2500',
    };
    const resultFile = getBucket().file(resultFilePath);

    return await resultFile.getSignedUrl(config);
};

const getBucket = () => admin.storage().bucket(configuration.bucketId);

module.exports.getReconciliationXlsLink = getReconciliationXlsLink;