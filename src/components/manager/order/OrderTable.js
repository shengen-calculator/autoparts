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
import {handleTableClick, handleTableSelectAllClick} from "../../common/EnhancedTableClickHandler";
import DeleteOrders from "./Dialog/DeleteOrders";

//status list
//подтвержден = 0
//в обработке = 1
//неполное количество = 2
//задерживается = 3
//нет в наличии = 4

const headCells = [
    { id: 'vendor', numeric: false, disablePadding: true, label: 'Пост.' },
    { id: 'brand', numeric: false, disablePadding: false, label: 'Бренд' },
    { id: 'number', numeric: false, disablePadding: false, label: 'Номер' },
    { id: 'description', numeric: false, disablePadding: false, label: 'Опис' },
    { id: 'ordered', numeric: true, disablePadding: false, label: 'Замовлено' },
    { id: 'approved', numeric: true, disablePadding: false, label: 'Підтв' },
    { id: 'euro', numeric: true, disablePadding: false, label: 'Євро' },
    { id: 'uah', numeric: true, disablePadding: false, label: 'Грн' },
    { id: 'note', numeric: false, disablePadding: false, label: 'Примітка' },
    { id: 'orderDate', numeric: false, disablePadding: false, label: 'Замовл.' },
    { id: 'shipmentDate', numeric: false, disablePadding: false, label: 'Доставка' },
    { id: 'status', numeric: false, disablePadding: false, label: 'Статус' },
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
            <TableCell padding="checkbox">
                <Checkbox
                    checked={isItemSelected}
                    inputProps={{ 'aria-labelledby': labelId }}
                />
            </TableCell>
            <TableCell component="th" id={labelId} scope="row" padding="none">
                {row.vendor}
            </TableCell>
            <TableCell align="left">{row.brand}</TableCell>
            <TableCell align="left">{row.number}</TableCell>
            <TableCell align="left">{row.description}</TableCell>
            <TableCell align="right">{row.ordered}</TableCell>
            <TableCell align="right">{row.approved}</TableCell>
            <TableCell align="right">{row.euro}</TableCell>
            <TableCell align="right">{row.uah}</TableCell>
            <TableCell align="left">{row.note}</TableCell>
            <TableCell align="left">{row.orderDate}</TableCell>
            <TableCell align="left">{row.shipmentDate}</TableCell>
            <TableCell align="center">
                {row.status === 0 && <DoneAllIcon/>}
                {row.status === 1 && <HourglassEmptyIcon/>}
                {row.status === 2 && <CallSplitIcon/>}
                {row.status === 3 && <SnoozeIcon/>}
                {row.status === 4 && <ClearIcon/>}
            </TableCell>
        </TableRow>
    );
}

export default function OrderTable(props) {
    const [selected, setSelected] = React.useState([]);
    const [isDeleteConfirmationOpened, setIsDeleteConfirmationOpened] = React.useState(false);

    const handleClick = (event, name) => {
        handleTableClick(event, name, selected, setSelected);
    };

    const handleDeleteClick = () => {
        props.onDelete(selected);
        setIsDeleteConfirmationOpened(false);
    };
    const handleCancelDeleteClick = () => {
        setIsDeleteConfirmationOpened(false);
    };

    const openDeleteConfirmation = () => {
        setIsDeleteConfirmationOpened(true);
    };

    const handleSelectAllClick = (event) => {
        handleTableSelectAllClick(event, props.orders, setSelected);
    };
    return(
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
                titleIcon={TitleIconEnum.flight}
                total={319.26}
                columns={13}
                isFilterShown={false}
                rowsPerPageOptions={[5, 10, 25]}
                isRowSelectorShown={true}
            />
            <DeleteOrders isOpened={isDeleteConfirmationOpened}
                          onDelete={handleDeleteClick}
                          onClose={handleCancelDeleteClick} />
        </React.Fragment>
    );
}