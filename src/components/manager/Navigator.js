import React from 'react';
import PropTypes from 'prop-types';
import clsx from 'clsx';
import { withStyles } from '@material-ui/core/styles';
import Divider from '@material-ui/core/Divider';
import Drawer from '@material-ui/core/Drawer';
import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import ListItemIcon from '@material-ui/core/ListItemIcon';
import ListItemText from '@material-ui/core/ListItemText';
import BuildIcon from '@material-ui/icons/Build';
import PeopleIcon from '@material-ui/icons/People';
import DnsRoundedIcon from '@material-ui/icons/DnsRounded';
import EqualizerIcon from '@material-ui/icons/Equalizer';
import PaymentIcon from '@material-ui/icons/Payment';
import {NavLink} from "react-router-dom";

const categories = [
    {
        id: 'Робота',
        children: [
            { id: 'Пошук', icon: <BuildIcon />, path: 'search', isVipSpecified: true, isSearchCriteriaSpecified: true },
            { id: 'Замовлення', icon: <DnsRoundedIcon />, path: 'order', isVipSpecified: true },
            { id: 'Оплата', icon: <PaymentIcon />, path: 'payment', isVipSpecified: true},
        ],
    },
    {
        id: 'Аналітика',
        children: [
            { id: 'Статистика', icon: <EqualizerIcon />, path: 'statistic', isVipSpecified: false },
        ],
    },
];

const styles = theme => ({
    categoryHeader: {
        paddingTop: theme.spacing(2),
        paddingBottom: theme.spacing(2),
    },
    categoryHeaderPrimary: {
        color: theme.palette.common.white,
    },
    item: {
        paddingTop: 1,
        paddingBottom: 1,
        color: 'rgba(255, 255, 255, 0.7)',
        '&:hover,&:focus': {
            backgroundColor: 'rgba(255, 255, 255, 0.08)',
        },
    },
    itemCategory: {
        backgroundColor: '#232f3e',
        boxShadow: '0 -1px 0 #404854 inset',
        paddingTop: theme.spacing(2),
        paddingBottom: theme.spacing(2),
    },
    firebase: {
        fontSize: 24,
        color: theme.palette.common.white,
    },
    itemActiveItem: {
        color: '#4fc3f7',
    },
    itemPrimary: {
        fontSize: 'inherit',
    },
    itemIcon: {
        minWidth: 'auto',
        marginRight: theme.spacing(2),
    },
    divider: {
        marginTop: theme.spacing(2),
    },
});

function Navigator(props) {
    const {classes, vip, brand, numb, fullName, ...other} = props;

    return (
        <Drawer variant="permanent" {...other}>
            <List disablePadding>
                <ListItem className={clsx(classes.firebase, classes.item, classes.itemCategory)}>
                    AutoParts
                </ListItem>
                <ListItem className={clsx(classes.item, classes.itemCategory)}>
                    <ListItemIcon className={classes.itemIcon}>
                        <PeopleIcon/>
                    </ListItemIcon>
                    <ListItemText
                        classes={{
                            primary: classes.itemPrimary,
                        }}
                    >
                        {vip} - {fullName}
                    </ListItemText>
                </ListItem>
                {categories.map(({id, children}) => (
                    <React.Fragment key={id}>
                        <ListItem className={classes.categoryHeader}>
                            <ListItemText
                                classes={{
                                    primary: classes.categoryHeaderPrimary,
                                }}
                            >
                                {id}
                            </ListItemText>
                        </ListItem>
                        {children.map(({id: childId, icon, path, isVipSpecified, isSearchCriteriaSpecified}) => (
                            <ListItem
                                key={childId}
                                button
                                component={NavLink} to={ isVipSpecified ?
                                (isSearchCriteriaSpecified ?
                                    (brand ? `/manager/${path}/${vip}/${numb}/${brand}` :
                                        `/manager/${path}/${vip}/${numb}`) :
                                    `/manager/${path}/${vip}`) :
                                `/manager/${path}` }
                                activeClassName={classes.itemActiveItem}
                                isActive={(match, location) => {
                                    if (match) {
                                        return location.pathname.includes(match.url);
                                    } else {
                                        return path === 'search' &&
                                            (location.pathname === '/manager' || location.pathname === '/manager/');
                                    }
                                }}
                                className={classes.item}
                            >
                                <ListItemIcon className={classes.itemIcon}>{icon}</ListItemIcon>
                                <ListItemText
                                    classes={{
                                        primary: classes.itemPrimary,
                                    }}
                                >
                                    {childId}
                                </ListItemText>
                            </ListItem>
                        ))}

                        <Divider className={classes.divider}/>
                    </React.Fragment>
                ))}
            </List>
        </Drawer>
    );
}

Navigator.propTypes = {
    classes: PropTypes.object.isRequired,
};

export default withStyles(styles)(Navigator);