import React from 'react';
import EnhancedTable from "../EnhancedTable";
import SearchTableRow, {headCells} from './SearchTableRow';
import {TitleIconEnum} from "../../../util/Enums";
import OrderDialog from "../Dialog/OrderDialog";
import {handleHeadCells} from "../../../util/HeadCellsHandler";


export default function VendorTable(props) {
    const [orderDialog, setOrderDialog] = React.useState({
        isOpened: false,
        selected: {}
    });

    const handleClick = (event, name) => {
        if (event.target.getAttribute("name") === "order") {
            setOrderDialog({
                isOpened: true,
                selected: props.rows.find(x => x.id === name)
            });
        }
    };
    const handleCancelOrderClick = () => {
        setOrderDialog({
            isOpened: false, selected: {}
        });
    };

    const rowsPerPageOptions = [5, 10, 25];
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
                title="Знайдено за артикулом"
                titleIcon={TitleIconEnum.track}
                columns={10}
                isFilterShown={false}
                rowsPerPageOptions={rowsPerPageOptions}
                isRowSelectorShown={false}
            />
            <OrderDialog isOpened={orderDialog.isOpened}
                         selected={orderDialog.selected}
                         onClose={handleCancelOrderClick}
            />
        </React.Fragment>
    );
}
