import React from "react";
import Dialog from "@material-ui/core/Dialog";
import DialogTitle from "@material-ui/core/DialogTitle";
import CircularProgress from '@material-ui/core/CircularProgress';
import {connect} from "react-redux";
import Button from "@material-ui/core/Button";
import DialogActions from "@material-ui/core/DialogActions";
import Box from '@material-ui/core/Box';
import DialogContent from "@material-ui/core/DialogContent";
import EditPriceDialog from "./EditPriceDialog";
import PriceEditTable from "./PriceEditTable";
import StableSort from "../../../../util/StableSort";
import GetComparator from "../../../../util/GetComparator";


function AnalogListDialog(props) {
    const {isOpened, onClose, analogs, calls} = props;
    const [editPriceDialog, setEditPriceDialog] = React.useState({
        isOpened: false,
        row: {}
    });

    const resetPrice = (id) => {
        alert("clean ->" + id);
    };
    const updatePrice = (event) => {
        event.preventDefault();
        alert("hello world");
    };


    const handleCancelEditDialog = () => {
        setEditPriceDialog({
            isOpened: false, row: {}
        });
    };

    return (
        <div>
            <Dialog open={isOpened} aria-labelledby="form-dialog-title" onClose={onClose} maxWidth="xl">
                {(analogs.length === 0 && calls > 0) &&
                <DialogTitle id="form-dialog-title">
                    Завантаження таблиці аналогів...
                </DialogTitle>}
                <Box display="flex" justifyContent="center">
                    {(analogs.length === 0 && calls > 0) ?
                        <CircularProgress/> :
                        <DialogContent>
                            <PriceEditTable resetPrice={resetPrice} updatePrice={updatePrice} rows={StableSort(analogs, GetComparator('desc', 'retail'))}/>
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