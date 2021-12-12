import React from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import Checkbox from '@material-ui/core/Checkbox';
import CallSplitIcon from '@material-ui/icons/CallSplit';
import DoneAllIcon from '@material-ui/icons/DoneAll';
import HourglassEmptyIcon from '@material-ui/icons/HourglassEmpty';
import ClearIcon from '@material-ui/icons/Clear';
import SnoozeIcon from '@material-ui/icons/Snooze';

import EnhancedTable from '../../common/EnhancedTable';
import {TitleIconEnum} from "../../../util/Enums";
import {formatCurrency} from "../../../util/Formatter";
import Tooltip from "@material-ui/core/Tooltip";
import {getOrderRowClass} from "../../common/OrderRowStyle";

//status list
//подтвержден = 0
//в обработке = 1
//неполное количество = 2
//задерживается = 3
//нет в наличии = 4

const headCells = [
    {id: 'brand', numeric: false, disablePadding: false, label: 'Бренд'},
    {id: 'number', numeric: false, disablePadding: false, label: 'Номер'},
    {id: 'description', numeric: false, disablePadding: false, label: 'Опис'},
    {id: 'ordered', numeric: true, disablePadding: false, label: 'Замовлено'},
    {id: 'approved', numeric: true, disablePadding: false, label: 'Підтв'},
    {id: 'price', numeric: true, disablePadding: false, label: 'Ціна'},
    {id: 'orderDate', numeric: false, disablePadding: false, label: 'Замовл.'},
    {id: 'shipmentDate', numeric: false, disablePadding: false, label: 'Очікуємо'},
    {id: 'status', numeric: false, disablePadding: false, label: 'Статус'},
];

function tableRow(row, index, isSelected, handleClick) {
    const isItemSelected = isSelected(row.id);
    const labelId = `enhanced-table-checkbox-${index}`;
    const pointer = {cursor: 'pointer'};


    return (
        <TableRow
            hover
            role="checkbox"
            aria-checked={isItemSelected}
            tabIndex={-1}
            key={row.id}
            style={getOrderRowClass(row)}
            selected={isItemSelected}
        >
            <TableCell align="left">{row.brand}</TableCell>
            <TableCell align="left">{row.number}</TableCell>
            <TableCell align="left">{row.description}</TableCell>
            <TableCell onClick={event => handleClick(event, row.id)}
                       name="ordered" align="right" style={pointer}>
                {row.ordered}
            </TableCell>
            <TableCell align="right">{row.approved}</TableCell>
            <TableCell align="right">{row.price.toFixed(2)}</TableCell>
            <TableCell align="left">{row.orderDate}</TableCell>
            <TableCell align="left">{row.shipmentDate}</TableCell>
            <TableCell align="center">
                {row.status === 0 &&
                <Tooltip title="підтверджений" placement="top">
                    <DoneAllIcon/>
                </Tooltip>}
                {row.status === 1 &&
                <Tooltip title="в обробці" placement="top">
                    <HourglassEmptyIcon/>
                </Tooltip>}
                {row.status === 2 &&
                <Tooltip title="не повна кількість" placement="top">
                    <CallSplitIcon/>
                </Tooltip>}
                {row.status === 3 &&
                <Tooltip title="затримується" placement="top">
                    <SnoozeIcon/>
                </Tooltip>}
                {row.status === 4 &&
                <Tooltip title="не має в наявності" placement="top">
                    <ClearIcon/>
                </Tooltip>}
            </TableCell>
        </TableRow>
    );
}

export default function OrderTable(props) {

    const totalEur = formatCurrency(props.orders.reduce((a, b) => a + b.euro * b.ordered, 0), 'EUR');
    const totalUah = formatCurrency(props.orders.reduce((a, b) => a + b.uah * b.ordered, 0), 'UAH');
    return (
        <React.Fragment>
            <EnhancedTable
                rows={props.orders}
                headCells={headCells}
                tableRow={tableRow}
                title="Замовлення"
                titleIcon={TitleIconEnum.flight}
                total={props.isEuroClient ? `${totalEur} / ${totalUah}` : `${totalUah} / ${totalEur}`}
                columns={12}
                isFilterShown={false}
                rowsPerPageOptions={[5, 10, 25]}
                isRowSelectorShown={false}
                isPaginationDisabled={true}
                noRecordsMessage="Замовлення відсутні"
            />
        </React.Fragment>
    );
}