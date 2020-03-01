import React from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import EnhancedTable from "../../../common/EnhancedTable";


function createData(id, vip, brand, number, quantity, available, price, date) {
    return {id, vip, brand, number, quantity, available, price, date};
}

const rows = [
    createData(1, '3412', 'G8G008PC', 'BERU', 2, 0, 15.67, '20.02.2020'),
    createData(2, '3149', '2112-GEMT', 'BERU', 1, 0, 1.16, '20.02.2020'),
    createData(3, '3137', '1662', 'BOSCH', 2, 0, 19.14, '20.02.2020'),
    createData(4, '3149', '22140', 'BERU', 3, 0, 5.66, '20.02.2020'),
    createData(5, '3149', '716 010 0016', 'BERU', 1, 3, 3.92, '20.02.2020'),
    createData(6, '4221', '301850', 'BOSCH', 1, 0, 6.14, '20.02.2020'),
    createData(7, '4218', 'D4099', 'BERU', 1, 5, 0.79, '20.02.2020'),
    createData(8, '3749', 'J42048AYMT', 'NGK', 1, 10, 6.27, '20.02.2020'),
    createData(9, '4003', 'CVT-26', 'BOSCH', 1, 0, 2.6, '20.02.2020'),
    createData(10, '1000', 'GOM-293', 'NGK', 1, 0, 2.32, '20.02.2020'),

];

const headCells = [
    {id: 'vip', numeric: false, disablePadding: false, label: 'VIP'},
    {id: 'brand', numeric: false, disablePadding: true, label: 'Бренд'},
    {id: 'number', numeric: false, disablePadding: false, label: 'Номер'},
    {id: 'quantity', numeric: true, disablePadding: false, label: 'Кількість'},
    {id: 'available', numeric: true, disablePadding: false, label: 'Залишок'},
    {id: 'price', numeric: true, disablePadding: false, label: 'Ціна'},
    {id: 'date', numeric: false, disablePadding: false, label: 'Дата'}
];

function tableRow(row, index, isSelected, handleClick) {
    const isItemSelected = isSelected(row.name);
    const labelId = `enhanced-table-checkbox-${index}`;

    return (
        <TableRow
            hover
            onClick={event => handleClick(event, row.id)}
            role="checkbox"
            aria-checked={isItemSelected}
            tabIndex={-1}
            key={row.id}
            selected={isItemSelected}
        >

            <TableCell padding="default" component="th" id={labelId} scope="row">
                {row.vip}
            </TableCell>
            <TableCell align="left">{row.brand}</TableCell>
            <TableCell align="left">{row.number}</TableCell>
            <TableCell align="right">{row.quantity }</TableCell>
            <TableCell align="right">{row.available }</TableCell>
            <TableCell align="right">{row.price }</TableCell>
            <TableCell align="left">{row.date}</TableCell>
        </TableRow>
    );
}

export default function DetailsTable() {
    return(
        <EnhancedTable
            rows={rows}
            headCells={headCells}
            tableRow={tableRow}
            title="Деталізація за постачальником"
            columns={7}
            isFilterShown={false}
            rowsPerPageOptions={[15, 25, 50]}
            isRowSelectorShown={false}
        />
    );
}