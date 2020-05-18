import React, {useEffect} from 'react';
import PropTypes from 'prop-types';
import {withStyles} from '@material-ui/core/styles';
import Header from "../Header";
import Copyright from "../../common/Copyright";
import {connect} from "react-redux";
import {useParams} from "react-router-dom";
import {getPayments} from "../../../redux/actions/clientActions";
import {Helmet} from "react-helmet";
import PaymentStyle from "../../common/Tables/PaymentStyle";
import PaymentPage from "../../common/PaymentPage";

const styles = theme => PaymentStyle(theme);

function Content({client, calls, getPayments, ...props}) {
    const {classes, handleDrawerToggle} = props;
    let {vip} = useParams();

    useEffect(() => {
        if(!client.isPaymentsLoaded && vip === client.vip) {
            getPayments(vip);
        }
    }, [client.payments, client.isPaymentsLoaded, client.vip, vip, getPayments]);
    const isTableShown = client && client.payments && client.payments.length > 1;
    const debtAmount = isTableShown ? client.payments.reduce((a, b) => a + b.amount, 0) : 0;

    return (
        <div className={classes.app}>
            <Header onDrawerToggle={handleDrawerToggle}/>
            <Helmet>
                <title>Fenix - План платежів - {client.vip}</title>
            </Helmet>
            <PaymentPage debtAmount={debtAmount} client={client} calls={calls} isTableShown={isTableShown}/>
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