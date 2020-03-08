import React from 'react';
import PropTypes from 'prop-types';
import {withStyles} from '@material-ui/core/styles';
import CssBaseline from '@material-ui/core/CssBaseline';
import Hidden from '@material-ui/core/Hidden';
import Navigator from './Navigator';
import SearchContent from './search/Content';
import OrderContent from './order/Content';
import PaymentContent from './payment/Content';
import StatisticContent from './statistic/Content';
import {Route, Switch} from "react-router-dom";
import PageNotFound from "../PageNotFound";

const drawerWidth = 256;

const styles = theme => ({
    root: {
        display: 'flex',
        minHeight: '100vh',
    },
    drawer: {
        [theme.breakpoints.up('sm')]: {
            width: drawerWidth,
            flexShrink: 0,
        },
    }
});

function App(props) {
    const {classes, match} = props;
    const [mobileOpen, setMobileOpen] = React.useState(false);

    const handleDrawerToggle = () => {
        setMobileOpen(!mobileOpen);
    };

    return (
            <div className={classes.root}>
                <CssBaseline/>
                <nav className={classes.drawer}>
                    <Hidden smUp implementation="js">
                        <Navigator
                            PaperProps={{style: {width: drawerWidth}}}
                            variant="temporary"
                            open={mobileOpen}
                            onClose={handleDrawerToggle}
                        />
                    </Hidden>
                    <Hidden xsDown implementation="css">
                        <Navigator PaperProps={{style: {width: drawerWidth}}}/>
                    </Hidden>
                </nav>
                <Switch>
                    <Route path={`${match.path}/order`}>
                        <OrderContent handleDrawerToggle={handleDrawerToggle}/>
                    </Route>
                    <Route path={`${match.path}/statistic`}>
                        <StatisticContent match={match} handleDrawerToggle={handleDrawerToggle}/>
                    </Route>
                    <Route path={`${match.path}/payment`}>
                        <PaymentContent handleDrawerToggle={handleDrawerToggle}/>
                    </Route>
                    <Route exact path={`${match.path}/search`}>
                        <SearchContent handleDrawerToggle={handleDrawerToggle}/>
                    </Route>
                    <Route exact path={`${match.path}/`}>
                        <SearchContent handleDrawerToggle={handleDrawerToggle}/>
                    </Route>
                    <Route component={PageNotFound}/>
                </Switch>
            </div>
    );
}

App.propTypes = {
    classes: PropTypes.object.isRequired,
};

export default withStyles(styles)(App);
