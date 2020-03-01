import React from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import Checkbox from '@material-ui/core/Checkbox';
import LanguageIcon from '@material-ui/icons/Language';

import EnhancedTable from '../../common/EnhancedTable';
import {TitleIconEnum} from "../../../util/Enums";

//source
// склад = 0
// заказ = 1
function createData(id, brand, number, description, note, quantity, vendor, euro, uah, orderDate, date, source) {
    return {id, brand, number, description, quantity, note, vendor, euro, uah, orderDate, date, source };
}

const rows = [
    createData(1, 'CTR', 'CRN-73', '(16:00, Сб. до 13:00) BERU 14FR-5DU Свеча зажигания ULTRA','отгружено', 4, 'С2', 0.53, 16, '11.02.2020','22.02.2020',  0),
    createData(2, 'RENAULT', '401604793R', '(16:00, Сб. до 13:00) BERU 14FR-5DU Свеча зажигания ULTRA','отгружено', 1, 'С2', 5.66, 150, '11.02.2020','23.02.2020',  1),
    createData(3, 'HUTCHINSON', '590153', '(16:00, Сб. до 13:00) BERU 14FR-5DU Свеча зажигания ULTRA', 'отгружено', 2, '', 5.28, 140, '10.02.2020','21.02.2020',  1),
    createData(4, 'HUTCHINSON', '590153', '','', 4, '', 1.7, 45, '11.02.2020','26.02.2020',  0),
    createData(5, 'AKITAKA', '590153', 'Свеча зажигания FR7DCE 0.8','', 3, '', 17.05, 448.42, '11.02.2020','20.02.2020',  1),
    createData(6, 'PARTS-MALL', 'PKW-015', '','', 2, 'IC',  1.69, 43.43, '11.02.2020','11.02.2020',  1),
    createData(7, 'NIPPARTS', 'N4961039', 'Свеча зажигания 3330','internet', 1, '', 6.75, 173.48, '11.02.2020','26.02.2020', 1),
    createData(8, 'NIPPARTS', 'N4961039', 'Свеча зажигания 3330','', 1, '',  44.94, 1154.96, '16.02.2020','18.02.2020',  0),
    createData(9, 'FEBI', '45414', '', 'internet', 3, 'ES',  58.75, 1509.88, '11.02.2020','24.02.2020',  0),
    createData(10, 'HUTCHINSON', '532E02', 'ŚWIECA ZAPŁONOWA PSA/FIAT', '', 4, 'ES', 6.61, 169.88, '15.02.2020','22.02.2020',  1),
    createData(11, 'DELPHI', 'TA2913', 'ŚWIECA ZAPŁONOWA PSA/FIAT','', 2, '',  33.95, 872.52, '19.02.2020','23.02.2020', 0),
    createData(12, 'RTS', '017-00406', '','internet', 2, 'ES',  13.29, 358.83, '18.02.2020','27.02.2020', 0)
];

const headCells = [
    { id: 'vendor', numeric: false, disablePadding: true, label: 'Пост.' },
    { id: 'brand', numeric: false, disablePadding: false, label: 'Бренд' },
    { id: 'number', numeric: false, disablePadding: false, label: 'Номер' },
    { id: 'description', numeric: false, disablePadding: false, label: 'Опис' },
    { id: 'quantity', numeric: true, disablePadding: false, label: 'К-сть' },
    { id: 'euro', numeric: true, disablePadding: false, label: 'Євро' },
    { id: 'uah', numeric: true, disablePadding: false, label: 'Грн' },
    { id: 'note', numeric: false, disablePadding: false, label: 'Примітка' },
    { id: 'orderDate', numeric: false, disablePadding: false, label: 'Замовл.' },
    { id: 'date', numeric: false, disablePadding: false, label: 'Дата' },
    { id: 'source', numeric: false, disablePadding: false, label: 'Джерело' },
];

function tableRow(row, index, isSelected, handleClick) {
    const isItemSelected = isSelected(row.id);
    const labelId = `enhanced-table-checkbox-${index}`;

    return (
        <TableRow
            hover
            onClick={event => handleClick(event, row.id)}
            role="checkbox"
            aria-checked={isItemSelected}
            tabIndex={-1}
            key={row.id}
            selected={isItemSelected}
        >
            <TableCell padding="checkbox">
                <Checkbox
                    checked={isItemSelected}
                    inputProps={{ 'aria-labelledby': labelId }}
                />
            </TableCell>
            <TableCell component="th" id={labelId} scope="row" padding="none">
                {row.vendor}
            </TableCell>
            <TableCell align="left">{row.brand}</TableCell>
            <TableCell align="left">{row.number}</TableCell>
            <TableCell align="left">{row.description}</TableCell>
            <TableCell align="right">{row.quantity}</TableCell>
            <TableCell align="right">{row.euro}</TableCell>
            <TableCell align="right">{row.uah}</TableCell>
            <TableCell align="left">{row.note}</TableCell>
            <TableCell align="left">{row.orderDate}</TableCell>
            <TableCell align="left">{row.date}</TableCell>
            <TableCell align="center">
                {row.source === 1 && <LanguageIcon/>}
            </TableCell>
        </TableRow>
    );
}

export default function ReserveTable() {
    return(
      <EnhancedTable
          rows={rows}
          headCells={headCells}
          tableRow={tableRow}
          title="Виконано"
          titleIcon={TitleIconEnum.mall}
          columns={12}
          total={2349.44}
          isFilterShown={false}
          rowsPerPageOptions={[5, 10, 25]}
          isRowSelectorShown={true}
      />
    );
}