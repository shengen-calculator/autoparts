import React from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import EnhancedTable from "../../../common/EnhancedTable";


function createData(id, vendor, quantity) {
    return { id, vendor, quantity };
}

const rows = [
    createData(1,'PLANETA',  6),
    createData(2,'ADS',  4),
    createData(3,'WEST',  4),
    createData(4,'BAS',  3),
    createData(5,'OMEGA',  3),
    createData(6,'VA',  3),
    createData(7,'ES',  3),
    createData(8,'LIDER',  2),
    createData(9,'1707',  2),
    createData(10,'VLAD',  2),
    createData(11,'PITSTOP',  1),
    createData(12,'SZ',  1),
    createData(13,'BUS',  1),
];


const headCells = [
    { id: 'vendor', numeric: false, disablePadding: false, label: 'Постачальник' },
    { id: 'quantity', numeric: true, disablePadding: false, label: 'Кількість' }
];

function tableRow(row, index, isSelected, handleClick) {
    const isItemSelected = isSelected(row.id);
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
                {row.vendor}
            </TableCell>
            <TableCell align="right">{row.quantity}</TableCell>
        </TableRow>
    );
}

export default function MainTable() {
    return(
        <EnhancedTable
            rows={rows}
            headCells={headCells}
            tableRow={tableRow}
            title="Замовлення"
            columns={2}
            isFilterShown={false}
            rowsPerPageOptions={[15, 25, 50]}
            isRowSelectorShown={false}
        />
    );
}