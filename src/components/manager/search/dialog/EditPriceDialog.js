import React from "react";
import Dialog from "@material-ui/core/Dialog";
import DialogTitle from "@material-ui/core/DialogTitle";
import DialogActions from "@material-ui/core/DialogActions";
import Button from "@material-ui/core/Button";
import DialogContentText from "@material-ui/core/DialogContentText";

const handleReserveClick = (event) => {
    event.preventDefault();
    alert("hello world")
};

function EditPriceDialog(props) {
    const {isOpened, onClose, row } = props;

    return (
        <div>
            <Dialog open={isOpened} aria-labelledby="form-dialog-title" onClose={onClose}>
                <DialogTitle id="form-dialog-title">Встановлення ціни</DialogTitle>
                <form onSubmit={handleReserveClick}>
                    <DialogContentText>
                        Постачальник: {row.vendor} <br/>
                        Бренд: {row.brand} <br/>
                        Номер: {row.number} <br/>
                    </DialogContentText>
                    <DialogActions>
                        <Button onClick={onClose} color="primary">
                            Відміна
                        </Button>
                        <Button type="submit" color="primary">
                            Встановити
                        </Button>
                    </DialogActions>
                </form>
            </Dialog>
        </div>
    );
}


export default EditPriceDialog;