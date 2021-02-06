import Toolbar from "@material-ui/core/Toolbar";
import Grid from "@material-ui/core/Grid";
import SearchIcon from "@material-ui/icons/Search";
import TextField from "@material-ui/core/TextField";
import Tooltip from "@material-ui/core/Tooltip";
import IconButton from "@material-ui/core/IconButton";
import SendIcon from "@material-ui/icons/Send";
import EuroIcon from "@material-ui/icons/Euro";
import React, {useState} from "react";
import {withStyles} from "@material-ui/core/styles";
import ContentStyle from "../common/ContentStyle";
import {useHistory} from "react-router-dom";
import {connect} from "react-redux";
import {removeSpecialCharacters} from "../../util/Search";
import {getCurrencyRate} from "../../redux/actions/clientActions";
import LocalCafeIcon from '@material-ui/icons/LocalCafe';
import PowerSettingsNewIcon from '@material-ui/icons/PowerSettingsNew';
import {updateApplicationState} from "../../redux/actions/applicationActions";

const styles = theme => ContentStyle(theme);

function SearchToolbar({
                           client,
                           appState,
                           getCurrencyRate,
                           updateApplicationState,
                           ...props
                       }) {
    const {classes} = props;

    const [criteria, setCriteria] = useState({
        vip: '',
        number: ''
    });

    let history = useHistory();

    function loadClientKeyPress(target) {
        if (target.charCode === 13 || target.type === 'click') {
            const {vip} = criteria;
            setCriteria(prev => ({
                ...prev,
                vip: ''
            }));
            if (vip) {
                history.push(`/manager/search/${vip}`);
            }
        }
    }

    function searchKeyPress(target) {
        if (target.charCode === 13 || target.type === 'click') {
            const {number} = criteria;
            setCriteria(prev => ({
                ...prev,
                number: ''
            }));
            if (number) {
                const shortNumber = removeSpecialCharacters(number);
                history.push(`/manager/search/${client.vip}/${shortNumber}`);
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
                <Grid item>
                    <SearchIcon className={classes.block} color="inherit"/>
                </Grid>
                <Grid item xs>
                    <TextField
                        fullWidth
                        placeholder="Введіть код клієнта"
                        onChange={handleChange}
                        onKeyPress={loadClientKeyPress}
                        name="vip"
                        value={criteria.vip}
                        InputProps={{
                            className: classes.searchInput,
                        }}
                    />
                </Grid>
                <Grid item>
                    <Tooltip title="Розпочати пошук">
                        <IconButton onClick={loadClientKeyPress}>
                            <SendIcon className={classes.block} color="inherit"/>
                        </IconButton>
                    </Tooltip>
                </Grid>
                {
                    appState.isSearchPaused ?
                        <Grid item>
                            <Tooltip title="Відновити роботу пошукових модулів">
                                <IconButton color="inherit" onClick={() => {
                                    updateApplicationState({
                                        ...appState,
                                        isSearchPaused: false
                                    });
                                }}>
                                    <LocalCafeIcon/>
                                </IconButton>
                            </Tooltip>
                        </Grid> :
                        <Grid item>
                            <Tooltip title="Призупинити роботу пошукових модулів">
                                <IconButton color="inherit" onClick={() => {
                                    updateApplicationState({
                                        ...appState,
                                        isSearchPaused: true
                                    });
                                }}>
                                    <PowerSettingsNewIcon/>
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
            </Grid>
        </Toolbar>
    )
}

function mapStateToProps(state) {
    return {
        client: state.client,
        appState: state.appState
    }
}

// noinspection JSUnusedGlobalSymbols
const mapDispatchToProps = {
    getCurrencyRate,
    updateApplicationState,
};

export default connect(mapStateToProps, mapDispatchToProps)(withStyles(styles)(SearchToolbar));