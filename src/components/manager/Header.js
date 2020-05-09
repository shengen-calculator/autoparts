import React, {useEffect, useRef} from 'react';
import PropTypes from 'prop-types';
import AppBar from '@material-ui/core/AppBar';
import {withStyles} from '@material-ui/core/styles';
import SearchToolbar from "./SearchToolbar";
import Progress from "../common/Progress";
import {useHistory, useParams} from "react-router-dom";
import {getClient} from "../../redux/actions/clientActions";
import {connect} from "react-redux";
import LoginToolbar from "../common/LoginToolbar";

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

function Header({getClient, client, ...props}) {
    const {onDrawerToggle} = props;
    let {vip} = useParams();
    let history = useHistory();
    const didMountRef = useRef(false);

    useEffect(() => {
        if(vip) {
            if(client.vip !== vip) {
                getClient(vip);
            }
        }
    }, [vip, client.vip, getClient]);

    useEffect(() => {
        if (didMountRef.current && client.isClientNotExists)
            history.replace(`/manager/search/${client.vip}`);
        else
            didMountRef.current = true;
    }, [client.isClientNotExists, client.vip, history]);

    return (
        <React.Fragment>
            <AppBar color="primary" position="sticky" elevation={0}>
                <LoginToolbar onDrawerToggle={onDrawerToggle}/>
                <SearchToolbar/>
                <Progress />
            </AppBar>
        </React.Fragment>
    );
}

Header.propTypes = {
    classes: PropTypes.object.isRequired,
    onDrawerToggle: PropTypes.func.isRequired,
};

// noinspection JSUnusedGlobalSymbols
const mapDispatchToProps = {
    getClient
};

function mapStateToProps(state) {
    return {
        client: state.client
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(withStyles(styles)(Header));
