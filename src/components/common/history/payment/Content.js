import React from 'react';
import Typography from '@material-ui/core/Typography';
import Paper from '@material-ui/core/Paper';
import { withStyles } from '@material-ui/core/styles';
import ContentStyle from "../../ContentStyle";
import {Helmet} from "react-helmet";
import PaymentTable from "../payment/PaymentTable";
import {getPaymentHistory} from "../../../../redux/actions/historyActions";
import {connect} from "react-redux";

const styles = theme => ContentStyle(theme);

function Content({client, getPaymentHistory, classes}) {

    const isTablesShown = client && client.saleHistory;

    return (
        <Paper className={classes.paper}>
            <Helmet>
                <title>Fenix - Історія платежів</title>
            </Helmet>

            <div className={classes.contentWrapper}>
                {isTablesShown ?
                    <div>
                        {isTablesShown && <PaymentTable
                            getPaymentHistory={getPaymentHistory}
                            rowLoadingTime={client.paymentHistoryLoadingTime}
                            rowsTotal={client.paymentHistory[0] ? client.paymentHistory[0]['totalCount'] : 0}
                            payments={client.paymentHistory.map(el => {
                                return {
                                    id: el.id,
                                    description: el.description,
                                    date: el.date,
                                    amount: client.isEuroClient ? el['amountEur'] : el['amountUah']
                                }
                            })} isEuroClient={client.isEuroClient}
                        />}
                    </div>
                    :
                    <Typography color="textSecondary" align="center">
                        Інформація відсутня
                    </Typography>
                }
            </div>
        </Paper>
    );
}

// noinspection JSUnusedGlobalSymbols
const mapDispatchToProps = {
    getPaymentHistory
};

function mapStateToProps(state) {
    return {
        client: state.client,
        calls: state.apiCallsInProgress
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(withStyles(styles)(Content));