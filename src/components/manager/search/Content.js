import React, {useEffect} from 'react';
import PropTypes from 'prop-types';
import AppBar from '@material-ui/core/AppBar';
import Paper from '@material-ui/core/Paper';
import {useParams, useHistory} from 'react-router-dom';
import {withStyles} from '@material-ui/core/styles';
import GeneralTable from "./GeneralTable";
import VendorTable from "./VendorTable";
import AnalogTable from "./AnalogTable";
import Header from '../Header';
import Copyright from '../../common/Copyright';
import {connect} from "react-redux";
import {Helmet} from "react-helmet";
import GroupedTable from "./GroupedTable";


const drawerWidth = 256;
const styles = theme => ({
    root: {
        display: 'flex',
        minHeight: '100vh'
    },
    drawer: {
        [theme.breakpoints.up('sm')]: {
            width: drawerWidth,
            flexShrink: 0
        }
    },
    app: {
        flex: 1,
        display: 'flex',
        flexDirection: 'column'
    },
    main: {
        flex: 1,
        padding: theme.spacing(1, 2),
        background: '#eaeff1'
    },
    footer: {
        padding: theme.spacing(4),
        background: '#eaeff1'
    },
    paper: {
        margin: 'auto',
        overflow: 'hidden'
    },
    searchBar: {
        borderBottom: '1px solid rgba(0, 0, 0, 0.12)'
    },
    searchInput: {
        fontSize: theme.typography.fontSize
    },
    block: {
        display: 'block'
    },
    addUser: {
        marginRight: theme.spacing(1)
    },
    contentWrapper: {
        margin: '40px 16px'
    }
});

function Content({auth, client, ...props}) {
    const {classes, handleDrawerToggle} = props;
    let history = useHistory();
    let {vip} = useParams();


    useEffect(() => {
        if (!vip) {
            if(!client.vip) {
                history.push(`/manager/search/${auth.vip}`)
            } else {
                history.push(`/manager/search/${client.vip}`)
            }
        }
    }, [vip, client.vip, auth.vip, history]);

    return (<div className={classes.app}>
        <Header onDrawerToggle={handleDrawerToggle}/>
        <Helmet>
            <title>Autoparts - Клієнт - {client.vip}</title>
        </Helmet>
        <main className={classes.main}>
            <Paper className={classes.paper}>
                <AppBar className={classes.searchBar} position="static" color="default" elevation={0}/>
                <div className={classes.contentWrapper}>
                    {/*<Typography color="textSecondary" align="center">
                      По Вашему запросу ничего не найдено
                  </Typography>*/
                    }
                    <GroupedTable/>
                    <GeneralTable/>
                    <VendorTable/>
                    <AnalogTable/>
                </div>
            </Paper>
        </main>
        <footer className={classes.footer}>
            <Copyright/>
        </footer>
    </div>);
}

Content.propTypes = {
    classes: PropTypes.object.isRequired,
};


function mapStateToProps(state) {
    return {
        auth: state.authentication,
        client: state.client
    }
}

export default connect(mapStateToProps)(withStyles(styles)(Content));
