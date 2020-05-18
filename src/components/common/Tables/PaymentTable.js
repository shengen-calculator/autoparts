import EnhancedTable from "../EnhancedTable";
import React from "react";
import TableRow from "@material-ui/core/TableRow";
import TableCell from "@material-ui/core/TableCell";

const headCells = [
    { id: 'date', numeric: false, disablePadding: false, label: 'Дата' },
    { id: 'amount', numeric: true, disablePadding: false, label: 'Сума' }
];

function tableRow(row, index) {
    const labelId = `enhanced-table-checkbox-${index}`;

    return (
        <TableRow
            hover
            role="checkbox"
            tabIndex={-1}
            key={index}
        >

            <TableCell padding="default" component="th" id={labelId} scope="row">
                {row.date}
            </TableCell>
            <TableCell align="right">{row.amount}</TableCell>
        </TableRow>
    );
}

function PaymentTable(props) {
    const payments = [];
    let amount = 0;
    props.payments.forEach(x => {
        payments.push({
            date: x.date,
            amount: x.amount < 0 ? 0 :
                (amount < 0 ? (amount + x.amount < 0 ? 0 : amount + x.amount) : x.amount)
        });
        amount += x.amount;
    });
    return(
        <EnhancedTable
            rows={payments}
            headCells={headCells}
            tableRow={tableRow}
            title={`Загальний борг: ${props.debt}`}
            columns={2}
            isFilterShown={false}
            rowsPerPageOptions={[10, 15, 25]}
            isRowSelectorShown={false}
        />
    );
}

export default PaymentTable;