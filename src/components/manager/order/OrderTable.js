import React from 'react';
import TableCell from '@material-ui/core/TableCell';
import TableRow from '@material-ui/core/TableRow';
import Checkbox from '@material-ui/core/Checkbox';
import CallSplitIcon from '@material-ui/icons/CallSplit';
import DoneAllIcon from '@material-ui/icons/DoneAll';
import HourglassEmptyIcon from '@material-ui/icons/HourglassEmpty';
import ClearIcon from '@material-ui/icons/Clear';
import SnoozeIcon from '@material-ui/icons/Snooze';

import EnhancedTable from '../../common/EnhancedTable';
import {TitleIconEnum} from "../../../util/Enums";
import {handleTableClick, handleTableSelectAllClick} from "../../common/EnhancedTableClickHandler";

//status list
//подтвержден = 0
//в обработке = 1
//неполное количество = 2
//задерживается = 3
//нет в наличии = 4

function createData(id, vendor, brand, number, description, note, ordered, approved, euro, uah, orderDate, shipmentDate, status) {
    return {id, vendor, brand, number, description, note, ordered, approved, euro, uah, orderDate, shipmentDate, status };
}

const rows = [
    createData(1, 'IC', 'CTR', 'CRN-73','Свеча зажигания 3330', '', 4, 3,  0.53, 16, '22.02.2020', '26.02.2020', 2),
    createData(2, 'ELIT', 'RENAULT', '401604793R','Свеча зажигания 3330', '', 1, 1,  5.66, 150, '23.02.2020', '27.02.2020', 0),
    createData(3, 'V', 'HUTCHINSON', '590153','Свеча зажигания 3330', '', 2, 2,  5.28, 140, '21.02.2020', '26.02.2020', 0),
    createData(4, 'OMEGA', 'HUTCHINSON', '590153','Свеча зажигания 3330', '', 4, 0,  1.7, 45, '26.02.2020', '28.02.2020', 4),
    createData(5, 'ES', 'AKITAKA', '590153','', '', 3, 3,  17.05, 448.42, '20.02.2020', '26.02.2020', 0),
    createData(6, 'AP-3512', 'PARTS-MALL', 'PKW-015','', '', 2, 2,  1.69, 43.43, '11.02.2020', '', 0),
    createData(7, 'AND', 'NIPPARTS', 'N4961039', '','', 1, 1,  6.75, 173.48, '26.02.2020', '02.03.2020', 0),
    createData(8, '3512', 'NIPPARTS', 'N4961039', 'Свеча зажигания 3330','', 1, 0,  44.94, 1154.96, '18.02.2020', '', 1),
    createData(9, 'VA', 'FEBI', '45414', 'Свеча зажигания FR7DCE 0.8','', 3, 0,  58.75, 1509.88, '24.02.2020', '01.03.2020', 1),
    createData(10, 'ELIT', 'HUTCHINSON', '532E02', 'Свеча зажигания FR7DCE 0.8','', 4, 4,  6.61, 169.88, '22.02.2020', '', 0),
    createData(11, 'ORIG', 'DELPHI', 'TA2913', '(16:00, Сб. до 13:00) BERU 14FR-5DU Свеча зажигания ULTRA','', 2, 0,  33.95, 872.52, '23.02.2020', '', 1),
    createData(12, 'VA', 'RTS', '017-00406', '(16:00, Сб. до 13:00) BERU 14FR-5DU Свеча зажигания ULTRA','', 2, 0,  13.29, 358.83, '27.02.2020', '', 3)
];

const headCells = [
    { id: 'vendor', numeric: false, disablePadding: true, label: 'Пост.' },
    { id: 'brand', numeric: false, disablePadding: false, label: 'Бренд' },
    { id: 'number', numeric: false, disablePadding: false, label: 'Номер' },
    { id: 'description', numeric: false, disablePadding: false, label: 'Опис' },
    { id: 'ordered', numeric: true, disablePadding: false, label: 'Замовлено' },
    { id: 'approved', numeric: true, disablePadding: false, label: 'Підтв' },
    { id: 'euro', numeric: true, disablePadding: false, label: 'Євро' },
    { id: 'uah', numeric: true, disablePadding: false, label: 'Грн' },
    { id: 'note', numeric: false, disablePadding: false, label: 'Примітка' },
    { id: 'orderDate', numeric: false, disablePadding: false, label: 'Замовл.' },
    { id: 'shipmentDate', numeric: false, disablePadding: false, label: 'Доставка' },
    { id: 'status', numeric: false, disablePadding: false, label: 'Статус' },
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
            <TableCell align="right">{row.ordered}</TableCell>
            <TableCell align="right">{row.approved}</TableCell>
            <TableCell align="right">{row.euro}</TableCell>
            <TableCell align="right">{row.uah}</TableCell>
            <TableCell align="left">{row.note}</TableCell>
            <TableCell align="left">{row.orderDate}</TableCell>
            <TableCell align="left">{row.shipmentDate}</TableCell>
            <TableCell align="center">
                {row.status === 0 && <DoneAllIcon/>}
                {row.status === 1 && <HourglassEmptyIcon/>}
                {row.status === 2 && <CallSplitIcon/>}
                {row.status === 3 && <SnoozeIcon/>}
                {row.status === 4 && <ClearIcon/>}
            </TableCell>
        </TableRow>
    );
}

export default function OrderTable() {
    const [selected, setSelected] = React.useState([]);

    const handleClick = (event, name) => {
        handleTableClick(event, name, selected, setSelected);
    };

    const handleSelectAllClick = (event) => {
        handleTableSelectAllClick(event, rows, setSelected);
    };
    return(
        <EnhancedTable
            handleClick={handleClick}
            handleSelectAllClick={handleSelectAllClick}
            selected={selected}
            rows={rows}
            headCells={headCells}
            tableRow={tableRow}
            title="Замовлення"
            titleIcon={TitleIconEnum.flight}
            total={319.26}
            columns={13}
            isFilterShown={false}
            rowsPerPageOptions={[5, 10, 25]}
            isRowSelectorShown={true}
        />
    );
}