import EnhancedTable from "../../common/EnhancedTable";
import {TitleIconEnum} from "../../../util/Enums";
import React from "react";
import TableRow from "@material-ui/core/TableRow";
import TableCell from "@material-ui/core/TableCell";

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
            key={row.date}
            selected={isItemSelected}
        >

            <TableCell padding="default" component="th" id={labelId} scope="row">
                {row.date}
            </TableCell>
            <TableCell align="right">{row.amount}</TableCell>
        </TableRow>
    );
}

function PaymentTable(props) {


    return(
        <EnhancedTable
            rows={props.payments}
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

export default PaymentTable;