import React from 'react';
import EnhancedTable from '../EnhancedTable';
import SearchTableRow, {headCells} from './SearchTableRow';
import {TitleIconEnum} from "../../../util/Enums";
import OrderDialog from "../Dialog/OrderDialog";


export default function AnalogTable(props) {
    const [orderDialog, setOrderDialog] = React.useState({
        isOpened: false,
        selected: {}
    });

    const handleCancelOrderClick = () => {
        setOrderDialog({
            isOpened: false, selected: {}
        });
    };

    const handleClick = (event, name) => {
        if (event.target.getAttribute("name") === "order") {
            setOrderDialog({
                isOpened: true,
                selected: props.rows.find(x => x.id === name)
            });
        }
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
                tableRow={SearchTableRow}
                isEur={props.isEur}
                title="Аналоги артикула"
                titleIcon={TitleIconEnum.infinity}
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