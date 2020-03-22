import React from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import EnhancedTable from "../../../common/EnhancedTable";

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

export default function DetailsTable(props) {
    return(
        <EnhancedTable
            rows={props.statisticByVendor}
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