import React from 'react';
import EnhancedTable from '../../common/EnhancedTable';
import SearchTableRow from './SearchTableRow';
import {TitleIconEnum} from "../../../util/Enums";


function createData(id, brand, number, description, retail, cost, available, reserve, order, term, date) {
    return { id, brand, number, description, retail, cost, available, reserve, order, term, date };
}

const rows = [
    createData(1,'BOSCH', '0 242 245 536', 'Свеча зажигания 3330', 64.53, 41.855,1,1,0,'1дн', '20.02.2020'),
    createData(2,'BOSCH', '0 242 245 536', '(16:00, Сб. до 13:00) BERU 14FR-5DU Свеча зажигания ULTRA', 51.30, 34.95, 5,1,0,'1дн', '20.02.2020' ),
    createData(3,'BOSCH', '0 242 245 536', '(16:00, Сб. до 13:00) BERU 14FR-5DU Свеча зажигания ULTRA', 24.40, 26.10, 5,1,0,'1дн', '20.02.2020'),
    createData(4,'BOSCH', '0 242 245 536', '(Вт/Чт 17:00, Сб. до 13:00) SPARK PLUG (14 FR-5 DU EA 0,8)', 24.99, 34.10, 5,1,0,'1дн', '20.02.2020'),
    createData(5,'BOSCH', '0 242 245 536', '(Вт/Чт 17:00, Сб. до 13:00) SPARK PLUG (14 FR-5 DU EA 0,8)', 49.44, 43.29, 5,1,0,'1дн', '20.02.2020'),
    createData(6,'BOSCH', '0 242 245 536', '(13:00, Сб. до 11:00) ŚWIECA ZAPŁONOWA PSA/FIAT', 87.90, 46.50, 5,1,0,'1дн', '20.02.2020'),
    createData(7,'BOSCH', '0 242 245 536', '(13:00, Сб. до 11:00) ŚWIECA ZAPŁONOWA PSA/FIAT', 37.90, 44.33, 5,1,0,'1дн', '20.02.2020'),
    createData(8,'NGK', 'BCPR7ES', '(13:00, Сб. до 11:00) ŚWIECA ZAPŁONOWA PSA/FIAT', 96.4, 60.10, 5,1,0,'1дн', '20.02.2020'),
    createData(9,'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 65.23, 74.10, 5,1,0,'1дн', '20.02.2020'),
    createData(10,'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 98.11, 50.10, 5,1,0,'1дн', '20.02.2020'),
    createData(11,'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 81.21, 22.10, 5,1,0,'1дн', '20.02.2020'),
    createData(12,'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 99.89, 37.60, 5,1,0,'1дн', '20.02.2020'),
    createData(13,'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 63.01, 54.60, 5,1,0,'1дн', '20.02.2020'),
];

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

export default function AnalogTable() {
    return(
        <EnhancedTable
            rows={rows}
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