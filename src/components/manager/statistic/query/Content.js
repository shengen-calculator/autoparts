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
import MainTable from './MainTable';
import DetailsTable from './DetailsTable';

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
    const {classes} = props;

    return (
        <Paper className={classes.paper}>
            <div className={classes.contentWrapper}>
                <Grid container spacing={2} alignItems="center">
                    <Grid item xs={3}>
                        <Typography color="textSecondary" align="center">
                            Замовлень 245 (99)
                        </Typography>
                    </Grid>
                    <Grid item xs={3}>
                        <Typography color="textSecondary" align="center">
                            Резервів 286 (63)
                        </Typography>
                    </Grid>
                    <Grid item xs={3}>
                        <Typography color="textSecondary" align="center">
                            Реєстрацій 130
                        </Typography>
                    </Grid>
                    <Grid item xs={3}>
                        <Typography color="textSecondary" align="center">
                            Всього запитів 3526
                        </Typography>
                    </Grid>
                </Grid>
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
    );
}


Content.propTypes = {
    classes: PropTypes.object.isRequired,
};

export default withStyles(styles)(Content);
