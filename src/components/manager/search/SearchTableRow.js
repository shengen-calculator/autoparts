import TableRow from "@material-ui/core/TableRow";
import TableCell from "@material-ui/core/TableCell";
import InfoIcon from "@material-ui/icons/Info";
import React from "react";

export default function SearchTableRow(row, index, isSelected, handleClick) {
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
}