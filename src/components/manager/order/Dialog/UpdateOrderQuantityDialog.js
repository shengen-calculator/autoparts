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
    function updateQuantity() {
        if(orderUpdate.quantity && Number.isInteger(Number(orderUpdate.quantity))) {
            updateOrderQuantity({
                orderId: selected.id,
                quantity: Number(orderUpdate.quantity)
            });
            onClose();
        }
    }

    function quantityKeyPress(target) {
        if(target.charCode === 13 || target.type === 'click') {
            updateQuantity();
        }
    }

    return (
        <div>
            <Dialog open={isOpened} aria-labelledby="form-dialog-title">
                <DialogTitle id="form-dialog-title">Змінити кількість в замовленні</DialogTitle>
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
                        onKeyPress={quantityKeyPress}
                        onChange={handleChange}
                        value={orderUpdate.quantity}
                        type="text"
                    />
                </DialogContent>
                <DialogActions>
                    <Button onClick={onClose} color="primary">
                        Відміна
                    </Button>
                    <Button onClick={updateQuantity} color="primary">
                        Змінити
                    </Button>
                </DialogActions>
            </Dialog>
        </div>
    );
}

// noinspection JSUnusedGlobalSymbols
const mapDispatchToProps = {
    updateOrderQuantity
};


export default connect(null, mapDispatchToProps)(UpdateOrderQuantityDialog);