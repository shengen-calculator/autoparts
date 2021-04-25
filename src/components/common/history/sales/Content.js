import React from 'react';
import Typography from '@material-ui/core/Typography';
import Paper from '@material-ui/core/Paper';
import {withStyles} from '@material-ui/core/styles';
import ContentStyle from "../../ContentStyle";
import {Helmet} from "react-helmet";
import SalesTable from "../../../common/history/sales/SalesTable";
import {getSaleHistory} from "../../../../redux/actions/historyActions";
import {connect} from "react-redux";

const styles = theme => ContentStyle(theme);

function Content({client, getSaleHistory, classes}) {

    const isTablesShown = client && client.saleHistory;

    return (
        <Paper className={classes.paper}>
            <Helmet>
                <title>Fenix - Історія відвантажень</title>
            </Helmet>

            <div className={classes.contentWrapper}>
                {isTablesShown ?
                    <div>
                        {isTablesShown && <SalesTable
                            getSaleHistory={getSaleHistory}
                            rowLoadingTime={client.saleHistoryLoadingTime}
                            rowsTotal={client.saleHistory[0]['totalCount']}
                            sales={client.saleHistory.map(el => {
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

// noinspection JSUnusedGlobalSymbols
const mapDispatchToProps = {
    getSaleHistory
};

function mapStateToProps(state) {
    return {
        client: state.client,
        calls: state.apiCallsInProgress
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(withStyles(styles)(Content));