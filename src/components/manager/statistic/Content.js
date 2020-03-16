import React from "react";
import PropTypes from 'prop-types';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Grid from '@material-ui/core/Grid';
import Tooltip from '@material-ui/core/Tooltip';
import IconButton from '@material-ui/core/IconButton';
import {withStyles} from '@material-ui/core/styles';
import ukLocale from "date-fns/locale/uk";
import EqualizerIcon from '@material-ui/icons/Equalizer';
import DateFnsUtils from '@date-io/date-fns';
import {
    MuiPickersUtilsProvider,
    KeyboardDatePicker,
} from '@material-ui/pickers';
import Tab from '@material-ui/core/Tab';
import Tabs from '@material-ui/core/Tabs';
import Copyright from '../../common/Copyright';
import SendIcon from "@material-ui/icons/Send";
import QueryContent from './query/Content';
import VendorContent from './vendor/Сontent';
import {Route, Switch} from "react-router-dom";
import PageNotFound from "../../PageNotFound";
import { Link as RouterLink } from 'react-router-dom';
import LinearProgress from "@material-ui/core/LinearProgress";
import LoginToolbar from "../LoginToolbar";
import SearchToolbar from "../SearchToolbar";

const tabs = [
    {id: 'vendor', name: 'Постачальники', page: <VendorContent/>},
    {id: 'query', name: 'Запити клієнтів', page: <QueryContent/>}
];

const styles = theme => ({
    root: {
        display: 'flex',
        minHeight: '100vh'
    },

    app: {
        flex: 1,
        display: 'flex',
        flexDirection: 'column'
    },
    main: {
        flex: 1,
        padding: theme.spacing(1, 2),
        background: '#eaeff1'
    },
    footer: {
        padding: theme.spacing(4),
        background: '#eaeff1'
    },
    paper: {
        margin: 'auto',
        overflow: 'hidden'
    },
    searchBar: {
        borderBottom: '1px solid rgba(0, 0, 0, 0.12)'
    },
    searchInput: {
        fontSize: theme.typography.fontSize
    },
    block: {
        display: 'block'
    },
    addUser: {
        marginRight: theme.spacing(1)
    },
    contentWrapper: {
        margin: '40px 16px'
    }
});

function Content(props) {
    const {classes, match, handleDrawerToggle} = props;
    const index = tabs.findIndex(tab => window.location.href.includes(tab.id));

    return (
        <MuiPickersUtilsProvider utils={DateFnsUtils} locale={ukLocale}>
            <div className={classes.app}>
                <AppBar color="primary" position="sticky" elevation={0}>
                    <LoginToolbar onDrawerToggle={handleDrawerToggle}/>
                    <SearchToolbar/>
                </AppBar>
                <AppBar
                    component="div"
                    className={classes.secondaryBar}
                    color="primary"
                    position="sticky"
                    elevation={0}
                >
                    <Toolbar>
                        <Grid container spacing={2} alignItems="center">
                            <Grid item>
                                <EqualizerIcon className={classes.block} color="inherit"/>
                            </Grid>
                            <Grid item xs={2} sm={3} md={3} lg={2} xl={1}>
                                <KeyboardDatePicker
                                    margin="normal"
                                    id="date-picker-start"
                                    label="Починаючи з"
                                    format="dd/MM/yyyy"
                                    // value={selectedDate}
                                    // onChange={handleDateChange}
                                    KeyboardButtonProps={{
                                        'aria-label': 'change date',
                                    }}
                                />
                            </Grid>

                            <Grid item>
                                <EqualizerIcon className={classes.block} color="inherit"/>
                            </Grid>
                            <Grid item xs={3} sm={3} md={3} lg={2} xl={1}>
                                <KeyboardDatePicker
                                    margin="normal"
                                    id="date-picker-end"
                                    label="до"
                                    format="dd/MM/yyyy"
                                    // value={selectedDate}
                                    // onChange={handleDateChange}
                                    KeyboardButtonProps={{
                                        'aria-label': 'change date',
                                    }}
                                />
                            </Grid>
                            <Grid item xs={1}>
                                <Tooltip title="Розпочати пошук">
                                    <IconButton>
                                        <SendIcon className={classes.block} color="inherit"/>
                                    </IconButton>
                                </Tooltip>
                            </Grid>
                        </Grid>
                    </Toolbar>
                    <Tabs value={index > 0 ? index : 0} textColor="inherit">
                        {tabs.map(({id, name }) => (
                            <Tab key={id}
                                 textColor="inherit"
                                 label={name}
                                 component={RouterLink}
                                 to={`${match.path}/statistic/${id}`} />
                        ))}
                   </Tabs>
                   <LinearProgress />
                </AppBar>
                <main className={classes.main}>
                    <Switch>
                        <Route exact path={`${match.path}/statistic/`}>
                            {tabs[0].page}
                        </Route>
                        {tabs.map(({id, page }) => (
                            <Route key={id} path={`${match.path}/statistic/${id}`}>
                                {page}
                            </Route>
                        ))}
                        <Route component={PageNotFound}/>
                    </Switch>
                </main>
                <footer className={classes.footer}>
                    <Copyright/>
                </footer>
            </div>
        </MuiPickersUtilsProvider>
    );
}


Content.propTypes = {
    classes: PropTypes.object.isRequired,
};

export default withStyles(styles)(Content);
