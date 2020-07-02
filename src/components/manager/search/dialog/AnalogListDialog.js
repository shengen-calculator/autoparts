import React from "react";
import Dialog from "@material-ui/core/Dialog";
import DialogTitle from "@material-ui/core/DialogTitle";
import CircularProgress from '@material-ui/core/CircularProgress';
import {connect} from "react-redux";
import Button from "@material-ui/core/Button";
import DialogActions from "@material-ui/core/DialogActions";
import Box from '@material-ui/core/Box';
import Table from "@material-ui/core/Table";
import TableHead from "@material-ui/core/TableHead";
import TableRow from "@material-ui/core/TableRow";
import TableCell from "@material-ui/core/TableCell";
import TableBody from "@material-ui/core/TableBody";
import DialogContent from "@material-ui/core/DialogContent";

function AnalogListDialog(props) {
    const {isOpened, onClose, analogs, calls} = props;
    const sorted = analogs.concat().sort((a, b) => {
        if(a['stock'] < b['stock']) {
            return 1;
        } else if(a['stock'] === b['stock'] && a.price < b.price) {
            return 1;
        }
        return -1;
    });
    return (
        <div>
            <Dialog open={isOpened} aria-labelledby="form-dialog-title" onClose={onClose} maxWidth="xl">
                <DialogTitle id="form-dialog-title">
                    Список аналогів артикула
                </DialogTitle>
                <Box display="flex" justifyContent="center">
                    { (analogs.length === 0 && calls > 0) ?
                        <CircularProgress /> :
                        <DialogContent>
                            <Table aria-label="simple table"  size="small">
                                <TableHead>
                                    <TableRow>
                                        <TableCell align="right">Пост.</TableCell>
                                        <TableCell align="right">Бренд</TableCell>
                                        <TableCell align="right">Номер</TableCell>
                                        <TableCell align="right">Оптова</TableCell>
                                        <TableCell align="right">Роздрібна</TableCell>
                                        <TableCell align="right">Знижка</TableCell>
                                        <TableCell align="right">Залишок</TableCell>
                                    </TableRow>
                                </TableHead>
                                <TableBody>
                                    {sorted.map((row, index) => {
                                        return (
                                            <TableRow key={index}>
                                                <TableCell align="right">{row.vendor}</TableCell>
                                                <TableCell align="right">{row.brand}</TableCell>
                                                <TableCell align="right">{row.number}</TableCell>
                                                <TableCell align="right">{row.price}</TableCell>
                                                <TableCell align="right">{row.retail}</TableCell>
                                                <TableCell align="right">{row.discount}</TableCell>
                                                <TableCell align="right">{row['stock']}</TableCell>
                                            </TableRow>
                                        )
                                    } )}
                                </TableBody>
                            </Table>

                        </DialogContent>
                    }

                </Box>

                <DialogActions>
                    <Button onClick={onClose} color="primary">
                        Відміна
                    </Button>
                </DialogActions>
            </Dialog>
        </div>
    );
}

// noinspection JSUnusedGlobalSymbols
const mapDispatchToProps = {

};

function mapStateToProps(state) {
    return {
        analogs: state.product.analogs,
        calls: state.apiCallsInProgress
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(AnalogListDialog);