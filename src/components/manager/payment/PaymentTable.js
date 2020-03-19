import EnhancedTable from "../../common/EnhancedTable";
import {TitleIconEnum} from "../../../util/Enums";
import React, {useEffect} from "react";
import TableRow from "@material-ui/core/TableRow";
import TableCell from "@material-ui/core/TableCell";
import {connect} from "react-redux";
import {getPaymentsRequest} from "../../../redux/actions/clientActions";

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

function PaymentTable({client, getPaymentsRequest}) {

    useEffect(() => {
        if(!client.isPaymentsLoaded) {
            getPaymentsRequest(client.vip);
        }
    }, [client.payments, client.isPaymentsLoaded, client.vip, getPaymentsRequest]);

    return(
        <EnhancedTable
            rows={client.payments}
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

function mapStateToProps(state) {
    return {
        client: state.client
    }
}

// noinspection JSUnusedGlobalSymbols
const mapDispatchToProps = {
    getPaymentsRequest
};

export default connect(
    mapStateToProps,
    mapDispatchToProps
)(PaymentTable);