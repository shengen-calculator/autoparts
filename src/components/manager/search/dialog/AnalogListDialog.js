import React from "react";
import Dialog from "@material-ui/core/Dialog";
import DialogTitle from "@material-ui/core/DialogTitle";
import CircularProgress from '@material-ui/core/CircularProgress';
import {connect} from "react-redux";
import Button from "@material-ui/core/Button";
import DialogActions from "@material-ui/core/DialogActions";
import Box from '@material-ui/core/Box';
import TableContainer from '@material-ui/core/TableContainer';
import Table from "@material-ui/core/Table";
import TableHead from "@material-ui/core/TableHead";
import TableRow from "@material-ui/core/TableRow";
import TableCell from "@material-ui/core/TableCell";
import TableBody from "@material-ui/core/TableBody";
import DialogContent from "@material-ui/core/DialogContent";
import ClearIcon from '@material-ui/icons/Clear';
import IconButton from '@material-ui/core/IconButton';
import EditPriceDialog from "./EditPriceDialog";



function AnalogListDialog(props) {
    const {isOpened, onClose, analogs, calls} = props;
    const [editPriceDialog, setEditPriceDialog] = React.useState({
        isOpened: false,
        row: {}
    });
    const pointer = {cursor: 'pointer'};
    const fixedHeight = {maxHeight: 440};
    const iconStyle = {

        padding: 0
    };

    const resetPrice = (id) => {
        alert("clean ->" + id);
    };
    const openSetPriceDialog = (row) => {
        setEditPriceDialog({
            isOpened: true,
            row: row
        });
    };
    const handleClick = (event, id) => {
        if (event.target.getAttribute("command") === "update") {
            openSetPriceDialog(id);
        }
    };
    const handleCancelEditDialog = () => {
        setEditPriceDialog({
            isOpened: false, row: {}
        });
    };

    const sorted = analogs.concat().sort((a, b) => {
        if (a['stock'] < b['stock']) {
            return 1;
        } else if (a['stock'] === b['stock'] && a.price < b.price) {
            return 1;
        }
        return -1;
    });
    return (
        <div>
            <Dialog open={isOpened} aria-labelledby="form-dialog-title" onClose={onClose} maxWidth="xl">
                <DialogTitle id="form-dialog-title">
                    Робота з цінами
                </DialogTitle>
                <Box display="flex" justifyContent="center">
                    {(analogs.length === 0 && calls > 0) ?
                        <CircularProgress/> :
                        <DialogContent>
                            <TableContainer style={fixedHeight}>
                                <Table stickyHeader aria-label="simple table" size="small">
                                    <TableHead>
                                        <TableRow>
                                            <TableCell align="left">Пост.</TableCell>
                                            <TableCell align="left">Бренд</TableCell>
                                            <TableCell align="left">Номер</TableCell>
                                            <TableCell align="right">Оптова</TableCell>
                                            <TableCell align="right">Роздрібна</TableCell>
                                            <TableCell align="right">Знижка</TableCell>
                                            <TableCell align="right">Залишок</TableCell>
                                            <TableCell align="right">Обнулити</TableCell>
                                        </TableRow>
                                    </TableHead>
                                    <TableBody>
                                        {sorted.map((row) => {
                                            return (
                                                <TableRow key={row.productId}
                                                          onClick={event => handleClick(event, row)}
                                                          style={pointer}>
                                                    <TableCell align="left" command="update">{row.vendor}</TableCell>
                                                    <TableCell align="left" command="update">{row.brand}</TableCell>
                                                    <TableCell align="left" command="update">{row.number}</TableCell>
                                                    <TableCell align="right" command="update">{row.price}</TableCell>
                                                    <TableCell align="right" command="update">{row.retail}</TableCell>
                                                    <TableCell align="right" command="update">{row.discount}</TableCell>
                                                    <TableCell align="right" command="update">{row['stock']}</TableCell>
                                                    <TableCell align="center">
                                                        <IconButton onClick={() => resetPrice(row.productId)}
                                                                    style={iconStyle}>
                                                            <ClearIcon/>
                                                        </IconButton>

                                                    </TableCell>
                                                </TableRow>
                                            )
                                        })}
                                    </TableBody>
                                </Table>
                            </TableContainer>

                        </DialogContent>
                    }

                </Box>

                <DialogActions>
                    <Button onClick={onClose} color="primary">
                        Відміна
                    </Button>
                </DialogActions>
            </Dialog>
            <EditPriceDialog isOpened={editPriceDialog.isOpened}
                             row={editPriceDialog.row}
                             onClose={handleCancelEditDialog}/>
        </div>
    );
}

// noinspection JSUnusedGlobalSymbols
const mapDispatchToProps = {};

function mapStateToProps(state) {
    return {
        analogs: state.product.analogs,
        calls: state.apiCallsInProgress
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(AnalogListDialog);