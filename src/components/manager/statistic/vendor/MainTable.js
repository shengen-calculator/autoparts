import React, {useEffect} from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import EnhancedTable from "../../../common/EnhancedTable";
import {useParams} from "react-router-dom";

const headCells = [
    { id: 'vendor', numeric: false, disablePadding: false, label: 'Постачальник' },
    { id: 'quantity', numeric: true, disablePadding: false, label: 'Кількість' }
];

function tableRow(row, index, isSelected, handleClick) {
    const isItemSelected = isSelected(row.vendorId);
    const labelId = `enhanced-table-checkbox-${index}`;
    const pointer = {cursor: 'pointer'};

    return (
        <TableRow
            style={pointer}
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
    const {vendorStatistic, handleClick} = props;
    let {id} = useParams();

    useEffect(() => {
        if(vendorStatistic.length && id) {
            setSelected([parseInt(id)]);
        }
    },[id, vendorStatistic.length]);


    return(
        <EnhancedTable
            handleClick={handleClick}
            selected={selected}
            rows={vendorStatistic}
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