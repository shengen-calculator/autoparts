import React, {useEffect, useState} from 'react';
import {connect} from "react-redux";
import Button from "@material-ui/core/Button";
import Dialog from "@material-ui/core/Dialog";
import DialogTitle from "@material-ui/core/DialogTitle";
import DialogContent from "@material-ui/core/DialogContent";
import DialogContentText from "@material-ui/core/DialogContentText";
import DialogActions from "@material-ui/core/DialogActions";
import {createOrder} from "../../../redux/actions/searchActions";


function OrderCheckDialog(props) {
    const {isOpened, selected, onClose, createOrder, client, auth} = props;
    const [order, setOrder] = useState({
    });

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
                isEuroClient: client.isEuroClient,
                clientId: client.id,
                vip: client.vip
            });


            onClose();
        }
    }

    return (
        <div>
            <Dialog open={isOpened} aria-labelledby="form-dialog-title" onClose={onClose}>
                <DialogTitle id="form-dialog-title">Запчастина вже присутня в списку замовлень</DialogTitle>
                <form onSubmit={handleOrderClick}>
                    <DialogContent>
                        <DialogContentText>
                            Бренд: {selected.brand} <br/>
                            Номер: {selected.number} <br/>
                        </DialogContentText>
                    </DialogContent>
                    <DialogActions>
                        <Button onClick={onClose} color="primary">
                            Відміна
                        </Button>
                        <Button type="submit" color="primary">
                            Продовжити
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
        client: state.client,
        auth: state.authentication
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(OrderDialog);