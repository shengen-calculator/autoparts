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
        selectedBrands: [],
        selectedVendors: [],
        selectedCities: [],
        selectedTerms: [],
        selectedQualities: [],
        brands: [...new Set(props.rows.map(item => item.brand))].sort(),
        cities: [...new Set(props.rows.map(item => item['warehouseName']))].sort(),
        terms: [...new Set(props.rows.map(item => item['term']))].sort(),
        vendors: [...new Set(props.rows.map(item => item.vendor))].sort(),
        qualities: [...new Set(props.rows.map(item => item.quality))].sort()
    });

    const handleCancelOrderClick = () => {
        setOrderDialog({
            isOpened: false, selected: {}
        });
    };

    const handleFilterApplyClick = (selected) => {
        setFilterDialog({
            ...filterDialog,
            selectedBrands: selected.brands.map(x => x.value),
            selectedCities: selected.cities.map(x => x.value),
            selectedTerms: selected.terms.map(x => x.value),
            selectedVendors: selected.vendors.map(x => x.value),
            selectedQualities: selected.qualities.map(x => x.value)
        });
        props.closeDialog()
    };

    const getFilteredRows = () => {
        let rows = props.rows;
        if(filterDialog.selectedBrands.length > 0) {
            rows = rows.filter(f => filterDialog.selectedBrands.includes(f.brand));
        }
        if(filterDialog.selectedCities.length > 0) {
            rows = rows.filter(f => filterDialog.selectedCities.includes(f['warehouseName']));
        }
        if(filterDialog.selectedTerms.length > 0) {
            rows = rows.filter(f => filterDialog.selectedTerms.includes(f['term']));
        }
        if(filterDialog.selectedQualities.length > 0) {
            rows = rows.filter(f => filterDialog.selectedQualities.includes(f.quality));
        }
        if(filterDialog.selectedVendors.length > 0) {
            rows = rows.filter(f => filterDialog.selectedVendors.includes(f.vendor));
        }
        return rows;
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

    const handleCancelFilterClick = () => {
        props.closeDialog();
    };

    const rowsPerPageOptions = [15, 25, 50];
    if(props.rows.length < rowsPerPageOptions[0]) {
        rowsPerPageOptions.splice(0, 1, props.rows.length)
    }

    return(
        <React.Fragment>
            <EnhancedTable
                rows={getFilteredRows()}
                handleClick={handleClick}
                headCells={headCells}
                role={props.role}
                isPriceShown={props.isPriceShown}
                tableRow={SearchTableRow}
                isEur={props.isEur}
                title={`Аналоги артикула ${props.criteria} під замовлення`}
                columns={10}
                isFilterShown={true}
                handleFilterClick={props.onOpenFilterClick}
                rowsPerPageOptions={rowsPerPageOptions}
                isRowSelectorShown={false}
            />
            <OrderDialog isOpened={orderDialog.isOpened}
                         selected={orderDialog.selected}
                         inOrder={props.inOrder}
                         onClose={handleCancelOrderClick}
            />
            <FilterDialog isOpened={props.isFilterOpened}
                          onOpenFilter={props.onOpenFilterClick}
                          closeDialog={props.closeDialog}
                          vendors={filterDialog.vendors}
                          brands={filterDialog.brands}
                          cities={filterDialog.cities}
                          terms={filterDialog.terms}
                          qualities={filterDialog.qualities}
                          onFilter={handleFilterApplyClick}
                          onClose={handleCancelFilterClick}
                          role={props.role}
            />
        </React.Fragment>

    );
}