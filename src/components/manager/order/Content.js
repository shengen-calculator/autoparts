import React, {useEffect} from 'react';
import PropTypes from 'prop-types';
import AppBar from '@material-ui/core/AppBar';
import Paper from '@material-ui/core/Paper';
import {withStyles} from '@material-ui/core/styles';
import OrderTable from "./OrderTable";
import ReserveTable from "./ReserveTable";
import Header from "../Header";
import Copyright from "../../common/Copyright";
import {Helmet} from "react-helmet";
import {getOrdersRequest} from "../../../redux/actions/clientActions";
import {connect} from "react-redux";
import {useParams} from "react-router-dom";
import Typography from "@material-ui/core/Typography";

const styles = theme => ({
    paper: {
        margin: 'auto',
        overflow: 'hidden',
    },
    app: {
        flex: 1,
        display: 'flex',
        flexDirection: 'column'
    },
    contentWrapper: {
        margin: '40px 16px',
    },
    main: {
        flex: 1,
        padding: theme.spacing(1, 2),
        background: '#eaeff1'
    },
    footer: {
        padding: theme.spacing(4),
        background: '#eaeff1'
    }
});

function Content({client, getOrdersRequest, ...props}) {
    const {classes, handleDrawerToggle} = props;
    let {vip} = useParams();

    useEffect(() => {
        if(!client.isOrdersLoaded && vip === client.vip) {
            getOrdersRequest(vip);
        }
    }, [client.orders, client.isOrdersLoaded, client.vip, vip, getOrdersRequest]);

    const isTablesShown = client && client.orders && client.orders.length > 0;
    return (
        <div className={classes.app}>
            <Helmet>
                <title>Autoparts - Замовлення - {client.vip}</title>
            </Helmet>
            <Header onDrawerToggle={handleDrawerToggle}/>
            <main className={classes.main}>
                <Paper className={classes.paper}>
                    <AppBar className={classes.searchBar} position="static" color="default" elevation={0}/>
                    <div className={classes.contentWrapper}>
                        {isTablesShown ?
                            <React.Fragment>
                                <OrderTable orders={client.orders.filter(o => o.delivered === 0)}/>
                                <ReserveTable orders={client.orders.filter(o => o.delivered > 0)}/>
                            </React.Fragment>
                            :
                            <Typography color="textSecondary" align="center">
                                Інформація відсутня
                            </Typography>
                        }
                    </div>
                </Paper>
            </main>
            <footer className={classes.footer}>
                <Copyright/>
            </footer>
        </div>
    );

}

Content.propTypes = {
    classes: PropTypes.object.isRequired,
};

// noinspection JSUnusedGlobalSymbols
const mapDispatchToProps = {
    getOrdersRequest
};

function mapStateToProps(state) {
    return {
        client: state.client
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(withStyles(styles)(Content));