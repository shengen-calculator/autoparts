import React from 'react';
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

function UnblockDialog(props) {
    const {isOpened, onClose} = props;
    const useStyles = makeStyles({
        table: {
            minWidth: 550,
        },
    });

    function createData(name, calories) {
        return {name, calories};
    }

    const rows = [
        createData('19-03-2023', "puhach.alex@fenix.parts", 6.0, 24, 4.0),
        createData('27-08-2023', "puhach.alex@fenix.parts", 9.0, 37, 4.3),
        createData('11-09-2023', "ucin.sergiy@fenix.parts", 16.0, 24, 6.0),
        createData('14-11-2023', "puhach.alex@fenix.parts", 3.7, 67, 4.3),
        createData('16-11-2023', "ucin.sergiy@fenix.parts", 16.0, 49, 3.9),
        createData('19-03-2023', "puhach.alex@fenix.parts", 6.0, 24, 4.0),
        createData('27-08-2023', "puhach.alex@fenix.parts", 9.0, 37, 4.3),
        createData('11-09-2023', "ucin.sergiy@fenix.parts", 16.0, 24, 6.0),
        createData('14-11-2023', "puhach.alex@fenix.parts", 3.7, 67, 4.3),
        createData('16-11-2023', "ucin.sergiy@fenix.parts", 16.0, 49, 3.9),
    ];
    const classes = useStyles();
    return (
        <Dialog
            open={isOpened}
            onClose={onClose}
            aria-labelledby="alert-dialog-title"
            aria-describedby="alert-dialog-description"
        >
            <DialogTitle id="alert-dialog-title">{"Історія розблокувань"}</DialogTitle>
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
                                {rows.map((row) => (
                                    <TableRow key={row.name}>
                                        <TableCell component="th" scope="row">
                                            {row.name}
                                        </TableCell>
                                        <TableCell align="right">{row.calories}</TableCell>
                                    </TableRow>
                                ))}
                            </TableBody>
                        </Table>
                    </TableContainer>
                </DialogContentText>
            </DialogContent>
            <DialogActions>
                <Button onClick={onClose} color="primary">
                    Відмінити
                </Button>
                <Button onClick={onClose} color="primary" autoFocus>
                    Розблокувати
                </Button>
            </DialogActions>
        </Dialog>
    );
}

export default UnblockDialog;
