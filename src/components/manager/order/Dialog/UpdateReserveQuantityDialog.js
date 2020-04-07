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
    function updateQuantity() {
        if(reserveUpdate.quantity && Number.isInteger(Number(reserveUpdate.quantity))) {
            updateReserveQuantity({
                reserveId: selected.id,
                quantity: Number(reserveUpdate.quantity)
            });
            onClose();
        }
    }

    const quantityKeyPress = (target) => {
        if(target.charCode === 13 || target.type === 'click') {
            updateQuantity();
        }
    };

    return (
        <div>
            <Dialog open={isOpened} aria-labelledby="form-dialog-title">
                <DialogTitle id="form-dialog-title">Змінити к-сть зарезервованих позицій</DialogTitle>
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
                        value={reserveUpdate.quantity}
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
    updateReserveQuantity
};


export default connect(null, mapDispatchToProps)(UpdateReserveQuantityDialog);