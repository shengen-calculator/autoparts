import DialogContent from "@material-ui/core/DialogContent";
import Table from "@material-ui/core/Table";
import TableHead from "@material-ui/core/TableHead";
import TableRow from "@material-ui/core/TableRow";
import TableCell from "@material-ui/core/TableCell";
import TableBody from "@material-ui/core/TableBody";
import DialogActions from "@material-ui/core/DialogActions";
import Button from "@material-ui/core/Button";
import React from "react";

export default function OrderConfirmation(props) {
    const {handleOrderClick, onClose, inOrder} = props;
    return (
        <form onSubmit={handleOrderClick}>
            <DialogContent>
                <Table aria-label="simple table">
                    <TableHead>
                        <TableRow>
                            <TableCell>VIP</TableCell>
                            <TableCell align="right">Пост.</TableCell>
                            <TableCell align="right">Бренд</TableCell>
                            <TableCell align="right">Номер</TableCell>
                            <TableCell align="right">К-сть</TableCell>
                            <TableCell align="right">Примітка</TableCell>
                            <TableCell align="right">Дата</TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {inOrder.map((row) => {
                            return (
                                <TableRow key={row.vip}>
                                    <TableCell component="th" scope="row">
                                        {row.vip}
                                    </TableCell>
                                    <TableCell align="right">{row.vendor}</TableCell>
                                    <TableCell align="right">{row.brand}</TableCell>
                                    <TableCell align="right">{row.number}</TableCell>
                                    <TableCell align="right">{row.quantity}</TableCell>
                                    <TableCell align="right">{row.note}</TableCell>
                                    <TableCell align="right">{row['preliminaryDate']}</TableCell>
                                </TableRow>
                            )
                        } )}
                    </TableBody>
                </Table>

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
    );
}