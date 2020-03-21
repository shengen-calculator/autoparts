import React from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import EnhancedTable from "../../../common/EnhancedTable";


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

function MainTable(props) {
    return(
        <EnhancedTable
            rows={props.vendorStatistic}
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
export default MainTable;