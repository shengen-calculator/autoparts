import React, {useEffect, useState} from 'react';
import {connect} from "react-redux";
import Button from "@material-ui/core/Button";
import Dialog from "@material-ui/core/Dialog";
import DialogTitle from "@material-ui/core/DialogTitle";
import DialogContent from "@material-ui/core/DialogContent";
import DialogContentText from "@material-ui/core/DialogContentText";
import DialogActions from "@material-ui/core/DialogActions";
import TextField from "@material-ui/core/TextField";
import {updateOrderQuantity} from "../../../../redux/actions/clientActions";

function UpdateOrderQuantityDialog(props) {
    const {isOpened, selected, onClose, updateOrderQuantity} = props;
    const [orderUpdate, setOrderUpdate] = useState({});

    useEffect(() => {
        if(selected.ordered) {
            setOrderUpdate({quantity: selected.ordered})
        }
    }, [selected]);

    function handleChange(event) {
        const { name, value } = event.target;
        setOrderUpdate(prev => ({
            ...prev,
            [name]: value
        }));
    }
    function updateQuantity(event) {
        event.preventDefault();
        if(orderUpdate.quantity
            && Number.isInteger(Number(orderUpdate.quantity))
            && Number(orderUpdate.quantity) > -1
        ) {
            updateOrderQuantity({
                orderId: selected.id,
                quantity: Number(orderUpdate.quantity)
            });
            onClose();
        }
    }

    return (
        <div>
            <Dialog open={isOpened} aria-labelledby="form-dialog-title" onClose={onClose}>
                <DialogTitle id="form-dialog-title">Змінити кількість в замовленні</DialogTitle>
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
                            value={orderUpdate.quantity}
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
    updateOrderQuantity
};


export default connect(null, mapDispatchToProps)(UpdateOrderQuantityDialog);