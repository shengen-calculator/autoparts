import React from 'react';
import PropTypes from 'prop-types';
import {Switch, Route} from "react-router-dom";
import { withStyles } from '@material-ui/core/styles';
import CssBaseline from '@material-ui/core/CssBaseline';
import Hidden from '@material-ui/core/Hidden';
import Navigator from './Navigator';
import SearchContent from './search/Content';
import OrderContent from './order/Content';
import PaymentContent from './payment/Content';
import StatisticContent from './statistic/Content';
import Header from './Header';
import PageNotFound from "../PageNotFound";
import Copyright from "../common/Copyright";

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
  },
  app: {
    flex: 1,
    display: 'flex',
    flexDirection: 'column',
  },
  main: {
    flex: 1,
    padding: theme.spacing(6, 4),
    background: '#eaeff1',
  },
  footer: {
    padding: theme.spacing(2),
    background: '#eaeff1',
  },
});

function App(props) {
  const {classes} = props;
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
        <div className={classes.app}>
          <Header onDrawerToggle={handleDrawerToggle}/>
          <main className={classes.main}>
            <Switch>
              <Route path={`/order`}>
                <OrderContent/>
              </Route>
              <Route path={`/statistic`}>
                <StatisticContent/>
              </Route>
              <Route path={`/payment`}>
                <PaymentContent/>
              </Route>
              <Route exact path={`/search`}>
                <SearchContent/>
              </Route>
              <Route exact path={`/`}>
                <SearchContent/>
              </Route>
              <Route component={PageNotFound}/>
            </Switch>
          </main>
          <footer className={classes.footer}>
            <Copyright/>
          </footer>
        </div>
      </div>
  );
}

App.propTypes = {
  classes: PropTypes.object.isRequired,
};

export default withStyles(styles)(App);
