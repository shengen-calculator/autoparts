import React from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import EnhancedTable from '../EnhancedTable';
import {useHistory} from "react-router-dom";
import {removeSpecialCharacters, htmlEncode} from "../../../util/Search";
import {RoleEnum} from "../../../util/Enums";

const headCells = [
    { id: 'brand', numeric: false, disablePadding: false, label: 'Бренд' },
    { id: 'number', numeric: false, disablePadding: false, label: 'Номер' },
    { id: 'description', numeric: false, disablePadding: false, label: 'Опис' },
];

function tableRow(row, index, isSelected, handleClick) {
    const labelId = `enhanced-table-checkbox-${index}`;
    const pointer = {cursor: 'pointer'};
    return (
        <TableRow
            hover
            role="checkbox"
            tabIndex={-1}
            key={index}
            onClick={event => handleClick(event, {brand: row.brand, number: removeSpecialCharacters(row.number)})}
        >

            <TableCell padding="default" component="th" id={labelId}
                       scope="row" style={pointer}>
                {row.brand}
            </TableCell>
            <TableCell style={pointer} align="left">{row.number}</TableCell>
            <TableCell style={pointer} align="left">{row.description}</TableCell>
        </TableRow>
    );
}

function GroupedTable(props) {
    let history = useHistory();

    const handleClick = (event, {brand, number}) => {
        if(RoleEnum.Manager === props.role || RoleEnum.Admin === props.role) {
            history.push(`/manager/search/${props.vip}/${number}/${htmlEncode(brand)}`)
        } else {
            history.push(`/search/${number}/${htmlEncode(brand)}`)
        }

    };

    return(
        <EnhancedTable
            handleClick={handleClick}
            rows={props.rows}
            headCells={headCells}
            tableRow={tableRow}
            role={props.role}
            columns={7}
            isFilterShown={false}
            rowsPerPageOptions={[25, 50, 100]}
            isRowSelectorShown={false}
        />
    );
}
export default GroupedTable;
