import React, {useEffect} from "react";
import { Route, Switch } from "react-router-dom";
import ClientPage from "./client/App";
import ManagerPage from "./manager/App";
import Auth from "./auth/Auth";
import {createTheme, ThemeProvider } from '@material-ui/core/styles';
import { ukUA } from '@material-ui/core/locale';
import PrivateRoute from "./common/PrivateRoute";
import {connect} from "react-redux";
import {RoleEnum} from "../util/Enums";
import {
    appStateUpdated,
    subscribeToApplicationStateUpdate,
} from "../redux/actions/applicationActions";


let theme = createTheme({
    palette: {
        primary: {
            light: '#63ccff',
            main: '#009be5',
            dark: '#006db3',
        },
    },
    typography: {
        h5: {
            fontWeight: 500,
            fontSize: 26,
            letterSpacing: 0.5,
        },
    },
    shape: {
        borderRadius: 8,
    },
    props: {
        MuiTab: {
            disableRipple: true,
        },
    },
    mixins: {
        toolbar: {
            minHeight: 48,
        },
    },
}, ukUA);

theme = {
    ...theme,
    overrides: {
        MuiDrawer: {
            paper: {
                backgroundColor: '#18202c',
            },
        },
        MuiButton: {
            label: {
                textTransform: 'none',
            },
            contained: {
                boxShadow: 'none',
                '&:active': {
                    boxShadow: 'none',
                },
            },
        },
        MuiTabs: {
            root: {
                marginLeft: theme.spacing(1),
            },
            indicator: {
                height: 3,
                borderTopLeftRadius: 3,
                borderTopRightRadius: 3,
                backgroundColor: theme.palette.common.white,
            },
        },
        MuiTab: {
            root: {
                textTransform: 'none',
                margin: '0 16px',
                minWidth: 0,
                padding: 0,
                [theme.breakpoints.up('md')]: {
                    padding: 0,
                    minWidth: 0,
                },
            },
        },
        MuiIconButton: {
            root: {
                padding: theme.spacing(1),
            },
        },
        MuiTooltip: {
            tooltip: {
                borderRadius: 4,
            },
        },
        MuiDivider: {
            root: {
                backgroundColor: '#404854',
            },
        },
        MuiListItemText: {
            primary: {
                fontWeight: theme.typography.fontWeightMedium,
            },
        },
        MuiListItemIcon: {
            root: {
                color: 'inherit',
                marginRight: 0,
                '& svg': {
                    fontSize: 20,
                },
            },
        },
        MuiAvatar: {
            root: {
                width: 32,
                height: 32,
            },
        },
    },
};

function App({auth, subscribeToApplicationStateUpdate, appStateUpdated}) {

    useEffect(() => {
        if(auth.vip) {
            subscribeToApplicationStateUpdate(appStateUpdated);
        }
    }, [subscribeToApplicationStateUpdate, appStateUpdated, auth.vip]);

    return (
        <ThemeProvider theme={theme}>
            <div>
                <Switch>
                    <PrivateRoute role={auth.role} only={[RoleEnum.Manager, RoleEnum.Admin]}  path="/manager" component={ManagerPage}/>
                    <Route path="/auth" component={Auth}/>
                    <PrivateRoute role={auth.role} only={[RoleEnum.Manager, RoleEnum.Client, RoleEnum.Admin]} path="/" component={ClientPage}/>
                </Switch>
            </div>
        </ThemeProvider>
    );
}

function mapStateToProps(state) {
    return {
        auth: state.authentication
    }
}

// noinspection JSUnusedGlobalSymbols
const mapDispatchToProps = {
    subscribeToApplicationStateUpdate,
    appStateUpdated
};

export default connect(
    mapStateToProps,
    mapDispatchToProps
)(App);
