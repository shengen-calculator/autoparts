import Dialog from "@material-ui/core/Dialog";
import DialogTitle from "@material-ui/core/DialogTitle";
import React from "react";
import DialogContent from "@material-ui/core/DialogContent";
import DialogActions from "@material-ui/core/DialogActions";
import Button from "@material-ui/core/Button";
import Select from 'react-select';
import {makeStyles} from "@material-ui/core/styles";
import Grid from "@material-ui/core/Grid";
import Typography from "@material-ui/core/Typography";
import {QualityEnum, RoleEnum} from "../../../util/Enums";

const useStyles = makeStyles(() => ({
    dialog: {
        minHeight: 340
    },
    managerDialog: {
        minHeight: 425
    }
}));

function FilterDialog(props) {
    const {isOpened, onClose, role, onFilter, brands, cities, terms, qualities, vendors} = props;
    const classes = useStyles();
    const [filter, setFilter] = React.useState({
        selectedBrands: [],
        selectedCities: [],
        selectedTerms: [],
        selectedVendors: [],
        selectedQualities: []
    });

    const handleChangeBrandFilter = selectedOption => {
        setFilter({...filter, selectedBrands: selectedOption});
    };
    const handleChangeCityFilter = selectedOption => {
        setFilter({...filter, selectedCities: selectedOption});
    };
    const handleChangeTermFilter = selectedOption => {
        setFilter({...filter, selectedTerms: selectedOption});
    };
    const handleChangeQualityFilter = selectedOption => {
        setFilter({...filter, selectedQualities: selectedOption});
    };
    const handleChangeVendorFilter = selectedOption => {
        setFilter({...filter, selectedVendors: selectedOption});
    };
    const handleReset = () => {
        setFilter({selectedBrands: [], selectedCities: [], selectedTerms: [], selectedQualities: [], selectedVendors: []});
    };
    const onSubmit = (event) => {
        event.preventDefault();
        onFilter({
            brands: filter.selectedBrands ? filter.selectedBrands : [],
            cities: filter.selectedCities ? filter.selectedCities : [],
            terms: filter.selectedTerms ? filter.selectedTerms : [],
            vendors: filter.selectedVendors ? filter.selectedVendors : [],
            qualities: filter.selectedQualities ? filter.selectedQualities : []
        });
    };

    return (
        <div>
            <Dialog open={isOpened} aria-labelledby="form-dialog-title" onClose={onClose} maxWidth="xl">
                <DialogTitle id="form-dialog-title">Фільтрувати аналоги артикула за параметрами</DialogTitle>
                <form onSubmit={onSubmit}>
                    <DialogContent className={role === RoleEnum.Manager ? classes.managerDialog : classes.dialog}>
                        <Grid container spacing={3}>
                            {role === RoleEnum.Manager &&
                            <Grid item xs={12}>
                                <Typography color="secondary">
                                    Постачальник
                                </Typography>
                                <Select
                                    value={filter.selectedVendors}
                                    onChange={handleChangeVendorFilter}
                                    maxMenuHeight={130}
                                    options={vendors ? vendors.map(x => {
                                        return {value: x, label: x}
                                    }) : []}
                                    isMulti
                                />
                            </Grid>}
                            <Grid item xs={12}>
                                <Typography color="secondary">
                                    Бренд
                                </Typography>
                                <Select
                                    value={filter.selectedBrands}
                                    onChange={handleChangeBrandFilter}
                                    maxMenuHeight={130}
                                    options={brands ? brands.map(x => {
                                        return {value: x, label: x}
                                    }) : []}
                                    isMulti
                                />
                            </Grid>
                            <Grid item xs={12}>
                                <Typography color="secondary">
                                    Якість
                                </Typography>
                                <Select
                                    value={filter.selectedQualities}
                                    onChange={handleChangeQualityFilter}
                                    maxMenuHeight={130}
                                    options={qualities ? qualities.map(x => {
                                        return {value: x, label: QualityEnum[x]}
                                    }) : []}
                                    isMulti
                                />
                            </Grid>
                            <Grid item xs={6}>
                                <Typography color="secondary">
                                    Термін
                                </Typography>
                                <Select
                                    value={filter.selectedTerms}
                                    onChange={handleChangeTermFilter}
                                    maxMenuHeight={75}
                                    options={terms ? terms.map(x => {
                                        return {value: x, label: x}
                                    }) : []}
                                    isMulti
                                />
                            </Grid>
                            <Grid item xs={6}>
                                <Typography color="secondary">
                                    Міcце знаходження
                                </Typography>
                                <Select
                                    value={filter.selectedCities}
                                    onChange={handleChangeCityFilter}
                                    maxMenuHeight={75}
                                    options={cities ? cities.map(x => {
                                        return {value: x, label: x}
                                    }) : []}
                                    isMulti
                                />
                            </Grid>
                        </Grid>
                    </DialogContent>
                    <DialogActions>
                        <Button onClick={onClose} color="primary">
                            Відміна
                        </Button>
                        <Button onClick={handleReset} color="primary">
                            Скинути
                        </Button>
                        <Button type="submit" color="primary">
                            Застосувати
                        </Button>
                    </DialogActions>
                </form>
            </Dialog>
        </div>
    );
}

export default FilterDialog;