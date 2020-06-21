import {lighten, makeStyles} from "@material-ui/core/styles";
import Toolbar from "@material-ui/core/Toolbar";
import clsx from "clsx";
import Typography from "@material-ui/core/Typography";
import Tooltip from "@material-ui/core/Tooltip";
import IconButton from "@material-ui/core/IconButton";
import DeleteIcon from "@material-ui/icons/Delete";
import FilterListIcon from "@material-ui/icons/FilterList";
import PropTypes from "prop-types";
import React from "react";
import {TitleIconEnum} from '../../util/Enums';
import DoneOutlineIcon from '@material-ui/icons/DoneOutline';
import AllInclusiveIcon from '@material-ui/icons/AllInclusive';
import LocalShippingIcon from '@material-ui/icons/LocalShipping';
import CreditCardIcon from '@material-ui/icons/CreditCard';
import LocalMallIcon from '@material-ui/icons/LocalMall';
import DirectionsRailwayIcon from '@material-ui/icons/DirectionsRailway';
import Grid from "@material-ui/core/Grid";

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
    total: {
        flex: '1 1 100%',
        fontWeight: 600,
        textAlign: 'right',
        paddingRight: theme.spacing(3),
        color: theme.palette.secondary.main
    },
    icon: {
        marginLeft: theme.spacing(2)
    }
}));


export const EnhancedTableToolbar = props => {
    const classes = useToolbarStyles();
    const { numSelected, title, titleIcon, total, isFilterShown, isRowSelectorShown, onDelete } = props;

    return (
        <Toolbar
            className={clsx(classes.root, {
                [classes.highlight]: numSelected > 0 && isRowSelectorShown,
            })}
        >
            {numSelected > 0 && isRowSelectorShown ? (
                <Typography className={classes.title} color="inherit" variant="subtitle1">
                    {numSelected} selected
                </Typography>
            ) : (
                <Grid container spacing={2}>
                    <Grid item xs={6}>
                        <Typography className={classes.title} variant="h6">
                            {title}
                            {titleIcon === TitleIconEnum.check && <DoneOutlineIcon className={classes.icon}/>}
                            {titleIcon === TitleIconEnum.track && <LocalShippingIcon className={classes.icon}/>}
                            {titleIcon === TitleIconEnum.infinity && <AllInclusiveIcon className={classes.icon}/>}
                            {titleIcon === TitleIconEnum.payment && <CreditCardIcon className={classes.icon}/>}
                            {titleIcon === TitleIconEnum.mall && <LocalMallIcon className={classes.icon}/>}
                            {titleIcon === TitleIconEnum.railway && <DirectionsRailwayIcon className={classes.icon}/>}
                        </Typography>
                    </Grid>
                    <Grid item xs={6}>
                        {total !== undefined && <Typography className={classes.total} variant="h6">
                        {total}
                        </Typography>}
                    </Grid>
                </Grid>

            )}

            {
                numSelected > 0 && isRowSelectorShown &&
                <Tooltip title="Видалити">
                    <IconButton aria-label="delete" onClick={onDelete}>
                        <DeleteIcon />
                    </IconButton>
                </Tooltip>
            }
            {
                numSelected === 0 && isFilterShown &&
                <Tooltip title="Filter list">
                <IconButton aria-label="filter list">
                <FilterListIcon />
                </IconButton>
                </Tooltip>
            }
        </Toolbar>
    );
};

EnhancedTableToolbar.propTypes = {
    numSelected: PropTypes.number.isRequired,
};