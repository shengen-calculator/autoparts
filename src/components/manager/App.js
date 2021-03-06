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
import {connect} from "react-redux";

const drawerWidth = 256;

const styles = theme => ({
    root: {
        display: 'flex',
        minHeight: '100vh',
    },
    drawer: {
        [theme.breakpoints.up('xl')]: {
            width: drawerWidth,
            flexShrink: 0,
        },
    }
});

function App({client, product, ...props}) {
    const {classes, match} = props;
    const [mobileOpen, setMobileOpen] = React.useState(false);

    const handleDrawerToggle = () => {
        setMobileOpen(!mobileOpen);
    };

    return (
            <div className={classes.root}>
                <CssBaseline/>
                <nav className={classes.drawer}>
                    <Hidden xlUp implementation="js">
                        <Navigator
                            PaperProps={{style: {width: drawerWidth}}}
                            variant="temporary"
                            vip={client.vip}
                            brand={product.criteria.brand}
                            numb={product.criteria.numb}
                            fullName={client.fullName}
                            open={mobileOpen}
                            onClose={handleDrawerToggle}
                        />
                    </Hidden>
                    <Hidden lgDown implementation="css">
                        <Navigator
                            PaperProps={{style: {width: drawerWidth}}}
                            vip={client.vip}
                            brand={product.criteria.brand}
                            numb={product.criteria.numb}
                            fullName={client.fullName}
                        />
                    </Hidden>
                </nav>
                <Switch>
                    <Route path={`${match.path}/order/:vip`}>
                        <OrderContent handleDrawerToggle={handleDrawerToggle}/>
                    </Route>
                    <Route path={`${match.path}/statistic`}>
                        <StatisticContent match={match} handleDrawerToggle={handleDrawerToggle}/>
                    </Route>
                    <Route path={`${match.path}/payment/:vip`}>
                        <PaymentContent handleDrawerToggle={handleDrawerToggle}/>
                    </Route>
                    <Route exact path={`${match.path}/search/:vip`}>
                        <SearchContent handleDrawerToggle={handleDrawerToggle}/>
                    </Route>
                    <Route exact path={`${match.path}/search/:vip/:numb`}>
                        <SearchContent handleDrawerToggle={handleDrawerToggle}/>
                    </Route>
                    <Route exact path={`${match.path}/search/:vip/:numb/:brand`}>
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

function mapStateToProps(state) {
    return {
        client: state.client,
        product: state.product
    }
}

export default connect(mapStateToProps)(withStyles(styles)(App));
