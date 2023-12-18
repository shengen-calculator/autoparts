import React, {useEffect} from 'react';
import {makeStyles} from '@material-ui/core/styles';
import Button from "@material-ui/core/Button";
import Dialog from "@material-ui/core/Dialog";
import DialogTitle from "@material-ui/core/DialogTitle";
import DialogContent from "@material-ui/core/DialogContent";
import DialogContentText from "@material-ui/core/DialogContentText";
import DialogActions from "@material-ui/core/DialogActions";
import TableContainer from "@material-ui/core/TableContainer";
import Table from "@material-ui/core/Table";
import TableHead from "@material-ui/core/TableHead";
import TableRow from "@material-ui/core/TableRow";
import TableCell from "@material-ui/core/TableCell";
import TableBody from "@material-ui/core/TableBody";
import Paper from '@material-ui/core/Paper';
import {
    unblockClient,
    getUnblockRecords
} from "../../../redux/actions/clientActions";
import {connect} from "react-redux";
import {RoleEnum} from "../../../util/Enums";
import CircularProgress from "@material-ui/core/CircularProgress";

function UnblockDialog(props) {
    const {isOpened, onClose, unblockClient, getUnblockRecords, client, auth} = props;
    const useStyles = makeStyles({
        table: {
            minWidth: 550,
        },
        btn: {
            margin: '40px'
        },
        centered: {
            display: 'flex',
            margin: '40px',
            justifyContent: 'space-around'
        }
    });

    useEffect(() => {
        if(isOpened) {
            getUnblockRecords(client.vip);
        }
    }, [isOpened, client.vip, getUnblockRecords]);

    function handleUnblockClick(event) {
        event.preventDefault();
        unblockClient(client.vip);
        onClose();
    }

    function getFormatted(date) {
        const jsDate = new Date(date);
        return `${jsDate.getDate()}-${jsDate.getMonth()}-${jsDate.getFullYear()}`
    }

    const classes = useStyles();
    return (
        <Dialog
            open={isOpened}
            onClose={onClose}
            aria-labelledby="alert-dialog-title"
            aria-describedby="alert-dialog-description"
        >
            <DialogTitle id="alert-dialog-title">{"Історія розблокувань"}</DialogTitle>
            {client.isUnblockRecordsLoaded ?
                <form onSubmit={handleUnblockClick}>
                    <DialogContent>
                        <DialogContentText id="alert-dialog-description">
                            <TableContainer component={Paper}>
                                <Table className={classes.table} aria-label="simple table" size="small">
                                    <TableHead>
                                        <TableRow>
                                            <TableCell>Дата</TableCell>
                                            <TableCell align="right">Менеджер</TableCell>
                                        </TableRow>
                                    </TableHead>
                                    <TableBody>
                                        {client.unblockRecords.map((row) => (
                                            <TableRow key={row.name}>
                                                <TableCell component="th" scope="row">
                                                    {getFormatted(row.date)}
                                                </TableCell>
                                                <TableCell align="right">{row.user}</TableCell>
                                            </TableRow>
                                        ))}
                                    </TableBody>
                                </Table>
                            </TableContainer>
                        </DialogContentText>
                    </DialogContent>
                    <DialogActions className={classes.btn}>
                        <Button onClick={onClose} color="primary">
                            Відмінити
                        </Button>
                        <Button type="submit" color="primary"
                                disabled={auth.role !== RoleEnum.Admin} autoFocus>
                            Розблокувати
                        </Button>
                    </DialogActions>
                </form> :
                <div className={classes.centered}>
                    <CircularProgress color="secondary"/>
                </div>
            }
        </Dialog>
    );
}

// noinspection JSUnusedGlobalSymbols
const mapDispatchToProps = {
    unblockClient,
    getUnblockRecords
};

function mapStateToProps(state) {
    return {
        client: state.client,
        auth: state.authentication
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(UnblockDialog);
