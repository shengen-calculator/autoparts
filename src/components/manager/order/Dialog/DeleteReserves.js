import * as React from "react";
import Button from "@material-ui/core/Button";
import Dialog from "@material-ui/core/Dialog";
import DialogTitle from "@material-ui/core/DialogTitle";
import DialogContent from "@material-ui/core/DialogContent";
import DialogContentText from "@material-ui/core/DialogContentText";
import DialogActions from "@material-ui/core/DialogActions";

function DeleteReserves(props) {
    const {isOpened, onDelete, onClose} = props;
    return (
        <Dialog
            open={isOpened}
            aria-labelledby="alert-dialog-title"
            aria-describedby="alert-dialog-description">
            <DialogTitle id="alert-dialog-title">{"Відмінити обрані резерви?"}</DialogTitle>
            <DialogContent>
                <DialogContentText id="alert-dialog-description">
                    Якщо Ви погодитесь, всі обрані записи будуть видалені.
                    Їх відновлення буде не можливим. За необхідності Ви завжди можете створити резерви ще раз.
                </DialogContentText>
            </DialogContent>
            <DialogActions>
                <Button onClick={onClose} color="primary">
                    Ні
                </Button>
                <Button onClick={onDelete} color="primary" autoFocus>
                    Так
                </Button>
            </DialogActions>
        </Dialog>
    );
}

export default DeleteReserves;