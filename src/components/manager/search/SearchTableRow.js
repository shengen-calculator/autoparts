import TableRow from "@material-ui/core/TableRow";
import TableCell from "@material-ui/core/TableCell";
import InfoIcon from "@material-ui/icons/Info";
import React from "react";
import Grid from '@material-ui/core/Grid';
import ThumbUpIcon from '@material-ui/icons/ThumbUp';
import CheckCircleOutlineIcon from '@material-ui/icons/CheckCircleOutline';
import {withStyles} from '@material-ui/core/styles';
import Tooltip from "@material-ui/core/Tooltip";
import Typography from '@material-ui/core/Typography';

export default function SearchTableRow(row, index, isSelected, handleClick, isEur) {
    const isItemSelected = isSelected(row.name);
    const labelId = `enhanced-table-checkbox-${index}`;
    const pointer = {cursor: 'pointer'};
    const bold = {fontWeight: row.term < 1 ? 800 : 500, cursor: 'pointer'};
    const HtmlTooltip = withStyles((theme) => ({
        tooltip: {
            backgroundColor: '#f5f5f9',
            color: 'rgba(0, 0, 0, 0.87)',
            maxWidth: 220,
            fontSize: theme.typography.pxToRem(12),
            border: '1px solid #dadde9',
        },
    }))(Tooltip);

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
            <TableCell align="left" name="order" style={pointer}>{row.vendor}</TableCell>
            <TableCell padding="default" component="th" id={labelId} scope="row" style={pointer} name="order">
                {row.brand}
            </TableCell>
            <TableCell align="left" name="order" style={pointer}>
                {
                    row.isGoodQuality ?
                        <Grid container name="order">
                            <Grid item name="order">
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
            <TableCell align="left" name="order" style={pointer}>{row.description}</TableCell>
            <TableCell align="right" name="price"
                       style={pointer}>{isEur ? row.retailEur.toFixed(2) : row.retail.toFixed(2)}</TableCell>
            <TableCell align="right" name="order"
                       style={pointer}>{isEur ? row.costEur.toFixed(2) : row.cost.toFixed(2)}</TableCell>
            <TableCell align="right" name="order" style={pointer}>{row.order}</TableCell>
            <TableCell align="left" name="order" style={bold} >
                {
                    row.isGuaranteedTerm ?
                        <Grid container name="order">
                            <Grid item name="order">
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
            <TableCell align="center" name="info" style={pointer}>
                <HtmlTooltip placement="top-start" title={
                    <React.Fragment>
                        Час формування замовлення:
                        <Typography color="inherit">{row.orderTime}</Typography>
                        Час прийому товару:
                        <Typography color="inherit">{row.arrivalTime}</Typography>
                        Дата оновлення:
                        <Typography color="inherit">{row.date}</Typography>
                    </React.Fragment>
                }>
                    <InfoIcon/>
                </HtmlTooltip>
            </TableCell>
        </TableRow>
    );
}