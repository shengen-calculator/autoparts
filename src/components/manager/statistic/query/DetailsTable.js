import React from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';

import EnhancedTable from "../../../common/EnhancedTable";


function createData(id, request, brand, number, available, date) {
    return {id, request, brand, number, available, date};
}

const rows = [
    createData(1, 'G8G008PC', 'BERU', 'G8G008PC', true, '20.02.2020'),
    createData(2, '2112-GEMT', 'BERU', '2112GEMT', true, '20.02.2020'),
    createData(3, '1662', 'BOSCH', '1662', false, '20.02.2020'),
    createData(4, '22140', 'BERU', '22140', true, '20.02.2020'),
    createData(5, '716 010 0016', 'BERU', '7160100016', false, '20.02.2020'),
    createData(6, '301850', 'BOSCH', '301850', false, '20.02.2020'),
    createData(7, 'D4099', 'BERU', 'D4099', true, '20.02.2020'),
    createData(8, 'J42048AYMT', 'NGK', 'J42048AYMT', false, '20.02.2020'),
    createData(9, 'CVT-26', 'BOSCH', 'CVT26', false, '20.02.2020'),
    createData(10, 'GOM-293', 'NGK', 'GOM293', true, '20.02.2020'),
    createData(11, '160101', 'BOSCH', '160101', false, '20.02.2020'),
    createData(12, 'FDB4871', 'NGK', 'FDB4871', true, '20.02.2020'),
    createData(13, '512966', 'NGK', '512966', false, '20.02.2020'),
];

const headCells = [
    {id: 'request', numeric: false, disablePadding: false, label: 'Запит'},
    {id: 'brand', numeric: false, disablePadding: true, label: 'Бренд'},
    {id: 'number', numeric: false, disablePadding: false, label: 'Номер'},
    {id: 'available', numeric: false, disablePadding: false, label: 'Доступно'},
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
                {row.request}
            </TableCell>
            <TableCell align="left">{row.brand}</TableCell>
            <TableCell align="left">{row.number}</TableCell>
            <TableCell align="left">{row.available ? '✓' : ''}</TableCell>
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
            title="Деталізація за клієнтом"
            isFilterShown={false}
            rowsPerPageOptions={[15, 25, 50]}
            isRowSelectorShown={false}
        />
    );
}