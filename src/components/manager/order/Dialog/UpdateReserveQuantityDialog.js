import React, {useEffect, useState} from 'react';
import {connect} from "react-redux";
import Button from "@material-ui/core/Button";
import Dialog from "@material-ui/core/Dialog";
import DialogTitle from "@material-ui/core/DialogTitle";
import DialogContent from "@material-ui/core/DialogContent";
import DialogContentText from "@material-ui/core/DialogContentText";
import DialogActions from "@material-ui/core/DialogActions";
import TextField from "@material-ui/core/TextField";
import {updateReserveQuantity} from "../../../../redux/actions/clientActions";

function UpdateReserveQuantityDialog(props) {
    const {isOpened, selected, onClose, updateReserveQuantity} = props;
    const [reserveUpdate, setReserveUpdate] = useState({});

    useEffect(() => {
        if(selected.quantity) {
            setReserveUpdate({quantity: selected.quantity})
        }
    }, [selected]);

    function handleChange(event) {
        const { name, value } = event.target;
        setReserveUpdate(prev => ({
            ...prev,
            [name]: value
        }));
    }
    function updateQuantity(event) {
        event.preventDefault();
        if(reserveUpdate.quantity
            && Number.isInteger(Number(reserveUpdate.quantity))
            && Number(reserveUpdate.quantity) > -1
        ) {
            updateReserveQuantity({
                reserveId: selected.id,
                newQuantity: Number(reserveUpdate.quantity),
                oldQuantity: selected.quantity,
                productId: selected.productId
            });
            onClose();
        }
    }

    return (
        <div>
            <Dialog open={isOpened} aria-labelledby="form-dialog-title" onClose={onClose}>
                <DialogTitle id="form-dialog-title">Змінити к-сть зарезервованих позицій</DialogTitle>
                <form onSubmit={updateQuantity}>
                    <DialogContent>
                        <DialogContentText>
                            Постачальник: {selected.vendor} <br/>
                            Бренд: {selected.brand} <br/>
                            Номер: {selected.number} <br/>
                        </DialogContentText>
                        <TextField
                            name="quantity"
                            autoFocus
                            margin="dense"
                            id="quantity"
                            label="Кількість"
                            onChange={handleChange}
                            value={reserveUpdate.quantity}
                            type="text"
                        />
                    </DialogContent>
                    <DialogActions>
                        <Button onClick={onClose} color="primary">
                            Відміна
                        </Button>
                        <Button type="submit" color="primary">
                            Змінити
                        </Button>
                    </DialogActions>
                </form>
            </Dialog>
        </div>
    );
}

// noinspection JSUnusedGlobalSymbols
const mapDispatchToProps = {
    updateReserveQuantity
};


export default connect(null, mapDispatchToProps)(UpdateReserveQuantityDialog);