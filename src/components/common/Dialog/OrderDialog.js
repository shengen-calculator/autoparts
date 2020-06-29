import React, {useEffect, useState} from 'react';
import {connect} from "react-redux";
import Dialog from "@material-ui/core/Dialog";
import DialogTitle from "@material-ui/core/DialogTitle";
import {createOrder} from "../../../redux/actions/searchActions";
import {RoleEnum} from "../../../util/Enums";
import OrderForm from "./OrderForm";
import OrderConfirmation from "./OrderConfirmation";

function OrderDialog(props) {
    const {isOpened, selected, onClose, createOrder, client, auth, inOrder} = props;
    const [order, setOrder] = useState({
        isConfirmed: false
    });

    useEffect(() => {
        if(selected['costEur']) {
            setOrder({
                price: client.isEuroClient ? selected['costEur'].toFixed(2) : selected['cost'].toFixed(2),
                quantity: '',
                onlyOrderedQuantity: false,
                isConfirmed: false
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

    function handleConfirm(event) {
        event.preventDefault();
        setOrder(prev => ({
            ...prev,
            isConfirmed: true
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
                createOrder({
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
    const isConfirmationDialog = inOrder && inOrder.length && !order.isConfirmed;
    return (

        <div>
            <Dialog open={isOpened} aria-labelledby="form-dialog-title" onClose={onClose} maxWidth="xl">
                <DialogTitle id="form-dialog-title">
                    {isConfirmationDialog ?
                        'Запчастина вже присутня в списку замовлень' :
                        'Замовити запчастину у постачальника'}
                </DialogTitle>
                {
                    (isConfirmationDialog) ?
                        <OrderConfirmation
                            onClose={onClose}
                            inOrder={inOrder}
                            handleOrderClick={handleConfirm}/> :
                        <OrderForm
                            selected={selected}
                            onClose={onClose}
                            handleChange={handleChange}
                            order={order}
                            auth={auth}
                            handleOrderClick={handleOrderClick}/>
                }

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
        client: state.client,
        auth: state.authentication
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(OrderDialog);