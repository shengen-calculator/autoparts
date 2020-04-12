import React from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import EnhancedTable from '../../common/EnhancedTable';
import {TitleIconEnum} from '../../../util/Enums';

const headCells = [
    { id: 'brand', numeric: false, disablePadding: false, label: 'Бренд' },
    { id: 'number', numeric: false, disablePadding: false, label: 'Номер' },
    { id: 'description', numeric: false, disablePadding: false, label: 'Опис' },
    { id: 'retail', numeric: true, disablePadding: false, label: 'Роздріб' },
    { id: 'cost', numeric: true, disablePadding: false, label: 'Ціна' },
    { id: 'available', numeric: true, disablePadding: false, label: 'Доступно' },
    { id: 'reserve', numeric: true, disablePadding: false, label: 'Резерв' }
];

function tableRow(row, index, isSelected, handleClick) {
    const isItemSelected = isSelected(row.name);
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

            <TableCell padding="default" component="th" id={labelId} scope="row">
                {row.brand}
            </TableCell>
            <TableCell align="left">{row.number}</TableCell>
            <TableCell align="left">{row.description}</TableCell>
            <TableCell align="right">{row.retail}</TableCell>
            <TableCell align="right">{row.cost}</TableCell>
            <TableCell align="right">{row.available}</TableCell>
            <TableCell align="right">{row.reserve}</TableCell>
        </TableRow>
    );
}

export default function GeneralTable(props) {
    return(
        <EnhancedTable
            rows={props.rows}
            headCells={headCells}
            tableRow={tableRow}
            title="В наявності на складі"
            titleIcon={TitleIconEnum.check}
            columns={7}
            isFilterShown={false}
            rowsPerPageOptions={[5, 10, 25]}
            isRowSelectorShown={false}
        />
    );
}
