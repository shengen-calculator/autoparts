import Dialog from "@material-ui/core/Dialog";
import DialogTitle from "@material-ui/core/DialogTitle";
import React from "react";
import DialogContent from "@material-ui/core/DialogContent";
import DialogActions from "@material-ui/core/DialogActions";
import Button from "@material-ui/core/Button";
import Select from 'react-select';
import {makeStyles} from "@material-ui/core/styles";

const useStyles = makeStyles(theme => ({
    dialog: {
        minHeight: 240
    }
}));

function FilterDialog(props) {
    const {isOpened, onClose, brands} = props;
    const classes = useStyles();
    const [filter, setFilter] = React.useState({
        selectedBrands: []
    });

    const handleChangeBrandFilter = selectedOption => {
        setFilter({selectedBrands: selectedOption});
    };

    return (
        <div>
            <Dialog open={isOpened} aria-labelledby="form-dialog-title" onClose={onClose} maxWidth="xl">
                <DialogTitle id="form-dialog-title">Фільтрувати аналоги артикула за параметрами</DialogTitle>
                <DialogContent className={classes.dialog}>
                    <Select
                        value={filter.selectedBrands}
                        onChange={handleChangeBrandFilter}
                        maxMenuHeight={150}
                        options={brands ? brands.map(x => {return{value: x, label: x}}) : []}
                        isMulti
                    />
                    <br/>
                </DialogContent>
                <DialogActions>
                    <Button onClick={onClose} color="primary">
                        Відміна
                    </Button>
                    <Button type="submit" color="primary">
                        Фільтрувати
                    </Button>
                </DialogActions>
            </Dialog>
        </div>
    );
}

export default FilterDialog;