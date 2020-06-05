import Toolbar from "@material-ui/core/Toolbar";
import Grid from "@material-ui/core/Grid";
import Hidden from "@material-ui/core/Hidden";
import IconButton from "@material-ui/core/IconButton";
import MenuIcon from "@material-ui/icons/Menu";
import Tooltip from "@material-ui/core/Tooltip";
import ExitToAppIcon from "@material-ui/icons/ExitToApp";
import React from "react";
import {connect} from "react-redux";
import {withStyles} from "@material-ui/core/styles";
import {logoutRequest} from "../../redux/actions/authenticationActions";
import ContentStyle from "./ContentStyle";
import {RoleEnum} from "../../util/Enums";

const styles = theme => ContentStyle(theme);

function LoginToolbar({logoutRequest, auth, ...props}) {
    const {classes, onDrawerToggle} = props;
    return (
        <Toolbar>
            <Grid container spacing={1} alignItems="center">
                <Hidden xlUp>
                    <Grid item>
                        <IconButton
                            color="inherit"
                            aria-label="open drawer"
                            onClick={onDrawerToggle}
                            className={classes.menuButton}
                        >
                            <MenuIcon/>
                        </IconButton>
                    </Grid>
                </Hidden>
                <Grid item xs/>
                <Grid item>
                    { auth.role === RoleEnum.Manager ? auth.vip : `K0000${auth.vip}`}
                </Grid>
                <Grid item>
                    <Tooltip title="Вийти">
                        <IconButton color="inherit" onClick={() => {
                            logoutRequest();
                        }}>
                            <ExitToAppIcon/>
                        </IconButton>
                    </Tooltip>
                </Grid>


            </Grid>
        </Toolbar>
    )
}

function mapStateToProps(state) {
    return {
        auth: state.authentication
    }
}

// noinspection JSUnusedGlobalSymbols
const mapDispatchToProps = {
    logoutRequest
};

export default connect(mapStateToProps, mapDispatchToProps)(withStyles(styles)(LoginToolbar));