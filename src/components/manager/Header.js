import React from 'react';
import PropTypes from 'prop-types';
import AppBar from '@material-ui/core/AppBar';
import {withStyles} from '@material-ui/core/styles';
import LinearProgress from "@material-ui/core/LinearProgress";
import SearchToolbar from "./SearchToolbar";
import LoginToolbar from "./LoginToolbar";

const lightColor = 'rgba(255, 255, 255, 0.7)';

const styles = theme => ({
    secondaryBar: {
        zIndex: 0,
    },
    menuButton: {
        marginLeft: -theme.spacing(1),
    },
    iconButtonAvatar: {
        padding: 4,
    },
    link: {
        textDecoration: 'none',
        color: lightColor,
        '&:hover': {
            color: theme.palette.common.white,
        },
    },
    button: {
        borderColor: lightColor,
    },
});

function Header(props) {
    const {onDrawerToggle} = props;
    return (
        <React.Fragment>
            <AppBar color="primary" position="sticky" elevation={0}>
                <LoginToolbar onDrawerToggle={onDrawerToggle}/>
                <SearchToolbar/>
                <LinearProgress />
            </AppBar>
        </React.Fragment>
    );
}

Header.propTypes = {
    classes: PropTypes.object.isRequired,
    onDrawerToggle: PropTypes.func.isRequired,
};

export default withStyles(styles)(Header);