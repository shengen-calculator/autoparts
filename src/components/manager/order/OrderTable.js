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
import {handleTableClick, handleTableSelectAllClick} from "../../common/EnhancedTableClickHandler";
import DeleteOrdersDialog from "./Dialog/DeleteOrdersDialog";
import UpdateOrderQuantityDialog from "./Dialog/UpdateOrderQuantityDialog";
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
    {id: 'vendor', numeric: false, disablePadding: true, label: 'Пост.'},
    {id: 'brand', numeric: false, disablePadding: false, label: 'Бренд'},
    {id: 'number', numeric: false, disablePadding: false, label: 'Номер'},
    {id: 'description', numeric: false, disablePadding: false, label: 'Опис'},
    {id: 'ordered', numeric: true, disablePadding: false, label: 'Замовлено'},
    {id: 'approved', numeric: true, disablePadding: false, label: 'Підтв'},
    {id: 'euro', numeric: true, disablePadding: false, label: 'Євро'},
    {id: 'uah', numeric: true, disablePadding: false, label: 'Грн'},
    {id: 'note', numeric: false, disablePadding: false, label: 'Примітка'},
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
            <TableCell padding="checkbox">
                <Checkbox
                    onClick={event => handleClick(event, row.id)}
                    checked={isItemSelected}
                    inputProps={{'aria-labelledby': labelId}}
                />
            </TableCell>
            <TableCell component="th" id={labelId} scope="row" padding="none">
                {row.vendor}
            </TableCell>
            <TableCell align="left">{row.brand}</TableCell>
            <TableCell align="left">{row.number}</TableCell>
            <TableCell align="left">{row.description}</TableCell>
            <TableCell onClick={event => handleClick(event, row.id)}
                       name="ordered" align="right" style={pointer}>
                {row.ordered}
            </TableCell>
            <TableCell align="right">{row.approved}</TableCell>
            <TableCell align="right">{row.euro.toFixed(2)}</TableCell>
            <TableCell align="right">{row.uah.toFixed(2)}</TableCell>
            <TableCell align="left">{row.note}</TableCell>
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
    const [selected, setSelected] = React.useState([]);
    const [isDeleteConfirmationOpened, setIsDeleteConfirmationOpened] = React.useState(false);
    const [changeQuantityConfirmation, setChangeQuantityConfirmation] = React.useState({
        isOpened: false,
        selected: {}
    });

    const handleClick = (event, name) => {
        if(event.target.getAttribute("name") === "ordered") {
            const selected = props.orders.find(x => x.id === name);
            if(selected.approved === 0) {
                setChangeQuantityConfirmation({
                    isOpened: true,
                    selected: selected
                });
            }
        } else {
            handleTableClick(event, name, selected, setSelected);
        }
    };

    const handleDeleteClick = (event) => {
        event.preventDefault();
        props.onDelete(selected);
        setIsDeleteConfirmationOpened(false);
        setSelected([]);
    };
    const handleCancelDeleteClick = () => {
        setIsDeleteConfirmationOpened(false);
    };
    const handleCancelChangeOrderClick = () => {
        setChangeQuantityConfirmation({
            isOpened: false, selected: {}
        });
    };

    const handleSelectAllClick = (event) => {
        handleTableSelectAllClick(event, props.orders, setSelected);
    };

    const openDeleteConfirmation = () => {
        setIsDeleteConfirmationOpened(true);
    };

    const totalEur = formatCurrency(props.orders.reduce((a, b) => a + b.euro * b.ordered, 0), 'EUR');
    const totalUah = formatCurrency(props.orders.reduce((a, b) => a + b.uah * b.ordered, 0), 'UAH');

    return (
        <React.Fragment>
            <EnhancedTable
                handleClick={handleClick}
                handleSelectAllClick={handleSelectAllClick}
                selected={selected}
                rows={props.orders}
                onDelete={openDeleteConfirmation}
                headCells={headCells}
                tableRow={tableRow}
                title="Замовлення"
                total={props.isEuroClient ? `${totalEur} / ${totalUah}` : `${totalUah} / ${totalEur}`}
                columns={13}
                isFilterShown={false}
                rowsPerPageOptions={[5, 10, 25]}
                isRowSelectorShown={true}
                isPaginationDisabled={true}
                noRecordsMessage="Замовлення відсутні"
            />
            <DeleteOrdersDialog isOpened={isDeleteConfirmationOpened}
                                onDelete={handleDeleteClick}
                                onClose={handleCancelDeleteClick}/>
            <UpdateOrderQuantityDialog isOpened={changeQuantityConfirmation.isOpened}
                                       selected={changeQuantityConfirmation.selected}
                                       onClose={handleCancelChangeOrderClick}/>
        </React.Fragment>
    );
}