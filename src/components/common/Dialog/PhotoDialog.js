import React from "react";
import Dialog from "@material-ui/core/Dialog";
import DialogTitle from "@material-ui/core/DialogTitle";

function PhotoDialog(props) {
    const {isOpened, onClose} = props;
    return (
        <div>
            <Dialog open={isOpened} aria-labelledby="form-dialog-title" onClose={onClose} maxWidth="xl">
                <DialogTitle id="form-photo-dialog-title">Фото запчастини</DialogTitle>
            </Dialog>
        </div>
    )
}

export default PhotoDialog;