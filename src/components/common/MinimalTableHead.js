import TableHead from "@material-ui/core/TableHead";
import TableRow from "@material-ui/core/TableRow";
import TableCell from '@material-ui/core/TableCell';
import React from "react";
import {withStyles} from "@material-ui/core/styles";

const TableHeaderCell = withStyles(() => ({
    head: {
        fontSize: 16,
        fontWeight: 600
    }
}))(TableCell);

export default function MinimalTableHead(props) {

    const {headCells} = props;
    return (
        <TableHead>
            <TableRow>
                {
                    headCells.map(headCell => {
                        let align = headCell.numeric ? 'right' : 'left';
                        if (headCell.align) {
                            align = headCell.align;
                        }
                        return (
                            <TableHeaderCell
                                key={headCell.id}
                                align={align}
                                padding={headCell.disablePadding ? 'none' : 'default'}>
                                {headCell.label}
                            </TableHeaderCell>
                        )
                    })
                }
            </TableRow>
        </TableHead>
    );
}