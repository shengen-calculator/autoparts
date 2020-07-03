import {makeStyles} from "@material-ui/core/styles";
import React from "react";
import Paper from "@material-ui/core/Paper";
import TableContainer from "@material-ui/core/TableContainer";
import Table from "@material-ui/core/Table";
import TableBody from "@material-ui/core/TableBody";
import TableRow from "@material-ui/core/TableRow";
import TableCell from "@material-ui/core/TableCell";
import TablePagination from "@material-ui/core/TablePagination";

import EnhancedTableHead from "./EnhancedTableHead";
import {EnhancedTableToolbar} from "./EnhancedTableToolbar";
import StableSort from "../../util/StableSort";
import GetComparator from "../../util/GetComparator";
import Typography from "@material-ui/core/Typography";

const useStyles = makeStyles(theme => ({
    root: {
        width: '100%',
    },
    paper: {
        width: '100%',
        marginBottom: theme.spacing(2),
        paddingBottom: theme.spacing(4)
    },
    table: {
        minWidth: 350,
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

export default function EnhancedTable(props) {

    const {
        tableRow,
        rows,
        headCells,
        title,
        titleIcon,
        total,
        columns,
        isEur,
        role,
        isPriceShown,
        isFilterShown,
        isPaginationDisabled,
        rowsPerPageOptions,
        handleClick,
        handleSelectAllClick,
        selected = [],
        onDelete,
        isRowSelectorShown,
        isStickyHeader,
        maxTableHeight
    } = props;

    const classes = useStyles();
    const [order, setOrder] = React.useState('asc');
    const [orderBy, setOrderBy] = React.useState('status');
    const [page, setPage] = React.useState(0);
    const [rowsPerPage, setRowsPerPage] = React.useState(rowsPerPageOptions[0]);
    const handleRequestSort = (event, property) => {
        const isAsc = orderBy === property && order === 'asc';
        setOrder(isAsc ? 'desc' : 'asc');
        setOrderBy(property);
    };

    const handleChangePage = (event, newPage) => {
        setPage(newPage);
    };

    const handleChangeRowsPerPage = event => {
        setRowsPerPage(parseInt(event.target.value, 10));
        setPage(0);
    };

    const isSelected = name => selected.indexOf(name) !== -1;

    const emptyRows = isPaginationDisabled ? 0 :
        rowsPerPage - Math.min(Number(rowsPerPage), rows.length - page * rowsPerPage);

    return (
        <div className={classes.root}>
            <Paper className={classes.paper}>
                <EnhancedTableToolbar
                    numSelected={selected.length}
                    title={title}
                    onDelete={onDelete}
                    titleIcon={titleIcon}
                    total={total}
                    isFilterShown={isFilterShown}
                    isRowSelectorShown={isRowSelectorShown}
                />
                {rows.length > 0 ?
                    <TableContainer style={{maxHeight: maxTableHeight}}>
                        <Table
                            className={classes.table}
                            aria-labelledby="tableTitle"
                            size='small'
                            aria-label="enhanced table"
                            stickyHeader={isStickyHeader}
                        >
                            <EnhancedTableHead
                                classes={classes}
                                numSelected={selected.length}
                                order={order}
                                orderBy={orderBy}
                                onSelectAllClick={handleSelectAllClick}
                                onRequestSort={handleRequestSort}
                                rowCount={rows.length}
                                headCells={headCells}
                                isRowSelectorShown={isRowSelectorShown}
                            />
                            <TableBody>
                                {isPaginationDisabled ? StableSort(rows, GetComparator(order, orderBy))
                                    .map((row, index) => {
                                        return tableRow(row, index, isSelected, handleClick, isEur, role, isPriceShown)
                                    }) : StableSort(rows, GetComparator(order, orderBy))
                                    .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
                                    .map((row, index) => {
                                        return tableRow(row, index, isSelected, handleClick, isEur, role, isPriceShown)
                                    })
                                }
                                {emptyRows > 0 && (
                                    <TableRow style={{height: 33 * emptyRows}}>
                                        <TableCell colSpan={columns}/>
                                    </TableRow>
                                )}
                            </TableBody>
                        </Table>
                    </TableContainer> :
                    <Typography color="textSecondary" align="center">
                        Інформація відсутня
                    </Typography>
                }
                {!isPaginationDisabled && <TablePagination
                    rowsPerPageOptions={rowsPerPageOptions}
                    component="div"
                    count={rows.length}
                    rowsPerPage={rowsPerPage}
                    page={page}
                    onChangePage={handleChangePage}
                    onChangeRowsPerPage={handleChangeRowsPerPage}
                />}
            </Paper>
        </div>
    );
}