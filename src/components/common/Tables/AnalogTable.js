import React from 'react';
import EnhancedTable from '../EnhancedTable';
import SearchTableRow, {headCells} from './SearchTableRow';
import OrderDialog from "../Dialog/OrderDialog";
import OrderListDialog from "../../manager/order/Dialog/OrderListDialog";


export default function AnalogTable(props) {
    const [orderDialog, setOrderDialog] = React.useState({
        isOpened: false,
        selected: {}
    });

    const [orderListDialog, setOrderListDialog] = React.useState({
        isOpened: false,
        name: 0
    });

    const handleCancelOrderClick = () => {
        setOrderDialog({
            isOpened: false, selected: {}
        });
    };

    const handleCancelOrderListClick = () => {
        setOrderListDialog({
            isOpened: false, name: 0
        });
    };

    const handleClick = (event, name) => {
        if (event.target.getAttribute("name") === "order") {
            if(props.inOrder.length) {
                setOrderListDialog({
                    isOpened: true,
                    name
                });
            } else {
                setOrderDialog({
                    isOpened: true,
                    selected: props.rows.find(x => x.id === name)
                });
            }
        }
    };

    const continueOrder = (name) => {
        setOrderDialog({
            isOpened: true,
            selected: props.rows.find(x => x.id === name)
        });
    };

    const rowsPerPageOptions = [15, 25, 50];
    if(props.rows.length < rowsPerPageOptions[0]) {
        rowsPerPageOptions.splice(0, 1, props.rows.length)
    }

    return(
        <React.Fragment>
            <EnhancedTable
                rows={props.rows}
                handleClick={handleClick}
                headCells={headCells}
                role={props.role}
                isPriceShown={props.isPriceShown}
                tableRow={SearchTableRow}
                isEur={props.isEur}
                title={`Аналоги артикула ${props.criteria}`}
                columns={10}
                isFilterShown={false}
                rowsPerPageOptions={rowsPerPageOptions}
                isRowSelectorShown={false}
            />
            <OrderDialog isOpened={orderDialog.isOpened}
                         selected={orderDialog.selected}
                         onClose={handleCancelOrderClick}
            />
            <OrderListDialog isOpened={orderListDialog.isOpened}
                             name={orderListDialog.name}
                             inOrder={props.inOrder}
                             continueOrder={continueOrder}
                             onClose={handleCancelOrderListClick}
            />
        </React.Fragment>

    );
}