import React, {useEffect} from 'react';
import PropTypes from 'prop-types';
import Paper from '@material-ui/core/Paper';
import Grid from '@material-ui/core/Grid';
import { withStyles } from '@material-ui/core/styles';
import MainTable from './MainTable';
import DetailsTable from './DetailsTable';
import ContentStyle from "../ContentStyle";
import {connect} from "react-redux";
import Typography from "@material-ui/core/Typography";
import {getVendorStatistic, getStatisticByVendor} from "../../../../redux/actions/clientActions";
import {useHistory, useParams} from "react-router-dom";
import {Helmet} from "react-helmet";

const styles = theme => ContentStyle(theme);

function Content({stat, getVendorStatistic, getStatisticByVendor, ...props}) {
    const {classes} = props;
    const isTableShown = stat && stat.vendorStatistic && stat.vendorStatistic.length > 0;
    let {id} = useParams();
    let history = useHistory();

    useEffect(() => {
        getVendorStatistic();

    }, [getVendorStatistic]);

    useEffect(() => {
        if(stat.vendorStatistic.length && !id){
            history.replace(`/manager/statistic/vendor/${stat.vendorStatistic[0].vendorId}`);
        }

    }, [stat.vendorStatistic, id, history]);

    useEffect(() => {
        if(id) {
            getStatisticByVendor(id);
        }
    }, [id, getStatisticByVendor]);

    const onMainTableClick = (event, name) => {
        history.push(`/manager/statistic/vendor/${name}`);
    };
    let vendorName = "Не знадейний";
    if(stat.vendorStatistic.length) {
        const vendorObject = stat.vendorStatistic.find(x => x.vendorId === parseInt(id));
        if(vendorObject)
            vendorName = vendorObject.vendor;
    }

    return (
        <Paper className={classes.paper}>
            <Helmet>
                <title>Autoparts - Статистика Постачальника - {vendorName}</title>
            </Helmet>
            <div className={classes.contentWrapper}>
                {isTableShown ?
                    <Grid container spacing={2} alignItems="center">
                        <Grid item xs={4}>
                            <MainTable vendorStatistic={stat.vendorStatistic} handleClick={onMainTableClick} />
                        </Grid>
                        <Grid item xs={8}>
                            <DetailsTable statisticByVendor={stat.statisticByVendor}/>
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
    getVendorStatistic,
    getStatisticByVendor
};

function mapStateToProps(state) {
    return {
        stat: state.statistic
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(withStyles(styles)(Content));
