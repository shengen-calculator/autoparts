import React from 'react';
import {connect} from "react-redux";
import Button from "@material-ui/core/Button";
import Dialog from "@material-ui/core/Dialog";
import DialogTitle from "@material-ui/core/DialogTitle";
import DialogContent from "@material-ui/core/DialogContent";
import DialogContentText from "@material-ui/core/DialogContentText";
import DialogActions from "@material-ui/core/DialogActions";
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableHead from '@material-ui/core/TableHead';
import TableRow from '@material-ui/core/TableRow';


function OrderListDialog(props) {
    const {isOpened, name, onClose, continueOrder, inOrder} = props;

    function handleOrderClick(event) {
        event.preventDefault();
        onClose();
        continueOrder(name);
    }

    return (
        <div>
            <Dialog open={isOpened} aria-labelledby="form-dialog-title" onClose={onClose}>
                <DialogTitle id="form-dialog-title">Запчастина вже присутня в списку замовлень</DialogTitle>
                <form onSubmit={handleOrderClick}>
                    <DialogContent>
                        <DialogContentText>
                            <Table aria-label="simple table">
                                <TableHead>
                                    <TableRow>
                                        <TableCell>VIP</TableCell>
                                        <TableCell align="right">Пост.</TableCell>
                                        <TableCell align="right">Бренд</TableCell>
                                        <TableCell align="right">Номер</TableCell>
                                        <TableCell align="right">К-сть</TableCell>
                                    </TableRow>
                                </TableHead>
                                <TableBody>
                                    {inOrder.map((row) => (
                                        <TableRow key={row.vip}>
                                            <TableCell component="th" scope="row">
                                                {row.vip}
                                            </TableCell>
                                            <TableCell align="right">{row.vendor}</TableCell>
                                            <TableCell align="right">{row.brand}</TableCell>
                                            <TableCell align="right">{row.number}</TableCell>
                                            <TableCell align="right">{row.quantity}</TableCell>
                                        </TableRow>
                                    ))}
                                </TableBody>
                            </Table>

                        </DialogContentText>
                    </DialogContent>
                    <DialogActions>
                        <Button onClick={onClose} color="primary">
                            Відміна
                        </Button>
                        <Button type="submit" color="primary">
                            Продовжити
                        </Button>
                    </DialogActions>
                </form>
            </Dialog>
        </div>
    );
}


function mapStateToProps(state) {
    return {
        client: state.client,
        auth: state.authentication
    }
}

export default connect(mapStateToProps)(OrderListDialog);