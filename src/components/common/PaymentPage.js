import Paper from "@material-ui/core/Paper";
import AppBar from "@material-ui/core/AppBar";
import PaymentTable from "./Tables/PaymentTable";
import Typography from "@material-ui/core/Typography";
import {formatCurrency} from "../../util/Formatter";
import React from "react";
import PaymentStyle from "./Tables/PaymentStyle";
import {withStyles} from "@material-ui/core/styles";

const styles = theme => PaymentStyle(theme);

function PaymentPage({debtAmount, client, calls, isTableShown, ...props}) {
    const {classes} = props;
    return (
        <main className={classes.main}>
            {(calls === 0 || client.payments.length > 0) &&
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
    )
}

export default withStyles(styles)(PaymentPage);