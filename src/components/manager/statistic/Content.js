import React from 'react';
import PropTypes from 'prop-types';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
import Paper from '@material-ui/core/Paper';
import Grid from '@material-ui/core/Grid';
import Button from '@material-ui/core/Button';
import TextField from '@material-ui/core/TextField';
import Tooltip from '@material-ui/core/Tooltip';
import IconButton from '@material-ui/core/IconButton';
import { withStyles } from '@material-ui/core/styles';
import ukLocale from "date-fns/locale/uk";
import MainTable from './query/MainTable';
import DetailsTable from './query/DetailsTable';
import EqualizerIcon from '@material-ui/icons/Equalizer';
import DateFnsUtils from '@date-io/date-fns';
import {
    MuiPickersUtilsProvider,
    KeyboardDatePicker,
} from '@material-ui/pickers';
import Tab from '@material-ui/core/Tab';
import Tabs from '@material-ui/core/Tabs';
import Header from '../Header';
import Copyright from '../Copyright';
import SendIcon from "@material-ui/icons/Send";

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
        padding: theme.spacing(6, 4),
        background: '#eaeff1'
    },
    footer: {
        padding: theme.spacing(2),
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
    const {classes, handleDrawerToggle} = props;

    return (
        <MuiPickersUtilsProvider utils={DateFnsUtils} locale={ukLocale}>
        <div className={classes.app}>
        <Header onDrawerToggle={handleDrawerToggle}/>
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
                  <EqualizerIcon className={classes.block} color="inherit" />
              </Grid>
              <Grid item xs={4} sm={4} md={3} lg={2} xl={1}>
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
                  <EqualizerIcon className={classes.block} color="inherit" />
              </Grid>
              <Grid item xs={5} sm={4} md={3} lg={2} xl={1}>
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
              <Grid item xs={1} >
                  <Tooltip title="Розпочати пошук">
                      <IconButton>
                          <SendIcon className={classes.block} color="inherit" />
                      </IconButton>
                  </Tooltip>
              </Grid>
          </Grid>
        </Toolbar>
              <Tabs value={1} textColor="inherit">
                  <Tab textColor="inherit" label="Постачальники" />
                  <Tab textColor="inherit" label="Запити клієнтів" />
              </Tabs>
          </AppBar>
        <main className={classes.main}>
            <Paper className={classes.paper}>
                <AppBar className={classes.searchBar} position="static" color="default" elevation={0}></AppBar>
                <div className={classes.contentWrapper}>
                    <Typography color="textSecondary" align="center">
                        Замовлень 245 (99)
                    </Typography>
                    <Typography color="textSecondary" align="center">
                        Зарезервовано 286 (63)
                    </Typography>
                    <Typography color="textSecondary" align="center">
                        Реєстрацій 130
                    </Typography>
                    <Typography color="textSecondary" align="center">
                        Всього запитів 3526
                    </Typography>
                </div>
                <div className={classes.contentWrapper}>
                <Grid container spacing={2} alignItems="center">
                    <Grid item xs={5}>
                        <MainTable/>
                    </Grid>
                    <Grid item xs={7}>
                        <DetailsTable/>
                    </Grid>
                </Grid>
                </div>
            </Paper>
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
