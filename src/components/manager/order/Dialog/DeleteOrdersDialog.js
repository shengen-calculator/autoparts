import * as React from "react";
import Button from "@material-ui/core/Button";
import Dialog from "@material-ui/core/Dialog";
import DialogTitle from "@material-ui/core/DialogTitle";
import DialogContent from "@material-ui/core/DialogContent";
import DialogContentText from "@material-ui/core/DialogContentText";
import DialogActions from "@material-ui/core/DialogActions";

function DeleteOrdersDialog(props) {
    const {isOpened, onDelete, onClose} = props;
    return (
        <Dialog
            open={isOpened}
            onClose={onClose}
            aria-labelledby="alert-dialog-title"
            aria-describedby="alert-dialog-description">
            <DialogTitle id="alert-dialog-title">{"Перенести обрані замовлення в архів?"}</DialogTitle>
            <form onSubmit={onDelete}>
                <DialogContent>
                    <DialogContentText id="alert-dialog-description">
                        Якщо Ви погодитесь, всі обрані записи будуть перенесені в архів.
                        Їх відновлення буде не можливим. За необхідності Ви завжди можете створити нові замовлення
                        аналогічні видаленим.
                    </DialogContentText>
                </DialogContent>
                <DialogActions>
                    <Button onClick={onClose} color="primary">
                        Ні
                    </Button>
                    <Button type="submit" color="primary" autoFocus>
                        Так
                    </Button>
                </DialogActions>
            </form>
        </Dialog>
    );
}

export default DeleteOrdersDialog;