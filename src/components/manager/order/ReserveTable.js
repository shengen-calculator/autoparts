import React from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import Checkbox from '@material-ui/core/Checkbox';
import LocalShippingIcon from '@material-ui/icons/LocalShipping';

import EnhancedTable from '../../common/EnhancedTable';

//source
// склад = 0
// заказ = 1
function createData(id, brand, number, description, quantity, vendor, euro, uah, date, source) {
    return {id, brand, number, description, quantity, vendor, euro, uah, date, source };
}

const rows = [
    createData(1, 'CTR', 'CRN-73', 'отгружено', 4, 'С2', 0.53, 16, '22.02.2020',  0),
    createData(2, 'RENAULT', '401604793R', 'отгружено', 1, 'С2', 5.66, 150, '23.02.2020',  1),
    createData(3, 'HUTCHINSON', '590153', 'отгружено', 2, '', 5.28, 140, '21.02.2020',  1),
    createData(4, 'HUTCHINSON', '590153', '', 4, '', 1.7, 45, '26.02.2020',  0),
    createData(5, 'AKITAKA', '590153', '', 3, '', 17.05, 448.42, '20.02.2020',  1),
    createData(6, 'PARTS-MALL', 'PKW-015', '', 2, 'IC',  1.69, 43.43, '11.02.2020',  1),
    createData(7, 'NIPPARTS', 'N4961039', 'internet', 1, '', 6.75, 173.48, '26.02.2020', 1),
    createData(8, 'NIPPARTS', 'N4961039', '', 1, '',  44.94, 1154.96, '18.02.2020',  0),
    createData(9, 'FEBI', '45414', 'internet', 3, 'ES',  58.75, 1509.88, '24.02.2020',  0),
    createData(10, 'HUTCHINSON', '532E02', '', 4, 'ES', 6.61, 169.88, '22.02.2020',  1),
    createData(11, 'DELPHI', 'TA2913', '', 2, '',  33.95, 872.52, '23.02.2020', 0),
    createData(12, 'RTS', '017-00406', 'internet', 2, 'ES',  13.29, 358.83, '27.02.2020', 0)
];

const headCells = [
    { id: 'brand', numeric: false, disablePadding: true, label: 'Бренд' },
    { id: 'number', numeric: false, disablePadding: false, label: 'Номер' },
    { id: 'quantity', numeric: true, disablePadding: false, label: 'К-сть' },
    { id: 'euro', numeric: true, disablePadding: false, label: 'Євро' },
    { id: 'uah', numeric: true, disablePadding: false, label: 'Грн' },
    { id: 'vendor', numeric: false, disablePadding: true, label: 'Пост.' },
    { id: 'description', numeric: false, disablePadding: false, label: 'Примітка' },
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
                {row.brand}
            </TableCell>
            <TableCell align="left">{row.number}</TableCell>
            <TableCell align="right">{row.quantity}</TableCell>
            <TableCell align="right">{row.euro}</TableCell>
            <TableCell align="right">{row.uah}</TableCell>
            <TableCell align="left">{row.vendor}</TableCell>
            <TableCell align="left">{row.description}</TableCell>
            <TableCell align="left">{row.date}</TableCell>
            <TableCell align="left">
                {row.source === 1 && <LocalShippingIcon/>}
            </TableCell>
        </TableRow>
    );
}

export default function ReserveTable() {
    return(
      <EnhancedTable rows={rows} headCells={headCells} tableRow={tableRow} title="Виконано" isFilterShown={false}/>
    );
}