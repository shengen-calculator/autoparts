import React, {useEffect} from 'react';
import PropTypes from 'prop-types';
import Typography from '@material-ui/core/Typography';
import Paper from '@material-ui/core/Paper';
import Grid from '@material-ui/core/Grid';
import { withStyles } from '@material-ui/core/styles';
import MainTable from './MainTable';
import DetailsTable from './DetailsTable';
import ContentStyle from "../../../common/ContentStyle";
import {
    getStatisticByClient,
    getClientStatistic,
} from "../../../../redux/actions/clientActions";
import {connect} from "react-redux";
import {setStatisticPeriod} from "../../../../redux/actions/statisticActions";
import {useHistory, useParams} from "react-router-dom";
import {Helmet} from "react-helmet";
import {formatDate} from "../../../../util/Formatter";

const styles = theme => ContentStyle(theme);

function Content({stat, getStatisticByClient, getClientStatistic, setStatisticPeriod, ...props}) {
    const {classes} = props;
    const isTableShown = stat && stat.clientStatistic && stat.clientStatistic.length > 0;
    let {vip} = useParams();
    let history = useHistory();

    useEffect(() => {
        if(stat.startDate && stat.endDate){
            getClientStatistic({startDate: formatDate(stat.startDate), endDate: formatDate(stat.endDate)});
        } else {
            setStatisticPeriod({startDate: Date.now(), endDate: Date.now()});
        }
    }, [stat.startDate, stat.endDate, getClientStatistic, setStatisticPeriod]);


    useEffect(() => {
        if(stat.clientStatistic.length && !vip){
            history.replace(`/manager/statistic/query/${stat.clientStatistic[0].vip}`);
        }

    }, [stat.clientStatistic, vip, history]);

    useEffect(() => {
        if(vip && stat.startDate && stat.endDate) {
            getStatisticByClient({startDate: stat.startDate, endDate: stat.endDate, vip: vip});
        }
    }, [vip, getStatisticByClient, stat.startDate, stat.endDate]);

    function onMainTableClick(event, name) {
        history.push(`/manager/statistic/query/${name}`);
    }

    let clientVip = "Не знадейний";
    if(stat.clientStatistic.length) {
        const clientObject = stat.clientStatistic.find(x => x.vip === vip);
        if(clientObject)
            clientVip = clientObject.vip;
    }

    return (
        <Paper className={classes.paper}>
            <Helmet>
                <title>Fenix - Статистика Клієнта - {clientVip}</title>
            </Helmet>
            <div className={classes.contentWrapper}>
                <Grid container spacing={2} alignItems="center">
                    <Grid item xs={4}>
                        <Typography color="textSecondary" align="center">
                            Замовлень: {stat.queryStatistic.orderTotal} ({stat.queryStatistic.order})
                        </Typography>
                    </Grid>
                    <Grid item xs={4}>
                        <Typography color="textSecondary" align="center">
                            Резервів: {stat.queryStatistic.reserveTotal} ({stat.queryStatistic.reserve})
                        </Typography>
                    </Grid>
                    <Grid item xs={4}>
                        <Typography color="textSecondary" align="center">
                            Всього запитів: {stat.queryStatistic.queryTotal}
                        </Typography>
                    </Grid>
                </Grid>
            </div>
            <div className={classes.contentWrapper}>
                {isTableShown ?
                    <Grid container spacing={2} alignItems="center">
                        <Grid item xs={5}>
                            <MainTable clientStatistic={stat.clientStatistic} handleClick={onMainTableClick}/>
                        </Grid>
                        <Grid item xs={7}>
                            <DetailsTable statisticByClient={stat.statisticByClient}/>
                        </Grid>
                    </Grid>
                    :
                    <Typography color="textSecondary" align="center">
                        Інформація відсутня
                    </Typography>
                }

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
    setStatisticPeriod
};

function mapStateToProps(state) {
    return {
        stat: state.statistic
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(withStyles(styles)(Content));