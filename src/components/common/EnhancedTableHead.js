import React from "react";
import TableHead from "@material-ui/core/TableHead";
import TableRow from "@material-ui/core/TableRow";
import TableSortLabel from "@material-ui/core/TableSortLabel";
import PropTypes from "prop-types";
import Checkbox from "@material-ui/core/Checkbox";
import {withStyles} from "@material-ui/core/styles";
import TableCell from "@material-ui/core/TableCell";

const TableHeaderCell = withStyles(() => ({
    head: {
        fontSize: 16,
        fontWeight: 600
    }
}))(TableCell);


export default function EnhancedTableHead(props) {
    const {
        classes, onSelectAllClick, order, orderBy, numSelected, rowCount,
        onRequestSort, headCells, isRowSelectorShown
    } = props;
    const createSortHandler = property => event => {
        onRequestSort(event, property);
    };

    return (
        <TableHead>
            <TableRow>
                {isRowSelectorShown && <TableHeaderCell padding="checkbox">
                    <Checkbox
                        indeterminate={numSelected > 0 && numSelected < rowCount}
                        checked={rowCount > 0 && numSelected === rowCount}
                        onChange={onSelectAllClick}
                        inputProps={{'aria-label': 'select all desserts'}}
                    />
                </TableHeaderCell>}
                {headCells.map(headCell => {
                        let align = headCell.numeric ? 'right' : 'left';
                        if (headCell.align) {
                            align = headCell.align;
                        }
                        return (
                            <TableHeaderCell
                                key={headCell.id}
                                align={align}
                                padding={headCell.disablePadding ? 'none' : 'default'}
                                sortDirection={orderBy === headCell.id ? order : false}
                            >
                                {align === 'center' ? headCell.label :
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
                                    </TableSortLabel>}
                            </TableHeaderCell>
                        )
                    }
                )}
            </TableRow>
        </TableHead>
    );
}

EnhancedTableHead.propTypes = {
    classes: PropTypes.object.isRequired,
    numSelected: PropTypes.number.isRequired,
    onRequestSort: PropTypes.func.isRequired,
    order: PropTypes.oneOf(['asc', 'desc']).isRequired,
    orderBy: PropTypes.string.isRequired,
    rowCount: PropTypes.number.isRequired,
};