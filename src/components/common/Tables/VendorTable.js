import React from 'react';
import EnhancedTable from "../EnhancedTable";
import SearchTableRow, {headCells} from './SearchTableRow';
import {RoleEnum, TitleIconEnum} from "../../../util/Enums";
import OrderDialog from "../Dialog/OrderDialog";



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

    const isContainVendorField = headCells.some(elem => elem.id === 'vendor');
    if(RoleEnum.Client === props.role  && isContainVendorField) {
        headCells.splice(0,1);
    }

    return (
        <React.Fragment>
            <EnhancedTable
                rows={props.rows}
                handleClick={handleClick}
                headCells={headCells}
                tableRow={SearchTableRow}
                isEur={props.isEur}
                role={props.role}
                title="Знайдено за артикулом"
                titleIcon={TitleIconEnum.track}
                columns={10}
                isFilterShown={false}
                rowsPerPageOptions={[5, 10, 25]}
                isRowSelectorShown={false}
            />
            <OrderDialog isOpened={orderDialog.isOpened}
                         selected={orderDialog.selected}
                         onClose={handleCancelOrderClick}
            />
        </React.Fragment>
    );
}
