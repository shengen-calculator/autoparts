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
import {getOrders, getReserves, deleteOrdersByIds, deleteReservesByIds} from "../../../redux/actions/clientActions";
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

function Content({client, calls, getOrders, getReserves, deleteOrdersByIds, deleteReservesByIds, ...props}) {
    const {classes, handleDrawerToggle} = props;
    let {vip} = useParams();

    const handleOrderDeleteClick = (selected) => {
        deleteOrdersByIds(selected);
    };

    const handleReserveDeleteClick = (selected) => {
        deleteReservesByIds({selected, reserves: client.reserves.filter(x => selected.includes(x.id))});
    };

    useEffect(() => {
        if(!client.isOrdersLoaded && vip === client.vip) {
            getOrders(vip);
        }
    }, [client.orders, client.isOrdersLoaded, client.vip, vip, getOrders]);

    useEffect(() => {
        if(!client.isReservesLoaded && vip === client.vip) {
            getReserves(vip);
        }
    }, [client.reserves, client.isReservesLoaded, client.vip, vip, getReserves]);

    const isOrderTablesShown = client && client.orders && client.orders.length > 0;
    const isReserveTablesShown = client && client.reserves && client.reserves.length > 0;
    return (
        <div className={classes.app}>
            <Helmet>
                <title>Autoparts - Замовлення - {client.vip}</title>
            </Helmet>
            <Header onDrawerToggle={handleDrawerToggle}/>
            <main className={classes.main}>
                {(isOrderTablesShown || isReserveTablesShown || calls === 0) &&
                    <Paper className={classes.paper}>
                    <AppBar className={classes.searchBar} position="static" color="default" elevation={0}/>
                    <div className={classes.contentWrapper}>
                        {isOrderTablesShown || isReserveTablesShown ?
                            <React.Fragment>
                                {isOrderTablesShown && <OrderTable
                                    orders={client.orders} isEuroClient={client.isEuroClient}
                                    onDelete={handleOrderDeleteClick} />}
                                {isReserveTablesShown && <ReserveTable
                                    reserves={client.reserves} isEuroClient={client.isEuroClient}
                                    onDelete={handleReserveDeleteClick} />}
                            </React.Fragment>
                            :
                            <Typography color="textSecondary" align="center">
                                Інформація відсутня
                            </Typography>
                        }
                    </div>
                </Paper>}
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
    getOrders,
    getReserves,
    deleteOrdersByIds,
    deleteReservesByIds
};

function mapStateToProps(state) {
    return {
        client: state.client,
        calls: state.apiCallsInProgress
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(withStyles(styles)(Content));