import React, {useEffect} from 'react';
import Typography from '@material-ui/core/Typography';
import Paper from '@material-ui/core/Paper';
import {withStyles} from '@material-ui/core/styles';
import ContentStyle from "../../../common/ContentStyle";
import {Helmet} from "react-helmet";
import ReserveTable from "../../order/ReserveTable";
import {refreshPeriod} from "../../../../util/RefreshPeriod";
import {getOrders, getReserves} from "../../../../redux/actions/clientActions";
import {connect} from "react-redux";

const styles = theme => ContentStyle(theme);

function Content({client, calls, getReserves, classes, ...props}) {
    useEffect(() => {
        if (!client.isReservesLoaded || (new Date() - client.reserveLoadingTime > refreshPeriod)) {
            getReserves();
        }
    }, [client.isReservesLoaded, client.reserveLoadingTime, getReserves]);

    const isReserveTablesShown = client && client.reserves;

    return (
        <Paper className={classes.paper}>
            <Helmet>
                <title>Fenix - Історія відвантажень</title>
            </Helmet>

            <div className={classes.contentWrapper}>
                {isReserveTablesShown ?
                    <div>
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