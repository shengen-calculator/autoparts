const excel = require('exceljs');
const os = require('os');
const fs = require('fs');
const admin = require('firebase-admin');
const path = require('path');
const configuration = require('../settings');


const getReconciliationXlsLink = async (data, balance, fileName) => {
    const workbook = new excel.Workbook();

    const worksheet = workbook.addWorksheet('sheet1', {
        pageSetup: {paperSize: 15, orientation: 'landscape'}
    });

    worksheet.columns = [
        {header: 'Документ', key: 'invoice', width: 10},
        {header: 'Дата', key: 'date', width: 15},
        {header: 'Бренд', key: 'brand', width: 18},
        {header: 'Номер запчастини', key: 'number', width: 25},
        {header: 'Опис', key: 'description', width: 67},
        {header: 'Ціна', key: 'price', width: 15},
        {header: 'Кількість', key: 'quantity', width: 15},
        {header: 'Сумма', key: 'total', width: 15},
        {header: 'Баланс', key: 'balance', width: 15},
    ];

    paintRow(worksheet, 7, 0);

    worksheet.addRow(new Array(1));
    worksheet.mergeCells('A2:G2');
    worksheet.getCell('A2').value = `Баланс на початок періоду: ${balance}`;

    data.forEach(x => {
        const rowValues = [];
        rowValues[1] = x['invoiceNumber'];
        rowValues[2] = x['invoiceDate'];
        rowValues[3] = x['brand'];
        rowValues[4] = x['number'];
        rowValues[5] = x['description'];
        rowValues[6] = x['priceEur'];
        rowValues[7] = x['quantity'];
        worksheet.addRow(rowValues);
    });

    const resultFilePath = `OutBox/${fileName}`;
    const tempLocalResultFile = path.join(os.tmpdir(), fileName);
    const contentType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    const metadata = {
        contentType: contentType,
        contentDisposition: `attachment; filename="${fileName}"`
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

const paintRow = (worksheet, columnsNumber, row) => {
    const cells = ['A1', 'B1', 'C1', 'D1', 'E1', 'F1', 'G1', 'H1', 'I1', 'J1', 'K1', 'L1', 'M1', 'N1', 'O1', 'P1'];

    cells.slice(row, columnsNumber).forEach(key => {
        worksheet.getCell(key).fill = {
            type: 'pattern',
            pattern: 'solid',
            fgColor: {
                argb: 'E6E6FA'
            }
        };
    });
};

module.exports.getReconciliationXlsLink = getReconciliationXlsLink;