import React from 'react';
import EnhancedTable from '../EnhancedTable';
import SearchTableRow, {headCells} from './SearchTableRow';
import OrderDialog from "../Dialog/OrderDialog";
import FilterDialog from "../Dialog/FilterDialog";
import {RoleEnum} from "../../../util/Enums";



export default function AnalogTable(props) {
    const [orderDialog, setOrderDialog] = React.useState({
        isOpened: false,
        selected: {}
    });
    const [filterDialog, setFilterDialog] = React.useState({
        isOpened: false,
        brands: []
    });

    const handleCancelOrderClick = () => {
        setOrderDialog({
            isOpened: false, selected: {}
        });
    };

    const handleClick = (event, name) => {
        if (event.target.getAttribute("name") === "order" ||
            (event.target.getAttribute("name") === "price" && props.role === RoleEnum.Client)) {
            setOrderDialog({
                isOpened: true,
                selected: props.rows.find(x => x.id === name)
            });
        }  else if (event.target.getAttribute("name") === "price" && props.role === RoleEnum.Manager) {
            props.onOpenAnalogDialog(props.rows.find(x => x.id === name));
        }
    };

    const handleFilterClick = () => {

        setFilterDialog({
            isOpened: true,
            brands: [...new Set(props.rows.map(item => item.brand))].sort()
        });
    };
    const handleCancelFilterClick = () => {
        setFilterDialog({
            isOpened: false
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
                title={`Аналоги артикула ${props.criteria} під замовлення`}
                columns={10}
                isFilterShown={true}
                handleFilterClick={handleFilterClick}
                rowsPerPageOptions={rowsPerPageOptions}
                isRowSelectorShown={false}
            />
            <OrderDialog isOpened={orderDialog.isOpened}
                         selected={orderDialog.selected}
                         inOrder={props.inOrder}
                         onClose={handleCancelOrderClick}
            />
            <FilterDialog isOpened={filterDialog.isOpened}
                          brands={filterDialog.brands}
                          onClose={handleCancelFilterClick}
            />
        </React.Fragment>

    );
}