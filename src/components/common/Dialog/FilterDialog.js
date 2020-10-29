import Dialog from "@material-ui/core/Dialog";
import DialogTitle from "@material-ui/core/DialogTitle";
import React from "react";

function FilterDialog(props) {
    const {isOpened, onClose} = props;

    return (
        <div>
            <Dialog open={isOpened} aria-labelledby="form-dialog-title" onClose={onClose} maxWidth="xl">
                <DialogTitle id="form-dialog-title">Фільтрувати за параметрами</DialogTitle>
            </Dialog>
        </div>
    );
}

export default FilterDialog;