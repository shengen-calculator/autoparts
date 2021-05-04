import React from "react";
import AppBar from '@material-ui/core/AppBar';
import {withStyles} from '@material-ui/core/styles';
import ukLocale from "date-fns/locale/uk";
import DateFnsUtils from '@date-io/date-fns';
import {
    MuiPickersUtilsProvider,
} from '@material-ui/pickers';
import Tab from '@material-ui/core/Tab';
import Tabs from '@material-ui/core/Tabs';
import Copyright from '../Copyright';
import PaymentContent from './payment/Content';
import ReturnContent from './return/Content';
import SalesContent from './sales/Content';
import {Route, Switch} from "react-router-dom";
import PageNotFound from "../../PageNotFound";
import { Link as RouterLink } from 'react-router-dom';
import SearchToolbar from "../../client/SearchToolbar";
import Progress from "../Progress";
import LoginToolbar from "../LoginToolbar";
import Toolbar from "@material-ui/core/Toolbar";

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
    contentWrapper: {
        margin: '40px 16px'
    }
});

function Content({setStatisticPeriod, ...props}) {
    const {classes, handleDrawerToggle} = props;

    const tabs = [
        {
            id: 'sales',
            name: 'Продажі'
        },
        {
            id: 'return',
            name: 'Повернення'
        },
        {
            id: 'payment',
            name: 'Оплати'
        }
    ];
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
                    <Toolbar />
                    <Tabs value={index > 0 ? index : 0} textColor="inherit">
                        {tabs.map(({id, name }) => (
                            <Tab key={id}
                                 textColor="inherit"
                                 label={name}
                                 component={RouterLink}
                                 to={`/history/${id}`} />
                        ))}
                    </Tabs>
                    <Progress />
                </AppBar>
                <main className={classes.main}>
                    <Switch>
                        <Route exact path={`/history`}>
                            <SalesContent/>
                        </Route>
                        <Route exact path={`/history/sales`}>
                            <SalesContent/>
                        </Route>
                        <Route exact path={`/history/return`}>
                            <ReturnContent/>
                        </Route>
                        <Route exact path={`/history/payment`}>
                            <PaymentContent/>
                        </Route>
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


export default withStyles(styles)(Content);
