import React, {useEffect} from 'react';
import PropTypes from 'prop-types';
import AppBar from '@material-ui/core/AppBar';
import Paper from '@material-ui/core/Paper';
import {withStyles} from '@material-ui/core/styles';
import Header from "../Header";
import Copyright from "../../common/Copyright";
import {Helmet} from "react-helmet";
import {getOrders, getReserves} from "../../../redux/actions/clientActions";
import {connect} from "react-redux";
import Typography from "@material-ui/core/Typography";
import OrderTable from "./OrderTable";
import ReserveTable from "./ReserveTable";


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

function Content({client, calls, getOrders, getReserves, ...props}) {
    const {classes, handleDrawerToggle} = props;

    useEffect(() => {
        if(!client.isOrdersLoaded) {
            getOrders();
        }
    }, [client.isOrdersLoaded, getOrders]);

    useEffect(() => {
        if(!client.isReservesLoaded) {
            getReserves();
        }
    }, [ client.isReservesLoaded, getReserves]);

    const isOrderTablesShown = client && client.orders && client.orders.length > 0;
    const isReserveTablesShown = client && client.reserves && client.reserves.length > 0;
    return (
        <div className={classes.app}>
            <Helmet>
                <title>Fenix - Замовлення</title>
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
                                    orders={client.orders.map(el => {
                                        return {
                                            id: el.id,
                                            brand: el.brand,
                                            number: el.number,
                                            ordered: el.ordered,
                                            description: el.description,
                                            approved: el.approved,
                                            note: el.note,
                                            orderDate: el.orderDate,
                                            shipmentDate: el.shipmentDate,
                                            euro: el.euro,
                                            uah: el.uah,
                                            status: el.status,
                                            price: client.isEuroClient ? el.euro : el.uah
                                        }
                                    })} isEuroClient={client.isEuroClient}
                                     />}
                                {isReserveTablesShown && <ReserveTable
                                    reserves={client.reserves.map(el => {
                                        return {
                                            id: el.id,
                                            brand: el.brand,
                                            number: el.number,
                                            quantity: el.quantity,
                                            description: el.description,
                                            note: el.note,
                                            orderDate: el.orderDate,
                                            price: client.isEuroClient ? el.euro : el.uah,
                                            euro: el.euro,
                                            uah: el.uah,
                                            date: el.date,
                                            source: el.source
                                        }
                                    })} isEuroClient={client.isEuroClient}
                                     />}
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
    getReserves
};

function mapStateToProps(state) {
    return {
        client: state.client,
        calls: state.apiCallsInProgress
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(withStyles(styles)(Content));