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
import {createOrder, createOrderWithCheck} from "../../../redux/actions/searchActions";
import {RoleEnum} from "../../../util/Enums";

function OrderDialog(props) {
    const {isOpened, selected, onClose, createOrder, createOrderWithCheck, client, auth} = props;
    const [order, setOrder] = useState({
    });

    useEffect(() => {
        if(selected['costEur']) {
            setOrder({
                price: client.isEuroClient ? selected['costEur'].toFixed(2) : selected['cost'].toFixed(2),
                quantity: '',
                onlyOrderedQuantity: false
            })
        }
    }, [selected, client.isEuroClient]);

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
            if(auth.role === RoleEnum.Manager) {
                createOrderWithCheck({
                    productId: selected.id,
                    quantity: Number(order.quantity),
                    price: Number(order.price),
                    onlyOrderedQuantity: order.onlyOrderedQuantity,
                    isEuroClient: client.isEuroClient,
                    clientId: client.id,
                    vip: client.vip
                });
            } else {
                createOrder({
                    productId: selected.id,
                    quantity: Number(order.quantity),
                    onlyOrderedQuantity: order.onlyOrderedQuantity,
                    isEuroClient: client.isEuroClient
                });
            }

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
                            disabled={auth.role === RoleEnum.Client}
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
    createOrder,
    createOrderWithCheck
};

function mapStateToProps(state) {
    return {
        client: state.client,
        auth: state.authentication
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(OrderDialog);