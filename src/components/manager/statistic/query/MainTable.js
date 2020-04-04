import React, {useEffect} from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import EnhancedTable from "../../../common/EnhancedTable";
import {useParams} from "react-router-dom";

const headCells = [
    { id: 'vip', numeric: false, disablePadding: false, label: 'VIP' },
    { id: 'requests', numeric: true, disablePadding: false, label: 'Запитів' },
    { id: 'succeeded', numeric: true, disablePadding: false, label: 'Успішно' },
    { id: 'orders', numeric: true, disablePadding: false, label: 'Замовлень' },
    { id: 'reserves', numeric: true, disablePadding: false, label: 'Резервів' }

];

function tableRow(row, index, isSelected, handleClick) {
    const isItemSelected = isSelected(row.vip);
    const labelId = `enhanced-table-checkbox-${index}`;
    const pointer = {cursor: 'pointer'};

    return (
        <TableRow
            style={pointer}
            hover
            onClick={event => handleClick(event, row.vip)}
            role="checkbox"
            aria-checked={isItemSelected}
            tabIndex={-1}
            key={row.vip}
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

function MainTable(props) {
    const [selected, setSelected] = React.useState([]);
    const {clientStatistic, handleClick} = props;
    let {vip} = useParams();

    useEffect(() => {
        if(clientStatistic.length && vip) {
            setSelected(vip);
        }
    },[vip, clientStatistic.length]);

    return(
        <EnhancedTable
            handleClick={handleClick}
            selected={selected}
            rows={clientStatistic}
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
export default MainTable;
