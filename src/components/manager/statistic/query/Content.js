import React from 'react';
import PropTypes from 'prop-types';
import Typography from '@material-ui/core/Typography';
import Paper from '@material-ui/core/Paper';
import Grid from '@material-ui/core/Grid';
import { withStyles } from '@material-ui/core/styles';
import MainTable from './MainTable';
import DetailsTable from './DetailsTable';
import ContentStyle from "../ContentStyle";

const styles = theme => ContentStyle(theme);

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
