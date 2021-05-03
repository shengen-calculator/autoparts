import React from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import EnhancedTable from '../../EnhancedTable';


const headCells = [
    {id: 'date', numeric: false, disablePadding: false, label: 'Дата'},
    {id: 'description', numeric: false, disablePadding: false, label: 'Опис'},
    {id: 'amount', numeric: true, disablePadding: false, label: 'Сума'},
];

function tableRow(row, index, isSelected) {
    const isItemSelected = isSelected(row.id);
    return (
        <TableRow
            hover
            role="checkbox"
            aria-checked={isItemSelected}
            tabIndex={-1}
            key={row.id}
            selected={isItemSelected}
        >
            <TableCell align="left">{row.date}</TableCell>
            <TableCell align="left">{row.description}</TableCell>
            <TableCell align="right">{row.amount.toFixed(2)}</TableCell>
        </TableRow>
    );
}

export default function PaymentTable(props) {

    return (
        <React.Fragment>

            <EnhancedTable
                rows={props.payments}
                getRowsFunc={props.getPaymentHistory}
                rowLoadingTime={props.rowLoadingTime}
                isMinimalTableHeadUse={true}
                headCells={headCells}
                tableRow={tableRow}
                rowsTotal={props.rowsTotal}
                title="Платежі"
                columns={7}
                isFilterShown={false}
                rowsPerPageOptions={[20, 50, 100]}
                isRowSelectorShown={false}
                noRecordsMessage="Платежі відсутні"
            />

        </React.Fragment>
    );
}