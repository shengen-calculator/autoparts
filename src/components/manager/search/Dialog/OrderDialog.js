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
    const {isOpened, selected, onClose, createOrder, client} = props;
    const [order, setOrder] = useState({
    });

    useEffect(() => {
        if(selected.retail) {
            setOrder({price: selected.cost, quantity: '', onlyOrderedQuantity: false})
        }
    }, [selected]);

    function handleChange(event) {
        const { name, value, checked, type } = event.target;
        setOrder(prev => ({
            ...prev,
            [name]: type === "checkbox" ? checked : value
        }));
    }

    function handleOrderClick(event) {
        event.preventDefault();
        if(order.quantity && order.price
            && Number.isInteger(Number(order.quantity))
            && !isNaN(order.price)
            && order.price > 0
            && Number(order.quantity) > -1
        ) {
            createOrder({
                productId: selected.id,
                quantity: Number(order.quantity),
                price: Number(order.price),
                onlyOrderedQuantity: order.onlyOrderedQuantity,
                vip: client.vip
            });
            onClose();
        }
    }

    return (
        <div>
            <Dialog open={isOpened} aria-labelledby="form-dialog-title" onClose={onClose}>
                <DialogTitle id="form-dialog-title">Замовити запчастину у постачальника</DialogTitle>
                <form onSubmit={handleOrderClick}>
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
                            onChange={handleChange}
                            value={order.price}
                            type="text"
                        />
                        <br/>
                        <FormControlLabel control={
                            <Checkbox
                                margin="dense"
                                name="onlyOrderedQuantity"
                                id="onlyOrderedQuantity"
                                onChange={handleChange}
                                value={order.onlyOrderedQuantity}
                            />
                        } label="Тільки замовлена кількість"/>

                    </DialogContent>
                    <DialogActions>
                        <Button onClick={onClose} color="primary">
                            Відміна
                        </Button>
                        <Button type="submit" color="primary">
                            Замовити
                        </Button>
                    </DialogActions>
                </form>
            </Dialog>
        </div>
    );
}

// noinspection JSUnusedGlobalSymbols
const mapDispatchToProps = {
    createOrder
};

function mapStateToProps(state) {
    return {
        client: state.client
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(OrderDialog);