import React from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import EnhancedTable from "../../../common/EnhancedTable";
import {handleTableClick, handleTableSelectAllClick} from "../../../common/EnhancedTableClickHandler";


const headCells = [
    { id: 'vendor', numeric: false, disablePadding: false, label: 'Постачальник' },
    { id: 'quantity', numeric: true, disablePadding: false, label: 'Кількість' }
];

function tableRow(row, index, isSelected, handleClick) {
    const isItemSelected = isSelected(row.vendorId);
    const labelId = `enhanced-table-checkbox-${index}`;

    return (
        <TableRow
            hover
            onClick={event => handleClick(event, row.vendorId)}
            role="checkbox"
            aria-checked={isItemSelected}
            tabIndex={-1}
            key={row.vendorId}
            selected={isItemSelected}
        >

            <TableCell padding="default" component="th" id={labelId} scope="row">
                {row.vendor}
            </TableCell>
            <TableCell align="right">{row.quantity}</TableCell>
        </TableRow>
    );
}

function MainTable(props) {
    const [selected, setSelected] = React.useState([]);

    const handleClick = (event, name) => {
       handleTableClick(event, name, selected, setSelected);
    };

    const handleSelectAllClick = (event) => {
        handleTableSelectAllClick(event, props.vendorStatistic, setSelected);
    };

    return(
        <EnhancedTable
            handleClick={handleClick}
            handleSelectAllClick={handleSelectAllClick}
            selected={selected}
            rows={props.vendorStatistic}
            headCells={headCells}
            tableRow={tableRow}
            title="Замовлення"
            columns={2}
            isFilterShown={false}
            rowsPerPageOptions={[15, 25, 50]}
            isRowSelectorShown={false}
        />
    );
}
export default MainTable;