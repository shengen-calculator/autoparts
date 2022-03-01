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
import DnsRoundedIcon from '@material-ui/icons/DnsRounded';
import PaymentIcon from '@material-ui/icons/Payment';
import EventIcon from '@material-ui/icons/Event';
import {NavLink} from "react-router-dom";
import logo from "../../korabel.png";

const categories = [
    {
        id: 'Робота',
        children: [
            { id: 'Пошук', icon: <BuildIcon />, path: 'search', isSearchCriteriaSpecified: true },
            { id: 'Замовлення', icon: <DnsRoundedIcon />, path: 'order' },
            { id: 'Фінанси', icon: <PaymentIcon />, path: 'payment'},
            { id: 'Звіти', icon: <EventIcon />, path: 'history'},
        ],
    }
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
    logo: {
        padding: 0,
        margin: 0
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
                <ListItem className={clsx(classes.logo)}>
                    <img src={logo} alt='logo'/>
                </ListItem>
                {categories.map(({id, children}) => (
                    <React.Fragment key={id}>
                        <ListItem className={classes.categoryHeader}>

                        </ListItem>
                        {children.map(({id: childId, icon, path, isSearchCriteriaSpecified}) => (
                            <ListItem
                                key={childId}
                                button
                                component={NavLink} to={ isSearchCriteriaSpecified ?
                                (brand ? `/${path}/${numb}/${brand}` :
                                    `/${path}/${numb}`) :
                                `/${path}` }
                                activeClassName={classes.itemActiveItem}
                                isActive={(match, location) => {
                                    if (match) {
                                        return location.pathname.includes(match.url);
                                    } else {
                                        return path === 'search' && (location.pathname === '/');
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