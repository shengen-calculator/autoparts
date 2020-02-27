import React from 'react';
import PropTypes from 'prop-types';
import clsx from 'clsx';
import { lighten, makeStyles } from '@material-ui/core/styles';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableContainer from '@material-ui/core/TableContainer';
import TableHead from '@material-ui/core/TableHead';
import TablePagination from '@material-ui/core/TablePagination';
import TableRow from '@material-ui/core/TableRow';
import TableSortLabel from '@material-ui/core/TableSortLabel';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
import Paper from '@material-ui/core/Paper';
import { StyledTableCell } from '../../common/StyledTableCell';
import IconButton from '@material-ui/core/IconButton';
import Tooltip from '@material-ui/core/Tooltip';
import FormControlLabel from '@material-ui/core/FormControlLabel';
import Switch from '@material-ui/core/Switch';
import DeleteIcon from '@material-ui/icons/Delete';
import FilterListIcon from '@material-ui/icons/FilterList';
import InfoIcon from "@material-ui/icons/Info";
import blueGrey from '@material-ui/core/colors/blueGrey';


function createData(id, brand, number, description, retail, cost, available, reserve, order, term, date) {
    return { id, brand, number, description, retail, cost, available, reserve, order, term, date };
}

const rows = [
    createData(1,'BERU', 'Z30', 'Свеча зажигания 3330', 64.53, 41.855,1,1,0,'1дн', '20.02.2020'),
    createData(2,'BERU', 'Z30', '(16:00, Сб. до 13:00) BERU 14FR-5DU Свеча зажигания ULTRA', 51.30, 34.95, 5,1,0,'1дн', '20.02.2020' ),
    createData(3,'BERU', 'Z30', '(16:00, Сб. до 13:00) BERU 14FR-5DU Свеча зажигания ULTRA', 24.40, 26.10, 5,1,0,'1дн', '20.02.2020'),
    createData(4,'BERU', 'Z30', '(Вт/Чт 17:00, Сб. до 13:00) SPARK PLUG (14 FR-5 DU EA 0,8)', 24.99, 34.10, 5,1,0,'1дн', '20.02.2020'),
    createData(5,'BERU', 'Z30', '(Вт/Чт 17:00, Сб. до 13:00) SPARK PLUG (14 FR-5 DU EA 0,8)', 49.44, 43.29, 5,1,0,'1дн', '20.02.2020'),
    createData(6,'BERU', 'Z30', '(13:00, Сб. до 11:00) ŚWIECA ZAPŁONOWA PSA/FIAT', 87.90, 46.50, 5,1,0,'1дн', '20.02.2020'),
    createData(7,'BERU', 'Z30', '(13:00, Сб. до 11:00) ŚWIECA ZAPŁONOWA PSA/FIAT', 37.90, 44.33, 5,1,0,'1дн', '20.02.2020'),
    createData(8,'NGK', 'BCPR7ES', '(13:00, Сб. до 11:00) ŚWIECA ZAPŁONOWA PSA/FIAT', 96.4, 60.10, 5,1,0,'1дн', '20.02.2020'),
    createData(9,'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 65.23, 74.10, 5,1,0,'1дн', '20.02.2020'),
    createData(10,'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 98.11, 50.10, 5,1,0,'1дн', '20.02.2020'),
    createData(11,'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 81.21, 22.10, 5,1,0,'1дн', '20.02.2020'),
    createData(12,'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 99.89, 37.60, 5,1,0,'1дн', '20.02.2020'),
    createData(13,'BOSCH', '0242245536', '(Вт/Чт до 17:30, Сб. до 12:00) Свеча зажигания FR7DCE 0.8', 63.01, 54.60, 5,1,0,'1дн', '20.02.2020'),
];

function descendingComparator(a, b, orderBy) {
    if (b[orderBy] < a[orderBy]) {
        return -1;
    }
    if (b[orderBy] > a[orderBy]) {
        return 1;
    }
    return 0;
}

function getComparator(order, orderBy) {
    return order === 'desc'
        ? (a, b) => descendingComparator(a, b, orderBy)
        : (a, b) => -descendingComparator(a, b, orderBy);
}

function stableSort(array, comparator) {
    const stabilizedThis = array.map((el, index) => [el, index]);
    stabilizedThis.sort((a, b) => {
        const order = comparator(a[0], b[0]);
        if (order !== 0) return order;
        return a[1] - b[1];
    });
    return stabilizedThis.map(el => el[0]);
}
const headCells = [
    { id: 'brand', numeric: false, disablePadding: true, label: 'Бренд' },
    { id: 'number', numeric: false, disablePadding: false, label: 'Номер' },
    { id: 'description', numeric: false, disablePadding: false, label: 'Опис' },
    { id: 'retail', numeric: true, disablePadding: false, label: 'Роздріб' },
    { id: 'cost', numeric: true, disablePadding: false, label: 'Ціна' },
    { id: 'order', numeric: true, disablePadding: false, label: 'Замовлення' },
    { id: 'term', numeric: false, disablePadding: false, label: 'Строк' },
    { id: 'date', numeric: false, disablePadding: false, label: 'Дата оновл.' }
];

function EnhancedTableHead(props) {
    const { classes, onSelectAllClick, order, orderBy, numSelected, rowCount, onRequestSort } = props;
    const createSortHandler = property => event => {
        onRequestSort(event, property);
    };

    return (
        <TableHead>
            <TableRow>
                {headCells.map(headCell => (
                    <StyledTableCell
                        padding="default"
                        key={headCell.id}
                        align={headCell.numeric ? 'right' : 'left'}
                        sortDirection={orderBy === headCell.id ? order : false}
                    >
                        <TableSortLabel
                            active={orderBy === headCell.id}
                            direction={orderBy === headCell.id ? order : 'asc'}
                            onClick={createSortHandler(headCell.id)}
                        >
                            {headCell.label}
                            {orderBy === headCell.id ? (
                                <span className={classes.visuallyHidden}>
                  {order === 'desc' ? 'sorted descending' : 'sorted ascending'}
                </span>
                            ) : null}
                        </TableSortLabel>
                    </StyledTableCell>
                ))}
                <StyledTableCell
                    padding="default"
                    key='info'
                    align='center'
                >Інфо
                </StyledTableCell>
            </TableRow>
        </TableHead>
    );
}

EnhancedTableHead.propTypes = {
    classes: PropTypes.object.isRequired,
    numSelected: PropTypes.number.isRequired,
    onRequestSort: PropTypes.func.isRequired,
    onSelectAllClick: PropTypes.func.isRequired,
    order: PropTypes.oneOf(['asc', 'desc']).isRequired,
    orderBy: PropTypes.string.isRequired,
    rowCount: PropTypes.number.isRequired,
};

const useToolbarStyles = makeStyles(theme => ({
    root: {
        paddingLeft: theme.spacing(2),
        paddingRight: theme.spacing(1),
    },
    highlight:
        theme.palette.type === 'light'
            ? {
                color: theme.palette.secondary.main,
                backgroundColor: lighten(theme.palette.secondary.light, 0.85),
            }
            : {
                color: theme.palette.text.primary,
                backgroundColor: theme.palette.secondary.dark,
            },
    title: {
        flex: '1 1 100%',
        fontWeight: 600,
        color: theme.palette.secondary.main
    },
}));

const EnhancedTableToolbar = props => {
    const classes = useToolbarStyles();
    const { numSelected } = props;

    return (
        <Toolbar
            className={clsx(classes.root, {
                [classes.highlight]: numSelected > 0,
            })}
        >
            {numSelected > 0 ? (
                <Typography className={classes.title} color="inherit" variant="subtitle1">
                    {numSelected} selected
                </Typography>
            ) : (
                <Typography className={classes.title} variant="h6" id="tableTitle">
                    Знайдено за артикулом
                </Typography>
            )}

            {numSelected > 0 ? (
                <Tooltip title="Delete">
                    <IconButton aria-label="delete">
                        <DeleteIcon />
                    </IconButton>
                </Tooltip>
            ) : (
                <Tooltip title="Filter list">
                    <IconButton aria-label="filter list">
                        <FilterListIcon />
                    </IconButton>
                </Tooltip>
            )}
        </Toolbar>
    );
};

EnhancedTableToolbar.propTypes = {
    numSelected: PropTypes.number.isRequired,
};

const useStyles = makeStyles(theme => ({
    root: {
        width: '100%',
    },
    paper: {
        width: '100%',
        marginBottom: theme.spacing(2),
    },
    table: {
        minWidth: 750,
        '& tbody': {backgroundColor: blueGrey[50]}
    },
    visuallyHidden: {
        border: 0,
        clip: 'rect(0 0 0 0)',
        height: 1,
        margin: -1,
        overflow: 'hidden',
        padding: 0,
        position: 'absolute',
        top: 20,
        width: 1,
    },
}));

export default function EnhancedTable() {
    const classes = useStyles();
    const [order, setOrder] = React.useState('asc');
    const [orderBy, setOrderBy] = React.useState('calories');
    const [selected, setSelected] = React.useState([]);
    const [page, setPage] = React.useState(0);
    const [dense, setDense] = React.useState(true);
    const [rowsPerPage, setRowsPerPage] = React.useState(5);

    const handleRequestSort = (event, property) => {
        const isAsc = orderBy === property && order === 'asc';
        setOrder(isAsc ? 'desc' : 'asc');
        setOrderBy(property);
    };

    const handleSelectAllClick = event => {
        if (event.target.checked) {
            const newSelecteds = rows.map(n => n.name);
            setSelected(newSelecteds);
            return;
        }
        setSelected([]);
    };

    const handleClick = (event, name) => {
        const selectedIndex = selected.indexOf(name);
        let newSelected = [];

        if (selectedIndex === -1) {
            newSelected = newSelected.concat(selected, name);
        } else if (selectedIndex === 0) {
            newSelected = newSelected.concat(selected.slice(1));
        } else if (selectedIndex === selected.length - 1) {
            newSelected = newSelected.concat(selected.slice(0, -1));
        } else if (selectedIndex > 0) {
            newSelected = newSelected.concat(
                selected.slice(0, selectedIndex),
                selected.slice(selectedIndex + 1),
            );
        }

        setSelected(newSelected);
    };

    const handleChangePage = (event, newPage) => {
        setPage(newPage);
    };

    const handleChangeRowsPerPage = event => {
        setRowsPerPage(parseInt(event.target.value, 10));
        setPage(0);
    };

    const handleChangeDense = event => {
        setDense(event.target.checked);
    };

    const isSelected = name => selected.indexOf(name) !== -1;

    const emptyRows = rowsPerPage - Math.min(rowsPerPage, rows.length - page * rowsPerPage);

    return (
        <div className={classes.root}>
            <Paper className={classes.paper}>
                <EnhancedTableToolbar numSelected={selected.length} />
                <TableContainer>
                    <Table
                        className={classes.table}
                        aria-labelledby="tableTitle"
                        size={dense ? 'small' : 'medium'}
                        aria-label="enhanced table"
                    >
                        <EnhancedTableHead
                            classes={classes}
                            numSelected={selected.length}
                            order={order}
                            orderBy={orderBy}
                            onSelectAllClick={handleSelectAllClick}
                            onRequestSort={handleRequestSort}
                            rowCount={rows.length}
                        />
                        <TableBody>
                            {stableSort(rows, getComparator(order, orderBy))
                                .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
                                .map((row, index) => {
                                    const isItemSelected = isSelected(row.name);
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

                                            <TableCell padding="default" component="th" id={labelId} scope="row">
                                                {row.brand}
                                            </TableCell>
                                            <TableCell align="left">{row.number}</TableCell>
                                            <TableCell align="left">{row.description}</TableCell>
                                            <TableCell align="right">{row.retail}</TableCell>
                                            <TableCell align="right">{row.cost}</TableCell>
                                            <TableCell align="right">{row.order}</TableCell>
                                            <TableCell align="left">{row.term}</TableCell>
                                            <TableCell align="left">{row.date}</TableCell>
                                            <TableCell align="center">
                                                <InfoIcon/>
                                            </TableCell>
                                        </TableRow>
                                    );
                                })}
                            {emptyRows > 0 && (
                                <TableRow style={{ height: (dense ? 33 : 53) * emptyRows }}>
                                    <TableCell colSpan={9} />
                                </TableRow>
                            )}
                        </TableBody>
                    </Table>
                </TableContainer>
                <TablePagination
                    rowsPerPageOptions={[5, 10, 25]}
                    component="div"
                    count={rows.length}
                    rowsPerPage={rowsPerPage}
                    page={page}
                    onChangePage={handleChangePage}
                    onChangeRowsPerPage={handleChangeRowsPerPage}
                />
            </Paper>
            <FormControlLabel
                control={<Switch checked={dense} onChange={handleChangeDense} />}
                label="Стиснути"
            />
        </div>
    );
}