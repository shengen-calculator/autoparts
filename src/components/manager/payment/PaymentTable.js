import EnhancedTable from "../../common/EnhancedTable";
import {TitleIconEnum} from "../../../util/Enums";
import React from "react";
import TableRow from "@material-ui/core/TableRow";
import TableCell from "@material-ui/core/TableCell";

function createData(id, amount, date) {
    return { id, amount, date };
}

const rows = [
    createData(1,15.76, '28.02.2020'),
    createData(2,9.84, '29.02.2020' ),
    createData(3, 3.45, '01.03.2020'),
    createData(4, 0,'02.03.2020'),
    createData(5, 0, '03.03.2020'),
    createData(6,0, '04.03.2020'),
];

const headCells = [
    { id: 'date', numeric: false, disablePadding: false, label: 'Дата' },
    { id: 'amount', numeric: true, disablePadding: false, label: 'Сума' }
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
                {row.date}
            </TableCell>
            <TableCell align="right">{row.amount}</TableCell>
        </TableRow>
    );
}

export default function PaymentTable() {
    return(
        <EnhancedTable
            rows={rows}
            headCells={headCells}
            tableRow={tableRow}
            title="План платежів"
            titleIcon={TitleIconEnum.payment}
            columns={2}
            isFilterShown={false}
            rowsPerPageOptions={[10, 15, 25]}
            isRowSelectorShown={false}
        />
    );
}