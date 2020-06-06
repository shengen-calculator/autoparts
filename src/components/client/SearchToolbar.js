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

const styles = theme => ContentStyle(theme);

function SearchToolbar({client, ...props}) {
    const {classes} = props;

    const [criteria, setCriteria] = useState({
        vip: '',
        number: ''
    });

    let history = useHistory();

    function searchKeyPress(target) {
        if(target.charCode === 13 || target.type === 'click') {
            const { number } = criteria;
            setCriteria(prev => ({
                ...prev,
                number: ''
            }));
            if(number) {
                const shortNumber = removeSpecialCharacters(number);
                history.push(`/search/${shortNumber}`);
            }
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
                <Grid item xs>
                </Grid>
                <Grid item>
                    <Tooltip title="Актуальні курси основних валют">
                        <IconButton color="inherit" onClick={() => {
                            alert("3.80")
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
        client: state.client
    }
}

export default connect(mapStateToProps)(withStyles(styles)(SearchToolbar));