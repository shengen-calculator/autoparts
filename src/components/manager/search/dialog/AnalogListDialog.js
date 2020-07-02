import React from "react";
import Dialog from "@material-ui/core/Dialog";
import DialogTitle from "@material-ui/core/DialogTitle";
import CircularProgress from '@material-ui/core/CircularProgress';
import {connect} from "react-redux";
import Button from "@material-ui/core/Button";
import DialogActions from "@material-ui/core/DialogActions";
import Box from '@material-ui/core/Box';

function AnalogListDialog(props) {
    const {isOpened, onClose, analogs, calls} = props;

    return (
        <div>
            <Dialog open={isOpened} aria-labelledby="form-dialog-title" onClose={onClose} maxWidth="xl">
                <DialogTitle id="form-dialog-title">
                    Список аналогів артикула
                </DialogTitle>
                <Box display="flex" justifyContent="center">
                    { (analogs.length === 0 && calls > 0) ?
                        <CircularProgress /> :
                        <span>{analogs.length}</span>
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