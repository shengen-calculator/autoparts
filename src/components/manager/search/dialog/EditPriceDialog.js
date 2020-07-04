import React, {useEffect, useState} from "react";
import Dialog from "@material-ui/core/Dialog";
import DialogTitle from "@material-ui/core/DialogTitle";
import DialogActions from "@material-ui/core/DialogActions";
import Button from "@material-ui/core/Button";
import DialogContentText from "@material-ui/core/DialogContentText";
import DialogContent from "@material-ui/core/DialogContent";
import TextField from "@material-ui/core/TextField";

const handleReserveClick = (event) => {
    event.preventDefault();
    alert("hello world")
};

function EditPriceDialog(props) {
    const {isOpened, onClose, row} = props;
    const [prices, setPrices] = useState({});

    useEffect(() => {
        setPrices({
            price: row.price,
            discount: row.discount,
            retail: row.retail
        })
    }, [row]);

    function handleChange(event) {
        const {name, value} = event.target;
        setPrices(prev => ({
            ...prev,
            [name]: value
        }));
    }

    return (
        <Dialog open={isOpened} aria-labelledby="form-dialog-title" onClose={onClose}>
            <DialogTitle id="form-dialog-title">Оновлення ціни артикула</DialogTitle>
            <form onSubmit={handleReserveClick}>
                <DialogContent>
                    <DialogContentText>
                        Постачальник: {row.vendor} <br/>
                        Бренд: {row.brand} <br/>
                        Номер: {row.number} <br/>
                        Вхідна ціна: {row.number} <br/>
                        Ціна постачальника: {row.number} <br/>
                    </DialogContentText>
                    <TextField
                        name="price"
                        autoFocus
                        margin="dense"
                        id="price"
                        label="Опт"
                        onChange={handleChange}
                        value={prices.price}
                        type="text"
                    />
                    <br/>
                    <br/>
                    <DialogContentText>
                        Націнка: {row.number} <br/>
                    </DialogContentText>
                    <TextField
                        name="discount"
                        margin="dense"
                        id="discount"
                        label="Знижка"
                        onChange={handleChange}
                        value={prices.discount}
                        type="text"
                    />
                    <br/>
                    <TextField
                        name="retail"
                        margin="dense"
                        id="retail"
                        label="Роздріб"
                        onChange={handleChange}
                        value={prices.retail}
                        type="text"
                    />
                </DialogContent>
                <DialogActions>
                    <Button onClick={onClose} color="primary">
                        Відміна
                    </Button>
                    <Button type="submit" color="primary">
                        Встановити
                    </Button>
                </DialogActions>
            </form>
        </Dialog>
    );
}


export default EditPriceDialog;