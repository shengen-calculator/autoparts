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
    const pointer = {cursor: 'pointer'};

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
            <TableCell padding="default" component="th" id={labelId} scope="row" style={pointer} name="order" onClick={event => handleClick(event, row.id)}>
                {row.brand}
            </TableCell>
            <TableCell align="left" name="order" style={pointer} onClick={event => handleClick(event, row.id)}>
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
            <TableCell align="left" name="order" style={pointer} onClick={event => handleClick(event, row.id)}>{row.description}</TableCell>
            <TableCell align="right" name="price" style={pointer} onClick={event => handleClick(event, row.id)}>{row.retail}</TableCell>
            <TableCell align="right" name="price" style={pointer} onClick={event => handleClick(event, row.id)}>{row.cost}</TableCell>
            <TableCell align="right" name="order" style={pointer} onClick={event => handleClick(event, row.id)}>{row.order}</TableCell>
            <TableCell align="left" name="order" style={pointer} onClick={event => handleClick(event, row.id)}>
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
            <TableCell align="left" name="order" style={pointer} onClick={event => handleClick(event, row.id)}>{row.date}</TableCell>
            <TableCell align="center" style={pointer} onClick={event => handleClick(event, row.id)}>
                <InfoIcon/>
            </TableCell>
        </TableRow>
    );
}