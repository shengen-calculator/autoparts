import React from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import EnhancedTable from "../../../common/EnhancedTable";
import {handleTableClick, handleTableSelectAllClick} from "../../../common/EnhancedTableClickHandler";


function createData(id, vip, requests, succeeded, orders, reserves) {
    return { id, vip, requests, succeeded, orders, reserves };
}

const rows = [
    createData(1,'3825', 554, 439, 0, 0),
    createData(2,'3418', 210, 193, 0, 0),
    createData(3,'3149', 140, 127, 31, 18),
    createData(4,'3853', 111, 100, 1, 6),
    createData(5,'2708', 94, 81, 1, 2),
    createData(6,'2708A', 87, 79, 10, 10),
    createData(7,'3003', 78, 73, 2, 3),
    createData(8,'3147A', 68, 62, 3, 7),
    createData(9,'3749', 67, 63, 3, 9),
    createData(10,'4249', 67, 63, 6, 5),
    createData(11,'3537', 58, 48, 1, 1),
    createData(12,'3198', 54, 43, 6, 0),
    createData(13,'3136', 49, 31, 0, 0),
];

const headCells = [
    { id: 'vip', numeric: false, disablePadding: false, label: 'VIP' },
    { id: 'requests', numeric: true, disablePadding: false, label: 'Запитів' },
    { id: 'succeeded', numeric: true, disablePadding: false, label: 'Успішно' },
    { id: 'orders', numeric: true, disablePadding: false, label: 'Замовлень' },
    { id: 'reserves', numeric: true, disablePadding: false, label: 'Резервів' }

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

            <TableCell padding="default" component="th" id={labelId} scope="row">
                {row.vip}
            </TableCell>
            <TableCell align="right">{row.requests}</TableCell>
            <TableCell align="right">{row.succeeded}</TableCell>
            <TableCell align="right">{row.orders}</TableCell>
            <TableCell align="right">{row.reserves}</TableCell>
        </TableRow>
    );
}

export default function MainTable(props) {
    const [selected, setSelected] = React.useState([]);

    const handleClick = (event, name) => {
        handleTableClick(event, name, selected, setSelected);
    };

    const handleSelectAllClick = (event) => {
        handleTableSelectAllClick(event, rows, setSelected);
    };
    return(
        <EnhancedTable
            handleClick={handleClick}
            handleSelectAllClick={handleSelectAllClick}
            selected={selected}
            rows={rows}
            headCells={headCells}
            tableRow={tableRow}
            title="Запити"
            columns={5}
            isFilterShown={false}
            rowsPerPageOptions={[15, 25, 50]}
            isRowSelectorShown={false}
        />
    );
}