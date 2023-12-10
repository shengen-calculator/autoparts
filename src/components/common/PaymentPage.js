import Paper from "@material-ui/core/Paper";
import AppBar from "@material-ui/core/AppBar";
import PaymentTable from "./Tables/PaymentTable";
import Typography from "@material-ui/core/Typography";
import {formatCurrency} from "../../util/Formatter";
import React from "react";
import PaymentStyle from "./Tables/PaymentStyle";
import {withStyles} from "@material-ui/core/styles";
import Button from '@material-ui/core/Button';
import SaveAltIcon from '@material-ui/icons/SaveAlt';
import RemoveCircleIcon from '@material-ui/icons/RemoveCircle';
import ReconciliationDialog from "./Dialog/ReconciliationDialog";

const styles = theme => PaymentStyle(theme);

function PaymentPage({debtAmount, client, calls, isTableShown, ...props}) {
    const {classes} = props;
    const [reconciliationDialog, setReconciliationDialog] = React.useState({
        isOpened: false
    });
    const handleClick = (event, name) => {
        setReconciliationDialog({
            isOpened: true
        });
    };
    const handleCancelClick = () => {
        setReconciliationDialog({
            isOpened: false
        });
    };
    return (
        <React.Fragment>
            <main className={classes.main}>
                {(calls === 0 || client.payments.length > 0) &&
                <Paper className={classes.paper}>
                    <AppBar className={classes.searchBar} position="static" color="default" elevation={0}/>
                    <div className={classes.contentWrapper}>
                        {isTableShown ?
                            (debtAmount > 0) ?
                                <PaymentTable payments={client.payments} debt={debtAmount} isEuroClient={client.isEuroClient}/> :
                                <Typography className={classes.advance} align="center">
                                    {`На Вашому рахунку: ${formatCurrency(Math.abs(debtAmount), client.isEuroClient ? 'EUR' : 'UAH')}`}
                                </Typography>
                            :
                            client.payments.length > 0 &&
                            <Typography className={client.payments[0].amount > 0 ? classes.debt : classes.advance}
                                        align="center">
                                {client.payments[0].amount > 0 ?
                                    `Ваш борг складає: ${formatCurrency(client.payments[0].amount, client.isEuroClient ? 'EUR' : 'UAH')}` :
                                    `На Вашому рахунку: ${formatCurrency(Math.abs(client.payments[0].amount), client.isEuroClient ? 'EUR' : 'UAH')}`}
                            </Typography>
                        }
                        <div className={classes.centered}>
                            <Button
                                variant="outlined"
                                color="primary"
                                onClick={handleClick}
                                endIcon={<SaveAltIcon/>}>
                                Завантажити акт звірки
                            </Button>
                            <Button
                                className={classes.unblockBtn}
                                variant="outlined"
                                color="primary"
                                onClick={handleClick}
                                endIcon={<RemoveCircleIcon/>}>
                                Розблокування
                            </Button>
                        </div>
                    </div>
                </Paper>}
            </main>
            <ReconciliationDialog isOpened={reconciliationDialog.isOpened} onClose={handleCancelClick} />
        </React.Fragment>
    )
}

export default withStyles(styles)(PaymentPage);
