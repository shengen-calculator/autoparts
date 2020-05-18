import React, {useEffect} from 'react';
import PropTypes from 'prop-types';
import AppBar from '@material-ui/core/AppBar';
import Paper from '@material-ui/core/Paper';
import {withStyles} from '@material-ui/core/styles';
import Header from "../Header";
import Copyright from "../../common/Copyright";
import {connect} from "react-redux";
import Typography from "@material-ui/core/Typography";
import {getPayments} from "../../../redux/actions/clientActions";
import {Helmet} from "react-helmet";
import PaymentTable from "../../common/Tables/PaymentTable";
import PaymentStyle from "../../common/Tables/PaymentStyle";
import {formatCurrency} from "../../../util/Formatter";


const styles = theme => PaymentStyle(theme);

function Content({client, calls, getPayments, ...props}) {
    const {classes, handleDrawerToggle} = props;

    useEffect(() => {
        if (client.isPaymentsLoaded === false) {
           getPayments();
        }
    }, [client.isPaymentsLoaded, getPayments]);


    const isTableShown = client && client.payments && client.payments.length > 1;
    const debtAmount = isTableShown ? client.payments.reduce((a, b) => a + b.amount, 0) : 0;

    return (
        <div className={classes.app}>
            <Header onDrawerToggle={handleDrawerToggle}/>
            <Helmet>
                <title>Fenix - План платежів</title>
            </Helmet>
            <main className={classes.main}>
                {calls === 0 &&
                <Paper className={classes.paper}>
                    <AppBar className={classes.searchBar} position="static" color="default" elevation={0}/>
                    <div className={classes.contentWrapper}>
                        {isTableShown ?
                            (debtAmount > 0) ?
                                <PaymentTable payments={client.payments} debt={debtAmount}/> :
                                <Typography className={classes.advance} align="center">
                                    {`На Вашому рахунку: ${formatCurrency(Math.abs(debtAmount), client.isEuroClient ? 'EUR' : 'UAH')}`}
                                </Typography>
                            :
                            client.payments.length > 0 &&
                            <Typography className={client.payments[0].amount > 0 ? classes.debt : classes.advance} align="center">
                                {client.payments[0].amount > 0 ?
                                    `Ваш борг складає: ${formatCurrency(client.payments[0].amount, client.isEuroClient ? 'EUR' : 'UAH')}` :
                                    `На Вашому рахунку: ${formatCurrency(Math.abs(client.payments[0].amount), client.isEuroClient ? 'EUR' : 'UAH')}`}
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
    getPayments
};

function mapStateToProps(state) {
    return {
        client: state.client,
        calls: state.apiCallsInProgress
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(withStyles(styles)(Content));