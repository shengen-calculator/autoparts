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
                rowsPerPageOptions={[15, 25, 50]}
                isRowSelectorShown={false}
            />
            <OrderDialog isOpened={orderDialog.isOpened}
                         selected={orderDialog.selected}
                         onClose={handleCancelOrderClick}
            />
        </React.Fragment>

    );
}