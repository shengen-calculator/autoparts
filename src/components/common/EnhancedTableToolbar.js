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
    icon: {
        marginLeft: theme.spacing(2)
    }
}));


export const EnhancedTableToolbar = props => {
    const classes = useToolbarStyles();
    const { numSelected, title, titleIcon, isFilterShown, isRowSelectorShown } = props;
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
                <Typography className={classes.title} variant="h6" id="tableTitle">
                    {title}
                    {titleIcon === TitleIconEnum.check && <DoneOutlineIcon className={classes.icon}/>}
                    {titleIcon === TitleIconEnum.track && <LocalShippingIcon className={classes.icon}/>}
                    {titleIcon === TitleIconEnum.infinity && <AllInclusiveIcon className={classes.icon}/>}
                </Typography>
            )}

            {
                numSelected > 0 && isRowSelectorShown &&
                <Tooltip title="Видалити">
                    <IconButton aria-label="delete">
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