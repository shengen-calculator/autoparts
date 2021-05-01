import React from 'react';
import Typography from '@material-ui/core/Typography';
import Paper from '@material-ui/core/Paper';
import { withStyles } from '@material-ui/core/styles';
import ContentStyle from "../../ContentStyle";
import {Helmet} from "react-helmet";
import ReturnTable from "../return/ReturnTable";
import {getReturnHistory} from "../../../../redux/actions/historyActions";
import {connect} from "react-redux";

const styles = theme => ContentStyle(theme);

function Content({client, getReturnHistory, classes}) {

    const isTablesShown = client && client.returnHistory;

    return (
        <Paper className={classes.paper}>
            <Helmet>
                <title>Fenix - Історія повернень</title>
            </Helmet>

            <div className={classes.contentWrapper}>
                {isTablesShown ?
                    <div>
                        {isTablesShown && <ReturnTable
                            getReturnHistory={getReturnHistory}
                            rowLoadingTime={client.returnHistoryLoadingTime}
                            rowsTotal={client.returnHistory[0] ? client.returnHistory[0]['totalCount'] : 0}
                            returns={client.returnHistory.map(el => {
                                return {
                                    id: el.id,
                                    brand: el.brand,
                                    number: el.number,
                                    quantity: el.quantity,
                                    description: el.description,
                                    invoiceNumber: el.invoiceNumber,
                                    invoiceDate: el.invoiceDate,
                                    price: client.isEuroClient ? el['priceEur'] : el['priceUah']
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

const mapDispatchToProps = {
    getReturnHistory
};

function mapStateToProps(state) {
    return {
        client: state.client,
        calls: state.apiCallsInProgress
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(withStyles(styles)(Content));