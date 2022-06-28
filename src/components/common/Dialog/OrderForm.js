import DialogContent from "@material-ui/core/DialogContent";
import DialogContentText from "@material-ui/core/DialogContentText";
import TextField from "@material-ui/core/TextField";
import {RoleEnum} from "../../../util/Enums";
import DialogActions from "@material-ui/core/DialogActions";
import Button from "@material-ui/core/Button";
import React from "react";
import {red, teal} from "@material-ui/core/colors";

export default function OrderForm(props) {
    const {handleOrderClick, selected, onClose, handleChange, order, deliveryDate, auth} = props;
    const redStyle = {
        color: red[500],
        marginTop: 30
    };
    const greenStyle = {
        color: teal[400]
    };
    return (
        <form onSubmit={handleOrderClick}>
        <DialogContent>
            <DialogContentText>
                Бренд: {selected.brand} <br/>
                Номер: {selected.number} <br/>
                <b style={greenStyle}>Очікуємо{(deliveryDate && Object.keys(deliveryDate).length) ?
                `: ${deliveryDate.ArrivalDate} -> ${deliveryDate.ArrivalTime}` :
                    '...'}</b>
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
            {selected['ImpossibleReturn'] && <DialogContentText style={redStyle}>
                Увага! Позиція не підлягає поверненню! <br/>
            </DialogContentText>}
            {/*<FormControlLabel control={
                <Checkbox
                    margin="dense"
                    name="onlyOrderedQuantity"
                    id="onlyOrderedQuantity"
                    onChange={handleChange}
                    value={order.onlyOrderedQuantity}
                />
            } label="Тільки замовлена кількість"/>*/}
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
    );
}