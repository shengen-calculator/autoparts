import Toolbar from "@material-ui/core/Toolbar";
import Grid from "@material-ui/core/Grid";
import SearchIcon from "@material-ui/icons/Search";
import TextField from "@material-ui/core/TextField";
import Tooltip from "@material-ui/core/Tooltip";
import IconButton from "@material-ui/core/IconButton";
import SendIcon from "@material-ui/icons/Send";
import React from "react";
import {withStyles} from "@material-ui/core/styles";
import ContentStyle from "./statistic/ContentStyle";

const styles = theme => ContentStyle(theme);

function SearchToolbar(props) {
    const {classes} = props;
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
                        InputProps={{
                            className: classes.searchInput,
                        }}
                    />
                </Grid>
                <Grid item>
                    <Tooltip title="Розпочати пошук">
                        <IconButton>
                            <SendIcon className={classes.block} color="inherit"/>
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
                        InputProps={{
                            className: classes.searchInput,
                        }}
                    />
                </Grid>
                <Grid item>
                    <Tooltip title="Розпочати пошук">
                        <IconButton>
                            <SendIcon className={classes.block} color="inherit"/>
                        </IconButton>
                    </Tooltip>
                </Grid>
            </Grid>
        </Toolbar>
    )
}

export default withStyles(styles)(SearchToolbar);