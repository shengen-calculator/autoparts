import React from 'react';
import EnhancedTable from '../../common/EnhancedTable';
import SearchTableRow from './SearchTableRow';
import {TitleIconEnum} from "../../../util/Enums";
import OrderDialog from "./Dialog/OrderDialog";

const headCells = [
    {id: 'vendor', numeric: false, disablePadding: false, label: 'Пост.'},
    { id: 'brand', numeric: false, disablePadding: false, label: 'Бренд' },
    { id: 'number', numeric: false, disablePadding: false, label: 'Номер' },
    { id: 'description', numeric: false, disablePadding: false, label: 'Опис' },
    { id: 'retail', numeric: true, disablePadding: false, label: 'Роздріб' },
    { id: 'cost', numeric: true, disablePadding: false, label: 'Ціна' },
    { id: 'order', numeric: true, disablePadding: false, label: 'Замовлення' },
    { id: 'term', numeric: false, disablePadding: false, label: 'Термін' },
    { id: 'info', numeric: false, disablePadding: false, label: 'Інфо', align: 'center' }
];

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