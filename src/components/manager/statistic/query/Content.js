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
    getClientStatistic,
} from "../../../../redux/actions/clientActions";
import {connect} from "react-redux";
import {setStatisticPeriod} from "../../../../redux/actions/statisticActions";
import {useHistory, useParams} from "react-router-dom";
import {Helmet} from "react-helmet";
import {formatDate} from "../../../../util/Formatter";

const styles = theme => ContentStyle(theme);

function Content({stat, getClientStatistic, setStatisticPeriod, ...props}) {
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

    const statByClient = vip ?
        stat.statisticByClient.filter(x => x.vip === vip) : [];

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
                            Замовлень: {stat.queryStatistic.orderTotal}
                        </Typography>
                    </Grid>
                    <Grid item xs={4}>
                        <Typography color="textSecondary" align="center">
                            Резервів: {stat.queryStatistic.reserveTotal}
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
                            <DetailsTable statisticByClient={statByClient}/>
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
    getClientStatistic,
    setStatisticPeriod
};

function mapStateToProps(state) {
    return {
        stat: state.statistic
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(withStyles(styles)(Content));