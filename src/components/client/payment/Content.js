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


const styles = theme => PaymentStyle(theme);

function Content({client, calls, getPayments, ...props}) {
    const {classes, handleDrawerToggle} = props;

    useEffect(() => {
        if (client.isPaymentsLoaded === false) {
           getPayments('1533A');
        }
    }, [client.isPaymentsLoaded, getPayments]);


    const isTableShown = client && client.payments && client.payments.length > 0;

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
                            <PaymentTable payments={client.payments}/>
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
    getPayments
};

function mapStateToProps(state) {
    return {
        client: state.client,
        calls: state.apiCallsInProgress
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(withStyles(styles)(Content));