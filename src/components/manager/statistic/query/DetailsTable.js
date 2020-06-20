import React from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';

import EnhancedTable from "../../../common/EnhancedTable";

const headCells = [
    {id: 'request', numeric: false, disablePadding: false, label: 'Запит'},
    {id: 'brand', numeric: false, disablePadding: true, label: 'Бренд'},
    {id: 'number', numeric: false, disablePadding: false, label: 'Номер'},
    {id: 'available', numeric: false, disablePadding: false, label: 'Доступно'},
    {id: 'date', numeric: false, disablePadding: false, label: 'Дата'}
];

function tableRow(row, index, isSelected) {
    const isItemSelected = isSelected(row.name);
    const labelId = `enhanced-table-checkbox-${index}`;

    return (
        <TableRow
            hover
            role="checkbox"
            aria-checked={isItemSelected}
            tabIndex={-1}
            key={index}
            selected={isItemSelected}
        >

            <TableCell padding="default" component="th" id={labelId} scope="row">
                {row.query}
            </TableCell>
            <TableCell align="left">{row.brand}</TableCell>
            <TableCell align="left">{row.number}</TableCell>
            <TableCell align="left">{row.available ? '✓' : ''}</TableCell>
            <TableCell align="left">{row.date}</TableCell>
        </TableRow>
    );

}

export default function DetailsTable(props) {
    return(
        <EnhancedTable
            rows={props.statisticByClient}
            headCells={headCells}
            tableRow={tableRow}
            title="Деталізація за клієнтом"
            columns={5}
            isFilterShown={false}
            rowsPerPageOptions={[15, 25, 50]}
            isRowSelectorShown={false}
        />
    );
}