import React from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import EnhancedTable from '../../common/EnhancedTable';
import {TitleIconEnum} from '../../../util/Enums';

function createData(brand, number, description) {
    return { brand, number, description };
}

const headCells = [
    { id: 'brand', numeric: false, disablePadding: false, label: 'Бренд' },
    { id: 'number', numeric: false, disablePadding: false, label: 'Номер' },
    { id: 'description', numeric: false, disablePadding: false, label: 'Опис' },
];

function tableRow(row, index, handleClick) {
    const labelId = `enhanced-table-checkbox-${index}`;

    return (
        <TableRow
            hover
            onClick={event => handleClick(event, row.id)}
            role="checkbox"
            tabIndex={-1}
            key={index}
        >

            <TableCell padding="default" component="th" id={labelId} scope="row">
                {row.brand}
            </TableCell>
            <TableCell align="left">{row.number}</TableCell>
            <TableCell align="left">{row.description}</TableCell>
        </TableRow>
    );
}

function GroupedTable(props) {
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
export default GroupedTable;