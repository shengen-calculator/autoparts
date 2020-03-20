import Toolbar from "@material-ui/core/Toolbar";
import Grid from "@material-ui/core/Grid";
import SearchIcon from "@material-ui/icons/Search";
import TextField from "@material-ui/core/TextField";
import Tooltip from "@material-ui/core/Tooltip";
import IconButton from "@material-ui/core/IconButton";
import SendIcon from "@material-ui/icons/Send";
import React, {useState} from "react";
import {withStyles} from "@material-ui/core/styles";
import ContentStyle from "./statistic/ContentStyle";
import {useHistory} from "react-router-dom";
import {connect} from "react-redux";

const styles = theme => ContentStyle(theme);

function SearchToolbar({client, ...props}) {
    const {classes} = props;

    const [criteria, setCriteria] = useState({
        vip: '',
        number: ''
    });

    let history = useHistory();

    function loadClientKeyPress(target) {
        if(target.charCode === 13 || target.type === 'click') {
            const { vip } = criteria;
            setCriteria(prev => ({
                ...prev,
                vip: ''
            }));
            history.push(`/manager/search/${vip}`);
        }
    }

    function searchKeyPress(target) {
        if(target.charCode === 13 || target.type === 'click') {
            const { number } = criteria;
            setCriteria(prev => ({
                ...prev,
                number: ''
            }));
            history.push(`/manager/search/${client.vip}/${number}`);
        }
    }

    function handleChange(event) {
        const { name, value } = event.target;
        setCriteria(prev => ({
            ...prev,
            [name]: value
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
            </Grid>
        </Toolbar>
    )
}

function mapStateToProps(state) {
    return {
        client: state.client
    }
}

export default connect(mapStateToProps)(withStyles(styles)(SearchToolbar));