import React from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import Checkbox from '@material-ui/core/Checkbox';
import LanguageIcon from '@material-ui/icons/Language';

import EnhancedTable from '../../common/EnhancedTable';
import {TitleIconEnum} from "../../../util/Enums";
import {handleTableClick, handleTableSelectAllClick} from "../../common/EnhancedTableClickHandler";
import DeleteReserves from "./Dialog/DeleteReserves";

//source
// склад = 0
// заказ = 1

const headCells = [
    {id: 'vendor', numeric: false, disablePadding: true, label: 'Пост.'},
    {id: 'brand', numeric: false, disablePadding: false, label: 'Бренд'},
    {id: 'number', numeric: false, disablePadding: false, label: 'Номер'},
    {id: 'description', numeric: false, disablePadding: false, label: 'Опис'},
    {id: 'quantity', numeric: true, disablePadding: false, label: 'К-сть'},
    {id: 'euro', numeric: true, disablePadding: false, label: 'Євро'},
    {id: 'uah', numeric: true, disablePadding: false, label: 'Грн'},
    {id: 'note', numeric: false, disablePadding: false, label: 'Примітка'},
    {id: 'orderDate', numeric: false, disablePadding: false, label: 'Замовл.'},
    {id: 'date', numeric: false, disablePadding: false, label: 'Дата'},
    {id: 'source', numeric: false, disablePadding: false, label: 'Джерело'},
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
                    inputProps={{'aria-labelledby': labelId}}
                />
            </TableCell>
            <TableCell component="th" id={labelId} scope="row" padding="none">
                {row.vendor}
            </TableCell>
            <TableCell align="left">{row.brand}</TableCell>
            <TableCell align="left">{row.number}</TableCell>
            <TableCell align="left">{row.description}</TableCell>
            <TableCell align="right">{row.quantity}</TableCell>
            <TableCell align="right">{row.euro}</TableCell>
            <TableCell align="right">{row.uah}</TableCell>
            <TableCell align="left">{row.note}</TableCell>
            <TableCell align="left">{row.orderDate}</TableCell>
            <TableCell align="left">{row.date}</TableCell>
            <TableCell align="center">
                {row.source === 1 && <LanguageIcon/>}
            </TableCell>
        </TableRow>
    );
}

export default function ReserveTable(props) {
    const [selected, setSelected] = React.useState([]);
    const [isDeleteConfirmationOpened, setIsDeleteConfirmationOpened] = React.useState(false);

    const handleCancelDeleteClick = () => {
        setIsDeleteConfirmationOpened(false);
    };

    const openDeleteConfirmation = () => {
        setIsDeleteConfirmationOpened(true);
    };

    const handleClick = (event, name) => {
        handleTableClick(event, name, selected, setSelected);
    };

    const handleDeleteClick = () => {
        props.onDelete(selected);
        setIsDeleteConfirmationOpened(false);
    };

    const handleSelectAllClick = (event) => {
        handleTableSelectAllClick(event, props.reserves, setSelected);
    };
    return (
        <React.Fragment>
            <EnhancedTable
                handleClick={handleClick}
                handleSelectAllClick={handleSelectAllClick}
                selected={selected}
                rows={props.reserves}
                onDelete={openDeleteConfirmation}
                headCells={headCells}
                tableRow={tableRow}
                title="Виконано"
                titleIcon={TitleIconEnum.mall}
                columns={12}
                total={2349.44}
                isFilterShown={false}
                rowsPerPageOptions={[5, 10, 25]}
                isRowSelectorShown={true}
            />
            <DeleteReserves isOpened={isDeleteConfirmationOpened}
                            onDelete={handleDeleteClick}
                            onClose={handleCancelDeleteClick}/>
        </React.Fragment>
    );
}