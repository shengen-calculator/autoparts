import React from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import EnhancedTable from '../../EnhancedTable';


const headCells = [
    {id: 'invoiceNumber', numeric: false, disablePadding: false, label: 'Накладна №'},
    {id: 'invoiceDate', numeric: false, disablePadding: false, label: 'Дата'},
    {id: 'brand', numeric: false, disablePadding: false, label: 'Бренд'},
    {id: 'number', numeric: false, disablePadding: false, label: 'Номер'},
    {id: 'description', numeric: false, disablePadding: false, label: 'Опис'},
    {id: 'quantity', numeric: true, disablePadding: false, label: 'К-сть'},
    {id: 'price', numeric: true, disablePadding: false, label: 'Ціна'},
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
            <TableCell align="left">{row.invoiceNumber}</TableCell>
            <TableCell align="left">{row.invoiceDate}</TableCell>
            <TableCell align="left">{row.brand}</TableCell>
            <TableCell align="left">{row.number}</TableCell>
            <TableCell align="left">{row.description}</TableCell>
            <TableCell align="right">{row.quantity}</TableCell>
            <TableCell align="right">{row.price.toFixed(2)}</TableCell>
        </TableRow>
    );
}

export default function SalesTable(props) {

    return (
        <React.Fragment>

            <EnhancedTable
                rows={props.sales}
                getRowsFunc={props.getSaleHistory}
                rowLoadingTime={props.rowLoadingTime}
                headCells={headCells}
                tableRow={tableRow}
                title="Відвантажене"
                columns={7}
                isFilterShown={false}
                rowsPerPageOptions={[5, 10, 25]}
                isRowSelectorShown={false}
                noRecordsMessage="Відвантажені позиції відсутні"
            />

        </React.Fragment>
    );
}