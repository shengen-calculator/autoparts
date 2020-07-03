import React from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import IconButton from "@material-ui/core/IconButton";
import ClearIcon from "@material-ui/icons/Clear";
import EditPriceDialog from "./EditPriceDialog";
import EnhancedTable from "../../../common/EnhancedTable";

const headCells = [
    {id: 'vendor', numeric: false, disablePadding: false, label: 'Пост.'},
    {id: 'brand', numeric: false, disablePadding: false, label: 'Бренд'},
    {id: 'number', numeric: false, disablePadding: false, label: 'Номер'},
    {id: 'price', numeric: true, disablePadding: false, label: 'Onт'},
    {id: 'retail', numeric: true, disablePadding: false, label: 'Роздріб'},
    {id: 'discount', numeric: true, disablePadding: false, label: 'Знижка'},
    {id: 'stock', numeric: true, disablePadding: false, label: 'Залишок'},
    {id: 'reset', numeric: false, disablePadding: false, label: 'Обнулити', align: 'center'}
];

function tableRow(row, index, isSelected, handleClick) {
    const pointer = {cursor: 'pointer'};
    const iconStyle = {padding: 0};
    return (
        <TableRow
            hover
            onClick={event => handleClick(event, row, 'update')}
            key={row.productId}
            style={pointer}
        >
            <TableCell align="left" command="update">{row.vendor}</TableCell>
            <TableCell align="left" command="update">{row.brand}</TableCell>
            <TableCell align="left" command="update">{row.number}</TableCell>
            <TableCell align="right" command="update">{row.price}</TableCell>
            <TableCell align="right" command="update">{row.retail}</TableCell>
            <TableCell align="right" command="update">{row.discount}</TableCell>
            <TableCell align="right" command="update">{row['stock']}</TableCell>
            <TableCell align="center">
                <IconButton onClick={event => handleClick(event, row, 'reset')}
                            style={iconStyle}>
                    <ClearIcon />
                </IconButton>
            </TableCell>
        </TableRow>
    );
}

export default function PriceEditTable(props) {
    const [editPriceDialog, setEditPriceDialog] = React.useState({
        isOpened: false,
        row: {}
    });

    const resetPrice = (id) => {
        alert("clean ->" + id);
    };

    const openSetPriceDialog = (row) => {
        setEditPriceDialog({
            isOpened: true,
            row: row
        });
    };

    const handleClick = (event, row, command) => {
        if (event.target.getAttribute("command") === 'update' && command === 'update') {
            openSetPriceDialog(row);
        } else if(command === 'reset') {
            resetPrice(row.productId);
        }
    };

    const handleCancelEditDialog = () => {
        setEditPriceDialog({
            isOpened: false, row: {}
        });
    };

    return (
        <React.Fragment>
            <EnhancedTable
                rows={props.rows}
                handleClick={handleClick}
                headCells={headCells}
                title="Робота з цінами"
                tableRow={tableRow}
                rowsPerPageOptions={[]}
                isFilterShown={false}
                isRowSelectorShown={false}
                isPaginationDisabled={true}
                isStickyHeader={true}
                maxTableHeight={440}
            />
            <EditPriceDialog isOpened={editPriceDialog.isOpened}
                             row={editPriceDialog.row}
                             onClose={handleCancelEditDialog}/>
        </React.Fragment>

    );
}
