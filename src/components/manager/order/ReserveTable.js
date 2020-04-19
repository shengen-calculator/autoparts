import React from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import Checkbox from '@material-ui/core/Checkbox';
import LanguageIcon from '@material-ui/icons/Language';

import EnhancedTable from '../../common/EnhancedTable';
import {TitleIconEnum} from "../../../util/Enums";
import {handleTableClick, handleTableSelectAllClick} from "../../common/EnhancedTableClickHandler";
import DeleteReservesDialog from "./Dialog/DeleteReservesDialog";
import UpdateReserveQuantityDialog from "./Dialog/UpdateReserveQuantityDialog";
import {formatCurrency} from "../../../util/Formatter";

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
    const pointer = {cursor: 'pointer'};
    return (
        <TableRow
            hover
            role="checkbox"
            aria-checked={isItemSelected}
            tabIndex={-1}
            key={row.id}
            selected={isItemSelected}
        >
            <TableCell padding="checkbox">
                <Checkbox
                    checked={isItemSelected}
                    onClick={event => handleClick(event, row.id)}
                    inputProps={{'aria-labelledby': labelId}}
                />
            </TableCell>
            <TableCell component="th" id={labelId} scope="row" padding="none">
                {row.vendor}
            </TableCell>
            <TableCell align="left">{row.brand}</TableCell>
            <TableCell align="left">{row.number}</TableCell>
            <TableCell align="left">{row.description}</TableCell>
            <TableCell align="right" name="reserved"
                       onClick={event => handleClick(event, row.id)} style={pointer} >
                {row.quantity}
            </TableCell>
            <TableCell align="right">{row.euro.toFixed(2)}</TableCell>
            <TableCell align="right">{row.uah.toFixed(2)}</TableCell>
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
    const [changeQuantityConfirmation, setChangeQuantityConfirmation] = React.useState({
        isOpened: false,
        selected: {}
    });
    const handleCancelDeleteClick = () => {
        setIsDeleteConfirmationOpened(false);
    };
    const handleCancelChangeReserveClick = () => {
        setChangeQuantityConfirmation({
            isOpened: false, selected: {}
        });
    };

    const openDeleteConfirmation = () => {
        setIsDeleteConfirmationOpened(true);
    };

    const handleClick = (event, name) => {
        if(event.target.getAttribute("name") === "reserved") {
            setChangeQuantityConfirmation({
                isOpened: true,
                selected: props.reserves.find(x => x.id === name)
            });
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

    const handleSelectAllClick = (event) => {
        handleTableSelectAllClick(event, props.reserves, setSelected);
    };
    const totalEur = formatCurrency(props.reserves.reduce((a, b) => a + b.euro * b.quantity, 0), 'EUR');
    const totalUah = formatCurrency(props.reserves.reduce((a, b) => a + b.uah * b.quantity, 0), 'UAH');
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
                total={props.isEuroClient ? `${totalEur} / ${totalUah}` : `${totalUah} / ${totalEur}`}
                isFilterShown={false}
                rowsPerPageOptions={[5, 10, 25]}
                isRowSelectorShown={true}
            />
            <DeleteReservesDialog isOpened={isDeleteConfirmationOpened}
                                  onDelete={handleDeleteClick}
                                  onClose={handleCancelDeleteClick}/>

            <UpdateReserveQuantityDialog isOpened={changeQuantityConfirmation.isOpened}
                                         selected={changeQuantityConfirmation.selected}
                                         onClose={handleCancelChangeReserveClick}/>
        </React.Fragment>
    );
}