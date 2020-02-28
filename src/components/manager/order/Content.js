import React from 'react';
import PropTypes from 'prop-types';
import AppBar from '@material-ui/core/AppBar';
import Paper from '@material-ui/core/Paper';
import {withStyles} from '@material-ui/core/styles';
import OrderTable from "./OrderTable";
import ReserveTable from "./ReserveTable";
import Header from "../Header";
import Copyright from "../Copyright";

const styles = theme => ({
    paper: {
        margin: 'auto',
        overflow: 'hidden',
    },
    app: {
        flex: 1,
        display: 'flex',
        flexDirection: 'column'
    },
    contentWrapper: {
        margin: '40px 16px',
    },
    main: {
        flex: 1,
        padding: theme.spacing(1, 2),
        background: '#eaeff1'
    },
    footer: {
        padding: theme.spacing(4),
        background: '#eaeff1'
    }
});

function Content(props) {
    const {classes, handleDrawerToggle} = props;

    return (
        <div className={classes.app}>
            <Header onDrawerToggle={handleDrawerToggle}/>
            <main className={classes.main}>
                <Paper className={classes.paper}>
                    <AppBar className={classes.searchBar} position="static" color="default" elevation={0}/>
                    <div className={classes.contentWrapper}>
                        {/*<Typography color="textSecondary" align="center">
                      По Вашему запросу ничего не найдено
                  </Typography>*/
                        }
                        <OrderTable/>
                        <ReserveTable/>
                    </div>
                </Paper>
            </main>
            <footer className={classes.footer}>
                <Copyright/>
            </footer>
        </div>
    );

}

Content.propTypes = {
    classes: PropTypes.object.isRequired,
};

export default withStyles(styles)(Content);