import React from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import EnhancedTable from '../EnhancedTable';
import {RoleEnum, TitleIconEnum} from '../../../util/Enums';
import ReserveDialog from "../Dialog/ReserveDialog";

const headCells = [
    { id: 'vendor', numeric: false, disablePadding: false, label: 'Пост.'},
    { id: 'brand', numeric: false, disablePadding: false, label: 'Бренд' },
    { id: 'number', numeric: false, disablePadding: false, label: 'Номер' },
    { id: 'description', numeric: false, disablePadding: false, label: 'Опис' },
    { id: 'retail', numeric: true, disablePadding: false, label: 'Роздріб' },
    { id: 'cost', numeric: true, disablePadding: false, label: 'Ціна' },
    { id: 'available', numeric: true, disablePadding: false, label: 'Доступно' },
    { id: 'reserve', numeric: true, disablePadding: false, label: 'Резерв' }
];

function tableRow(row, index, isSelected, handleClick, isEur, role) {
    const isItemSelected = isSelected(row.name);
    const labelId = `enhanced-table-checkbox-${index}`;
    const pointer = {cursor: 'pointer'};

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
            {RoleEnum.Manager === role && <TableCell align="left" name="reserve" style={pointer}>{row.vendor}</TableCell>}
            <TableCell name="reserve" padding="default" component="th" id={labelId} scope="row" style={pointer}>
                {row.brand}
            </TableCell>
            <TableCell align="left" name="reserve" style={pointer}>{row.number}</TableCell>
            <TableCell align="left" name="reserve" style={pointer}>{row.description}</TableCell>
            <TableCell align="right" name="price" style={pointer}>{isEur ? row['retailEur'].toFixed(2) : row.retail.toFixed(2)}</TableCell>
            <TableCell align="right" name="price" style={pointer}>{isEur ? row['costEur'].toFixed(2) : row['cost'].toFixed(2)}</TableCell>
            <TableCell align="right" name="reserve" style={pointer}>{row.available}</TableCell>
            <TableCell align="right" name="reserve" style={pointer}>{row.reserve}</TableCell>
        </TableRow>
    );
}

export default function GeneralTable(props) {
    const [reserveDialog, setReserveDialog] = React.useState({
        isOpened: false,
        selected: {}
    });

    const handleClick = (event, name) => {
        if (event.target.getAttribute("name") === "reserve") {
            const selected = props.rows.find(x => x.id === name);
            if(selected.available > 0) {
                setReserveDialog({
                    isOpened: true,
                    selected: props.rows.find(x => x.id === name)
                });
            }
        }
    };
    const handleCancelReserveClick = () => {
        setReserveDialog({
            isOpened: false, selected: {}
        });
    };

    if(RoleEnum.Client === props.role && headCells.length > 7) {
        headCells.splice(0,1);
    }
    return(
        <React.Fragment>
            <EnhancedTable
                rows={props.rows}
                handleClick={handleClick}
                headCells={headCells}
                tableRow={tableRow}
                isEur={props.isEur}
                role={props.role}
                title="В наявності на складі"
                titleIcon={TitleIconEnum.check}
                columns={8}
                isFilterShown={false}
                rowsPerPageOptions={[5, 10, 25]}
                isRowSelectorShown={false}
            />
            <ReserveDialog isOpened={reserveDialog.isOpened}
                         selected={reserveDialog.selected}
                         onClose={handleCancelReserveClick}
            />
        </React.Fragment>

    );
}
