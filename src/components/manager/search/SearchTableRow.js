import TableRow from "@material-ui/core/TableRow";
import TableCell from "@material-ui/core/TableCell";
import InfoIcon from "@material-ui/icons/Info";
import React from "react";
import Grid from '@material-ui/core/Grid';
import ThumbUpIcon from '@material-ui/icons/ThumbUp';
import CheckCircleOutlineIcon from '@material-ui/icons/CheckCircleOutline';
import Tooltip from "@material-ui/core/Tooltip";

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
            <TableCell align="left">
                {
                    row.isGoodQuality ?
                    <Grid container>
                        <Grid item>
                            {row.number}
                        </Grid>
                        <Grid item>
                            <Tooltip title="Гарантія відповідності виробнику">
                                <ThumbUpIcon style={{fontSize: 10, marginBottom: 5, marginLeft: 3}}/>
                            </Tooltip>
                        </Grid>
                    </Grid> : row.number
                }
            </TableCell>
            <TableCell align="left">{row.description}</TableCell>
            <TableCell align="right">{row.retail}</TableCell>
            <TableCell align="right">{row.cost}</TableCell>
            <TableCell align="right">{row.order}</TableCell>
            <TableCell align="left">
                {
                    row.isGuaranteedTerm ?
                        <Grid container>
                            <Grid item>
                                {row.term}
                            </Grid>
                            <Grid item>
                                <Tooltip title="Гарантований строк">
                                    <CheckCircleOutlineIcon style={{fontSize: 12, marginBottom: 5, marginLeft: 3}}/>
                                </Tooltip>
                            </Grid>
                        </Grid> : row.term
                }
            </TableCell>
            <TableCell align="left">{row.date}</TableCell>
            <TableCell align="center">
                <InfoIcon/>
            </TableCell>
        </TableRow>
    );
}