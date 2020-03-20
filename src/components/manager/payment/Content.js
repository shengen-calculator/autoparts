import React, {useEffect} from 'react';
import PropTypes from 'prop-types';
import AppBar from '@material-ui/core/AppBar';
import Paper from '@material-ui/core/Paper';
import {withStyles} from '@material-ui/core/styles';
import Header from "../Header";
import Copyright from "../../common/Copyright";
import PaymentTable from "./PaymentTable";
import {connect} from "react-redux";
import Typography from "@material-ui/core/Typography";
import {useParams} from "react-router-dom";
import {getPaymentsRequest} from "../../../redux/actions/clientActions";
import {Helmet} from "react-helmet";

const styles = theme => ({
    paper: {
        margin: 'auto',
        overflow: 'hidden',
        maxWidth: 650,
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

function Content({client, getPaymentsRequest, ...props}) {
    const {classes, handleDrawerToggle} = props;
    let {vip} = useParams();

    useEffect(() => {
        if(!client.isPaymentsLoaded && vip === client.vip) {
            getPaymentsRequest(vip);
        }
    }, [client.payments, client.isPaymentsLoaded, client.vip, vip, getPaymentsRequest]);

    const isTableShown = client && client.payments && client.payments.length > 0;

    return (
        <div className={classes.app}>
            <Header onDrawerToggle={handleDrawerToggle}/>
            <Helmet>
                <title>Autoparts - План платежів - {client.vip}</title>
            </Helmet>
            <main className={classes.main}>
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
    getPaymentsRequest
};

function mapStateToProps(state) {
    return {
        client: state.client
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(withStyles(styles)(Content));