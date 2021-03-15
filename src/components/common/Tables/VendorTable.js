import React from 'react';
import EnhancedTable from "../EnhancedTable";
import SearchTableRow, {headCells} from './SearchTableRow';
import {RoleEnum, TitleIconEnum} from "../../../util/Enums";
import OrderDialog from "../Dialog/OrderDialog";
import {handleHeadCells} from "../../../util/HeadCellsHandler";


export default function VendorTable(props) {
    const [orderDialog, setOrderDialog] = React.useState({
        isOpened: false,
        selected: {}
    });

    const handleClick = (event, name, el) => {
        if (event.target.getAttribute("name") === "order" ||
            (event.target.getAttribute("name") === "price" && props.role === RoleEnum.Client)) {
            setOrderDialog({
                isOpened: true,
                selected: props.rows.find(x => x.id === name),
                inOrder: props.inOrder
            });
        } else if (event.target.getAttribute("name") === "price" && props.role === RoleEnum.Manager) {
            props.onOpenAnalogDialog(props.rows.find(x => x.id === name));
        } else if (el === "photo") {
            props.onOpenPhotoDialog(props.rows.find(x => x.id === name));
        }
    };

    const handleCancelOrderClick = () => {
        setOrderDialog({
            isOpened: false, selected: {}
        });
    };

    const rowsPerPageOptions = [10, 25, 50];
    if (props.rows.length < rowsPerPageOptions[0]) {
        rowsPerPageOptions.splice(0, 1, props.rows.length)
    }

    handleHeadCells(headCells, props.role, props.isPriceShown);

    return (
        <React.Fragment>
            <EnhancedTable
                rows={props.rows}
                handleClick={handleClick}
                headCells={headCells}
                tableRow={SearchTableRow}
                isEur={props.isEur}
                role={props.role}
                isPriceShown={props.isPriceShown}
                title="Знайдено за артикулом під замовлення"
                titleIcon={TitleIconEnum.track}
                columns={10}
                isFilterShown={false}
                rowsPerPageOptions={rowsPerPageOptions}
                isRowSelectorShown={false}
            />
            <OrderDialog isOpened={orderDialog.isOpened}
                         selected={orderDialog.selected}
                         inOrder={props.inOrder}
                         onClose={handleCancelOrderClick}
            />
        </React.Fragment>
    );
}
