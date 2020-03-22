import React from 'react';
import PropTypes from 'prop-types';
import Typography from '@material-ui/core/Typography';
import Paper from '@material-ui/core/Paper';
import Grid from '@material-ui/core/Grid';
import { withStyles } from '@material-ui/core/styles';
import MainTable from './MainTable';
import DetailsTable from './DetailsTable';
import ContentStyle from "../ContentStyle";
import {
    getStatisticByClient,
    getClientStatistic,
    getQueryStatistic
} from "../../../../redux/actions/clientActions";
import {connect} from "react-redux";
import {useMountEffect} from "../../../common/UseMountEffect";

const styles = theme => ContentStyle(theme);

function Content({statistic, getStatisticByClient, getClientStatistic, getQueryStatistic, ...props}) {
    const {classes, startDate, endDate} = props;

    useMountEffect(() => {
        getClientStatistic({startDate, endDate});
        getQueryStatistic({startDate, endDate});
    });

    function onClientSelect(vip) {
        getStatisticByClient({startDate, endDate, vip});
    }

    return (
        <Paper className={classes.paper}>
            <div className={classes.contentWrapper}>
                <Grid container spacing={2} alignItems="center">
                    <Grid item xs={3}>
                        <Typography color="textSecondary" align="center">
                            Замовлень: {statistic.queryStatistic.orderTotal} ({statistic.queryStatistic.order})
                        </Typography>
                    </Grid>
                    <Grid item xs={3}>
                        <Typography color="textSecondary" align="center">
                            Резервів: {statistic.queryStatistic.reserveTotal} ({statistic.queryStatistic.reserve})
                        </Typography>
                    </Grid>
                    <Grid item xs={3}>
                        <Typography color="textSecondary" align="center">
                            Реєстрацій: {statistic.queryStatistic.registration}
                        </Typography>
                    </Grid>
                    <Grid item xs={3}>
                        <Typography color="textSecondary" align="center">
                            Всього запитів: {statistic.queryStatistic.queryTotal}
                        </Typography>
                    </Grid>
                </Grid>
            </div>
            <div className={classes.contentWrapper}>
                <Grid container spacing={2} alignItems="center">
                    <Grid item xs={5}>
                        <MainTable clientStatistic={statistic.clientStatistic} onSelect={onClientSelect}/>
                    </Grid>
                    <Grid item xs={7}>
                        <DetailsTable statisticByClient={statistic.statisticByClient}/>
                    </Grid>
                </Grid>
            </div>
        </Paper>
    );
}


Content.propTypes = {
    classes: PropTypes.object.isRequired,
};

// noinspection JSUnusedGlobalSymbols
const mapDispatchToProps = {
    getStatisticByClient,
    getClientStatistic,
    getQueryStatistic
};

function mapStateToProps(state) {
    return {
        statistic: state.statistic
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(withStyles(styles)(Content));