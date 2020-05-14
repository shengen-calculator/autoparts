import React, {useEffect, useState} from 'react';
import {connect} from "react-redux";
import Button from "@material-ui/core/Button";
import Dialog from "@material-ui/core/Dialog";
import DialogTitle from "@material-ui/core/DialogTitle";
import DialogContent from "@material-ui/core/DialogContent";
import DialogContentText from "@material-ui/core/DialogContentText";
import DialogActions from "@material-ui/core/DialogActions";
import TextField from "@material-ui/core/TextField";
import {createReserve} from "../../../redux/actions/searchActions";
import {showToastrMessage} from "../../../redux/actions/messageActions";
import {RoleEnum} from "../../../util/Enums";

function ReserveDialog(props) {
    const {isOpened, selected, onClose, createReserve, showToastrMessage, client, auth} = props;
    const [reserve, setReserve] = useState({
    });

    useEffect(() => {
        if(selected.retail) {
            setReserve({
                price: client.isEuroClient ? selected['costEur'].toFixed(2) : selected['cost'].toFixed(2),
                quantity: '',
                onlyOrderedQuantity: false,
                available: selected.available
            })
        }
    }, [selected, client.isEuroClient]);

    function handleChange(event) {
        const { name, value, checked, type } = event.target;
        setReserve(prev => ({
            ...prev,
            [name]: type === "checkbox" ? checked : value
        }));
    }

    function handleReserveClick(event) {
        event.preventDefault();
        if(reserve.quantity && reserve.price
            && Number.isInteger(Number(reserve.quantity))
            && !isNaN(reserve.price)
            && reserve.price > 0
            && Number(reserve.quantity) > -1
        ) {
            if(Number(reserve.quantity) > reserve.available) {
                showToastrMessage({type: 'warning', message: 'Кількість не може бути більшою ніж доступно'})
            } else {
                createReserve({
                    productId: selected.id,
                    quantity: Number(reserve.quantity),
                    price: Number(reserve.price),
                    isEuroClient: client.isEuroClient,
                    clientId: auth.role === RoleEnum.Manager ? client.id : null
                });
                onClose();
            }
        }
    }

    return (
        <div>
            <Dialog open={isOpened} aria-labelledby="form-dialog-title" onClose={onClose}>
                <DialogTitle id="form-dialog-title">Резерв запчастини зі складу</DialogTitle>
                <form onSubmit={handleReserveClick}>
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
                            value={reserve.quantity}
                            type="text"
                        />
                        <br/>
                        <TextField
                            name="price"
                            margin="dense"
                            id="price"
                            label="Ціна"
                            onChange={handleChange}
                            value={reserve.price}
                            type="text"
                        />
                    </DialogContent>
                    <DialogActions>
                        <Button onClick={onClose} color="primary">
                            Відміна
                        </Button>
                        <Button type="submit" color="primary">
                            Резервувати
                        </Button>
                    </DialogActions>
                </form>
            </Dialog>
        </div>
    );
}

// noinspection JSUnusedGlobalSymbols
const mapDispatchToProps = {
    createReserve,
    showToastrMessage
};

function mapStateToProps(state) {
    return {
        client: state.client,
        auth: state.authentication
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(ReserveDialog);