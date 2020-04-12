import React from 'react';
import EnhancedTable from '../../common/EnhancedTable';
import SearchTableRow from './SearchTableRow';
import {TitleIconEnum} from "../../../util/Enums";

const headCells = [
    { id: 'brand', numeric: false, disablePadding: false, label: 'Бренд' },
    { id: 'number', numeric: false, disablePadding: false, label: 'Номер' },
    { id: 'description', numeric: false, disablePadding: false, label: 'Опис' },
    { id: 'retail', numeric: true, disablePadding: false, label: 'Роздрібна' },
    { id: 'cost', numeric: true, disablePadding: false, label: 'Ціна' },
    { id: 'order', numeric: true, disablePadding: false, label: 'Замовлення' },
    { id: 'term', numeric: false, disablePadding: false, label: 'Термін' },
    { id: 'date', numeric: false, disablePadding: false, label: 'Дата оновл.' },
    { id: 'info', numeric: false, disablePadding: false, label: 'Інфо', align: 'center' }
];

export default function AnalogTable(props) {
    return(
        <EnhancedTable
            rows={props.rows}
            headCells={headCells}
            tableRow={SearchTableRow}
            title="Аналоги артикула"
            titleIcon={TitleIconEnum.infinity}
            columns={9}
            isFilterShown={false}
            rowsPerPageOptions={[15, 25, 50]}
            isRowSelectorShown={false}
        />
    );
}