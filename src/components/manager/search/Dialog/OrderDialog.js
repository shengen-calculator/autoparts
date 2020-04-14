import React, {useEffect, useState} from 'react';
import {connect} from "react-redux";
import Button from "@material-ui/core/Button";
import Dialog from "@material-ui/core/Dialog";
import Checkbox from '@material-ui/core/Checkbox';
import DialogTitle from "@material-ui/core/DialogTitle";
import DialogContent from "@material-ui/core/DialogContent";
import DialogContentText from "@material-ui/core/DialogContentText";
import FormControlLabel from '@material-ui/core/FormControlLabel';
import DialogActions from "@material-ui/core/DialogActions";
import TextField from "@material-ui/core/TextField";
import {createOrder} from "../../../../redux/actions/searchActions";

function OrderDialog(props) {
    const {isOpened, selected, onClose, createOrder} = props;
    const [order, setOrder] = useState({
    });

    useEffect(() => {
        if(selected.retail) {
            setOrder({price: selected.retail, quantity: '', agreeToAnalog: false})
        }
    }, [selected]);

    function handleChange(event) {
        const { name, value, checked, type } = event.target;
        setOrder(prev => ({
            ...prev,
            [name]: type === "checkbox" ? checked : value
        }));
    }

    function handleOrderClick() {
        if(order.quantity && order.price
            && Number.isInteger(Number(order.quantity))
            && !isNaN(order.price)) {
            createOrder({
                quantity: Number(order.quantity),
                price: Number(order.price),
                agreeToAnalog: order.agreeToAnalog
            });
            onClose();
        }
    }

    function keyPress(target) {
        if(target.charCode === 13 || target.type === 'click') {
            handleOrderClick();
        }
    }

    return (
        <div>
            <Dialog open={isOpened} aria-labelledby="form-dialog-title">
                <DialogTitle id="form-dialog-title">Замовити запчастину у постачальника</DialogTitle>
                <DialogContent>
                    <DialogContentText>
                        Бренд: {selected.brand} <br/>
                        Номер: {selected.number} <br/>
                    </DialogContentText>
                    <TextField
                        name="quantity"
                        autoFocus
                        margin="dense"
                        id="quantity"
                        label="Кількість"
                        onKeyPress={keyPress}
                        onChange={handleChange}
                        value={order.quantity}
                        type="text"
                    />
                    <br/>
                    <TextField
                        name="price"
                        margin="dense"
                        id="price"
                        label="Ціна"
                        onKeyPress={keyPress}
                        onChange={handleChange}
                        value={order.price}
                        type="text"
                    />
                    <br/>
                    <FormControlLabel control={
                        <Checkbox
                            margin="dense"
                            name="agreeToAnalog"
                            id="agreeToAnalog"
                            onKeyPress={keyPress}
                            onChange={handleChange}
                            value={order.agreeToAnalog}
                        />
                    } label="Погоджуюсь на аналог" />

                </DialogContent>
                <DialogActions>
                    <Button onClick={onClose} color="primary">
                        Відміна
                    </Button>
                    <Button onClick={handleOrderClick} color="primary">
                        Замовити
                    </Button>
                </DialogActions>
            </Dialog>
        </div>
    );
}

// noinspection JSUnusedGlobalSymbols
const mapDispatchToProps = {
    createOrder
};


export default connect(null, mapDispatchToProps)(OrderDialog);