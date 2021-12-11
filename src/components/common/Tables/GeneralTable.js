import React from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import EnhancedTable from '../EnhancedTable';
import {RoleEnum, TitleIconEnum} from '../../../util/Enums';
import ReserveDialog from "../Dialog/ReserveDialog";
import lightGreen from '@material-ui/core/colors/lightGreen';
import {withStyles} from '@material-ui/core/styles';
import {handleHeadCells} from "../../../util/HeadCellsHandler";
import PhotoCameraIcon from "@material-ui/icons/PhotoCamera";
import Grid from "@material-ui/core/Grid";
import Tooltip from "@material-ui/core/Tooltip";
import FileCopyIcon from "@material-ui/icons/FileCopy";

const headCells = [
    {id: 'vendor', numeric: false, disablePadding: false, label: 'Пост.'},
    {id: 'brand', numeric: false, disablePadding: false, label: 'Бренд'},
    {id: 'number', numeric: false, disablePadding: false, label: 'Номер'},
    {id: 'description', numeric: false, disablePadding: false, label: 'Опис'},
    {id: 'retail', numeric: true, disablePadding: false, label: 'Роздріб'},
    {id: 'cost', numeric: true, disablePadding: false, label: 'Ціна'},
    {id: 'available', numeric: true, disablePadding: false, label: 'Доступно'},
    {id: 'reserve', numeric: true, disablePadding: false, label: 'Резерв', align: 'left'},
    {id: 'photo', numeric: false, disablePadding: false, label: 'Фото', align: 'center'},
    {id: 'empty', numeric: false, disablePadding: false, label: '', align: 'center'}
];

function tableRow(row, index, isSelected, handleClick, isEur, role, isPriceShown) {
    const isItemSelected = isSelected(row.name);
    const labelId = `enhanced-table-checkbox-${index}`;
    const pointer = {cursor: 'pointer', fontWeight: 700};
    const stockColor = lightGreen['A100'];
    const StyledTableRow = withStyles(() => ({
        root: {
            backgroundColor: stockColor,
        },
    }))(TableRow);

    return (
        <StyledTableRow
            hover
            onClick={event => handleClick(event, row.id)}
            role="checkbox"
            aria-checked={isItemSelected}
            tabIndex={-1}
            key={row.id}
            selected={isItemSelected}

        >
            {RoleEnum.Manager === role &&
            <TableCell width="10%" align="left" name="reserve" style={pointer}>{row.vendor}</TableCell>}
            <TableCell width="10%" name="reserve" padding="default" component="th" id={labelId} scope="row"
                       style={pointer}>
                {row.brand}
            </TableCell>
            <TableCell width="10%" align="left" name="reserve" style={pointer}>
                <Grid container>
                    <Grid item>
                        {row.number}
                    </Grid>
                    <Grid item>
                        <Tooltip title="Скопіювати номер в буфер обміну">
                            <FileCopyIcon onClick={(e) => {handleClick(e, row.id, 'copy')}} style={{fontSize: 13, marginTop: 3, marginLeft: 5}}/>
                        </Tooltip>
                    </Grid>
                </Grid>
            </TableCell>
            <TableCell width="30%" align="left" name="reserve" style={pointer}>{row.description}</TableCell>
            <TableCell width="10%" align="right" name="price"
                       style={pointer}>{isEur ? row['retailEur'].toFixed(2) : row.retail.toFixed(2)}</TableCell>
            {isPriceShown && <TableCell width="10%" align="right" name="price"
                                        style={pointer}>{isEur ? row['costEur'].toFixed(2) : row['cost'].toFixed(2)}</TableCell>}
            <TableCell width="5%" align="center" name="reserve" style={pointer}>{row.available}</TableCell>
            <TableCell width="5%" align="left" name="reserve" style={pointer}>{row.reserve}</TableCell>
            <TableCell width="5%" align="center" >
                <PhotoCameraIcon onClick={(e) => {handleClick(e, row.id, 'photo')}} style={pointer} />
            </TableCell>
            <TableCell width="5%" align="left" name="reserve" style={pointer}/>
        </StyledTableRow>
    );
}

export default function GeneralTable(props) {
    const [reserveDialog, setReserveDialog] = React.useState({
        isOpened: false,
        selected: {}
    });

    const handleClick = (event, name, el) => {
        if (event.target.getAttribute("name") === "reserve" ||
            (event.target.getAttribute("name") === "price" && props.role === RoleEnum.Client)) {
            const selected = props.rows.find(x => x.id === name);
            if (selected.available > 0) {
                setReserveDialog({
                    isOpened: true,
                    selected: props.rows.find(x => x.id === name)
                });
            }
        } else if (event.target.getAttribute("name") === "price" && props.role === RoleEnum.Manager) {
            props.onOpenAnalogDialog(props.rows.find(x => x.id === name));
        } else if (el === "photo") {
            props.onOpenPhotoDialog(props.rows.find(x => x.id === name));
        } else if (el === "copy") {
            props.onCopyToBuffer(props.rows.find(x => x.id === name));
        }
    };
    const handleCancelReserveClick = () => {
        setReserveDialog({
            isOpened: false, selected: {}
        });
    };

    handleHeadCells(headCells, props.role, props.isPriceShown);

    const rowsPerPageOptions = [5, 10, 25];
    if (props.rows.length < rowsPerPageOptions[0]) {
        rowsPerPageOptions.splice(0, 1, props.rows.length)
    }
    return (
        <React.Fragment>
            <EnhancedTable
                rows={props.rows}
                handleClick={handleClick}
                headCells={headCells}
                tableRow={tableRow}
                isEur={props.isEur}
                role={props.role}
                isPriceShown={props.isPriceShown}
                title="В наявності на складі"
                titleIcon={TitleIconEnum.check}
                columns={8}
                isFilterShown={false}
                rowsPerPageOptions={rowsPerPageOptions}
                isRowSelectorShown={false}
                isPaginationDisabled={true}
            />
            <ReserveDialog isOpened={reserveDialog.isOpened}
                           selected={reserveDialog.selected}
                           onClose={handleCancelReserveClick}
            />
        </React.Fragment>

    );
}
