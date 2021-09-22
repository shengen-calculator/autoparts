import Toolbar from "@material-ui/core/Toolbar";
import Grid from "@material-ui/core/Grid";
import SearchIcon from "@material-ui/icons/Search";
import TextField from "@material-ui/core/TextField";
import Tooltip from "@material-ui/core/Tooltip";
import IconButton from "@material-ui/core/IconButton";
import SendIcon from "@material-ui/icons/Send";
import EuroIcon from "@material-ui/icons/Euro";
import Visibility from "@material-ui/icons/Visibility";
import VisibilityOff from "@material-ui/icons/VisibilityOff";
import React, {useState} from "react";
import {withStyles} from "@material-ui/core/styles";
import ContentStyle from "../common/ContentStyle";
import {useHistory} from "react-router-dom";
import {connect} from "react-redux";
import {removeSpecialCharacters} from "../../util/Search";
import {getCurrencyRate, hideClientPrice, showClientPrice} from "../../redux/actions/clientActions";
import CityDelivery from "./CityDelivery";

const styles = theme => ContentStyle(theme);

function SearchToolbar({client, getCurrencyRate, showClientPrice, hideClientPrice, ...props}) {
    const {classes} = props;

    const [criteria, setCriteria] = useState({
        vip: '',
        number: ''
    });

    let history = useHistory();

    function searchKeyPress(target) {
        if (target.charCode === 13 || target.type === 'click') {
            const {number} = criteria;
            setCriteria(prev => ({
                ...prev,
                number: ''
            }));
            if (number) {
                const shortNumber = removeSpecialCharacters(number);
                history.push(`/search/${shortNumber}`);
            }
        }
    }

    function handleChange(event) {
        const {name, value} = event.target;
        setCriteria(prev => ({
            ...prev,
            [name]: value.trim()
        }));

    }

    return (
        <Toolbar>
            <Grid container spacing={2} alignItems="center">
                <Grid item>
                    <SearchIcon className={classes.block} color="inherit"/>
                </Grid>
                <Grid item xs>
                    <TextField
                        fullWidth
                        placeholder="Введіть номер артикула"
                        onChange={handleChange}
                        onKeyPress={searchKeyPress}
                        name="number"
                        value={criteria.number}
                        InputProps={{
                            className: classes.searchInput,
                        }}
                    />
                </Grid>
                <Grid item>
                    <Tooltip title="Розпочати пошук">
                        <IconButton onClick={searchKeyPress}>
                            <SendIcon
                                className={classes.block}
                                color="inherit"
                            />
                        </IconButton>
                    </Tooltip>
                </Grid>
                <Grid item xs>
                </Grid>
                {
                    client.isPriceShown ?
                        <Grid item>
                            <Tooltip title="Приховати ціну клієнта">
                                <IconButton color="inherit" onClick={() => {
                                    hideClientPrice();
                                }}>
                                    <VisibilityOff/>
                                </IconButton>
                            </Tooltip>
                        </Grid> :
                        <Grid item>
                            <Tooltip title="Показати ціну клієнта">
                                <IconButton color="inherit" onClick={() => {
                                    showClientPrice();
                                }}>
                                    <Visibility/>
                                </IconButton>
                            </Tooltip>
                        </Grid>
                }

                <Grid item>
                    <Tooltip title="Актуальні курси основних валют">
                        <IconButton color="inherit" onClick={() => {
                            getCurrencyRate();
                        }}>
                            <EuroIcon/>
                        </IconButton>
                    </Tooltip>
                </Grid>
                {
                    client.isCityDeliveryUsed &&
                    <Grid item>
                        <CityDelivery/>
                    </Grid>
                }
            </Grid>
        </Toolbar>
    )
}

function mapStateToProps(state) {
    return {
        client: state.client
    }
}

// noinspection JSUnusedGlobalSymbols
const mapDispatchToProps = {
    getCurrencyRate,
    showClientPrice,
    hideClientPrice
};

export default connect(mapStateToProps, mapDispatchToProps)(withStyles(styles)(SearchToolbar));