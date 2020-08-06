import React from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';

import EnhancedTable from '../../common/EnhancedTable';
import {TitleIconEnum} from "../../../util/Enums";
import {formatCurrency} from "../../../util/Formatter";

//source
// склад = 0
// заказ = 1

const headCells = [
    {id: 'brand', numeric: false, disablePadding: false, label: 'Бренд'},
    {id: 'number', numeric: false, disablePadding: false, label: 'Номер'},
    {id: 'description', numeric: false, disablePadding: false, label: 'Опис'},
    {id: 'quantity', numeric: true, disablePadding: false, label: 'К-сть'},
    {id: 'price', numeric: true, disablePadding: false, label: 'Ціна'},
    {id: 'orderDate', numeric: false, disablePadding: false, label: 'Замовл.'},
    {id: 'date', numeric: false, disablePadding: false, label: 'Дата'},
    {id: 'source', numeric: false, disablePadding: false, label: 'Джерело'},
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
            <TableCell align="left">{row.brand}</TableCell>
            <TableCell align="left">{row.number}</TableCell>
            <TableCell align="left">{row.description}</TableCell>
            <TableCell align="right" name="reserved" >
                {row.quantity}
            </TableCell>
            <TableCell align="right">{row.price.toFixed(2)}</TableCell>
            <TableCell align="left">{row.orderDate}</TableCell>
            <TableCell align="left">{row.date}</TableCell>
            <TableCell align="center">
                {row.source === 1 && <span>Замовне</span>}
            </TableCell>
        </TableRow>
    );
}

export default function ReserveTable(props) {

    const totalEur = formatCurrency(props.reserves.reduce((a, b) => a + b.euro * b.quantity, 0), 'EUR');
    const totalUah = formatCurrency(props.reserves.reduce((a, b) => a + b.uah * b.quantity, 0), 'UAH');
    return (
        <React.Fragment>

            <EnhancedTable
                rows={props.reserves}
                headCells={headCells}
                tableRow={tableRow}
                title="Готове до відвантаження"
                titleIcon={TitleIconEnum.mall}
                columns={12}
                total={props.isEuroClient ? `${totalEur} / ${totalUah}` : `${totalUah} / ${totalEur}`}
                isFilterShown={false}
                rowsPerPageOptions={[5, 10, 25]}
                isRowSelectorShown={false}
                isPaginationDisabled={true}
            />

        </React.Fragment>
    );
}