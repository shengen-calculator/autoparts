import TableRow from "@material-ui/core/TableRow";
import TableCell from "@material-ui/core/TableCell";
import InfoIcon from "@material-ui/icons/Info";
import PhotoCameraIcon from '@material-ui/icons/PhotoCamera';
import React from "react";
import Grid from '@material-ui/core/Grid';
import FileCopyIcon from '@material-ui/icons/FileCopy';
import ThumbUpIcon from '@material-ui/icons/ThumbUp';
import CheckCircleOutlineIcon from '@material-ui/icons/CheckCircleOutline';
import {withStyles} from '@material-ui/core/styles';
import Tooltip from "@material-ui/core/Tooltip";
import Typography from '@material-ui/core/Typography';
import {RoleEnum} from "../../../util/Enums";
import teal from "@material-ui/core/colors/teal";
import red from "@material-ui/core/colors/red";
import DoubleArrowIcon from "@material-ui/icons/DoubleArrow";

export const headCells = [
    {id: 'vendor', numeric: false, disablePadding: false, label: 'Пост.'},
    {id: 'brand', numeric: false, disablePadding: false, label: 'Бренд'},
    {id: 'number', numeric: false, disablePadding: false, label: 'Номер'},
    {id: 'description', numeric: false, disablePadding: false, label: 'Опис'},
    {id: 'retail', numeric: true, disablePadding: false, label: 'Роздріб'},
    {id: 'cost', numeric: true, disablePadding: false, label: 'Ціна'},
    {id: 'order', numeric: true, disablePadding: false, label: 'Доступно', align: 'center'},
    {id: 'term', numeric: true, disablePadding: false, label: 'Термін', align: 'left'},
    {id: 'photo', numeric: false, disablePadding: false, label: 'Фото', align: 'center'},
    {id: 'info', numeric: false, disablePadding: false, label: 'Інфо', align: 'center'},
];

export default function SearchTableRow(row, index, isSelected, handleClick, isEur, role, isPriceShown) {
    const isItemSelected = isSelected(row.name);
    const labelId = `enhanced-table-checkbox-${index}`;
    const pointer = {cursor: 'pointer'};
    const bold = {fontWeight: row['term'] < 1 ? 800 : 500, cursor: 'pointer'};
    const bolder = {fontWeight: 800 };
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
            style={row['OnlyForManagers'] ? {backgroundColor: red[50]} : (row['term'] === 0 ? {backgroundColor: teal[50]} : {})}
            selected={isItemSelected}
        >
            {(RoleEnum.Manager === role || RoleEnum.Admin === role) &&  <TableCell width="10%" align="left" name="order" style={pointer}>{row.vendor}</TableCell>}
            <TableCell width="10%" padding="default" component="th" id={labelId} scope="row" style={pointer} name="order">
                {
                    row['isGoodQuality'] ?
                        <Grid container name="order">
                            <Grid item name="order">
                                {row.brand}
                            </Grid>
                            <Grid item>
                                <Tooltip title="Гарантія відповідності виробнику">
                                    <ThumbUpIcon style={{fontSize: 10, marginBottom: 5, marginLeft: 3}}/>
                                </Tooltip>
                            </Grid>
                        </Grid> : row.brand

                }
            </TableCell>
            <TableCell width="10%" align="left" name="order" style={pointer}>
                <Grid container name="order">
                    <Grid item name="order">
                        {row.number}
                    </Grid>
                    <Grid item>
                        <Tooltip title="Скопіювати номер в буфер обміну">
                            <FileCopyIcon onClick={(e) => {handleClick(e, row.id, 'copy')}} style={{fontSize: 13, marginTop: 3, marginLeft: 5}}/>
                        </Tooltip>
                        <Tooltip title="Пошук за брендом та номером">
                            <DoubleArrowIcon onClick={(e) => {handleClick(e, row.id, 'forward')}} style={{fontSize: 13, marginTop: 3, marginLeft: 8}}/>
                        </Tooltip>
                    </Grid>
                </Grid>
            </TableCell>
            <TableCell width="30%" align="left" name="order" style={pointer}>{row.description}</TableCell>
            <TableCell width="10%" align="right" name="price"
                       style={pointer}>{isEur ? row['retailEur'].toFixed(2) : row.retail.toFixed(2)}</TableCell>
            {isPriceShown &&  <TableCell width="10%" align="right" name="price"
                       style={pointer}>{isEur ? row['costEur'].toFixed(2) : row['cost'].toFixed(2)}</TableCell>}
            <TableCell width="5%" align="center" name="order" style={pointer}>{row.order}</TableCell>
            <TableCell width="5%" align="left" name="order" style={bold} >
                {
                    row['isGuaranteedTerm'] ?
                        <Grid container name="order">
                            <Grid item name="order">
                                {`${row['term']} дн.`}
                            </Grid>
                            <Grid item>
                                <Tooltip title="Гарантований строк">
                                    <CheckCircleOutlineIcon style={{fontSize: 12, marginBottom: 5, marginLeft: 3}}/>
                                </Tooltip>
                            </Grid>
                        </Grid> : `${row['term']} дн.`
                }
            </TableCell>
            <TableCell width="5%" align="center" >
                <PhotoCameraIcon onClick={(e) => {handleClick(e, row.id, 'photo')}} style={pointer} />
            </TableCell>
            <TableCell width="5%" align="center" name="info" style={pointer}>
                <HtmlTooltip placement="top-start" title={
                    <React.Fragment>
                        {row['supplierName'] && <div>Дистриб'ютор:
                            <Typography color="inherit" style={bolder}>{row['supplierName']}</Typography>
                        </div>}
                        {row['warehouseName'] && <div>Місцезнаходження товару:
                            <Typography color="inherit" style={bolder}>{row['warehouseName']}</Typography>
                        </div>}
                        Час формування замовлення:
                        <Typography color="inherit">{row['orderTime']}</Typography>
                        Час прийому товару у нас:
                        <Typography color="inherit">{row['arrivalTime']}</Typography>
                        Дата оновлення прайсу:
                        <Typography color="inherit">{row.date}</Typography>
                    </React.Fragment>
                }>
                    <InfoIcon/>
                </HtmlTooltip>
            </TableCell>
        </TableRow>
    );
}
