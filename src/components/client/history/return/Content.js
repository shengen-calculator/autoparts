import React from 'react';
import Typography from '@material-ui/core/Typography';
import Paper from '@material-ui/core/Paper';
import { withStyles } from '@material-ui/core/styles';
import ContentStyle from "../../../common/ContentStyle";
import {Helmet} from "react-helmet";

const styles = theme => ContentStyle(theme);

function Content({stat, getClientStatistic, setStatisticPeriod, ...props}) {
    const {classes} = props;

    return (
        <Paper className={classes.paper}>
            <Helmet>
                <title>Fenix - Історія повернень</title>
            </Helmet>
            <div className={classes.contentWrapper}>
                <Typography color="textSecondary" align="center">
                    Історія повернень
                </Typography>
            </div>
        </Paper>
    );
}

export default withStyles(styles)(Content);