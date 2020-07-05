import React, {useEffect, useState} from "react";
import Dialog from "@material-ui/core/Dialog";
import DialogTitle from "@material-ui/core/DialogTitle";
import DialogActions from "@material-ui/core/DialogActions";
import Button from "@material-ui/core/Button";
import DialogContentText from "@material-ui/core/DialogContentText";
import DialogContent from "@material-ui/core/DialogContent";
import TextField from "@material-ui/core/TextField";



function EditPriceDialog(props) {
    const {isOpened, onClose, row, updatePrice} = props;
    const [prices, setPrices] = useState({});

    useEffect(() => {
        setPrices({
            price: row.price ? row.price : '',
            discount: row.discount ? row.discount : '',
            retail: row.retail ? row.retail : ''
        })
    }, [row]);

    function handleUpdatePriceClick(event) {
        event.preventDefault();
        updatePrice(event);
    }

    function handleChange(event) {
        const {name, value} = event.target;
        setPrices(prev => ({
            ...prev,
            [name]: value
        }));
    }

    return (
        <Dialog open={isOpened} aria-labelledby="form-dialog-title" onClose={onClose}>
            <DialogTitle id="form-dialog-title">{row.vendor} - {row.brand} - {row.number}</DialogTitle>
            <form onSubmit={handleUpdatePriceClick}>
                <DialogContent>
                    <DialogContentText>
                        {row['purchasePrice'] && <span>Вхідна ціна: {row['purchasePrice']}</span>}
                        {row['purchasePrice'] && <br/>}
                        {row['vendorPrice'] && <span>Ціна постачальника: {row['vendorPrice']}</span>}
                        {row['vendorPrice'] && <br/>}
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
                    {(row.price && row['purchasePrice']) && <br/>}
                    {(row.price && row['purchasePrice']) && <DialogContentText>
                        Націнка: {(prices.price && row['purchasePrice']) ? (prices.price/row['purchasePrice']).toFixed(2) : ''} <br/>
                    </DialogContentText>}
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
                        value={(prices.price / (100 - prices.discount) * 100).toFixed(2)}
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