import React from 'react';
import PropTypes from 'prop-types';
import Paper from '@material-ui/core/Paper';
import Grid from '@material-ui/core/Grid';
import { withStyles } from '@material-ui/core/styles';
import MainTable from './MainTable';
import DetailsTable from './DetailsTable';
import ContentStyle from "../ContentStyle";
import {connect} from "react-redux";
import Typography from "@material-ui/core/Typography";
import {getStatisticByVendor} from "../../../../redux/actions/clientActions";

const styles = theme => ContentStyle(theme);

function Content({statistic, getStatisticByVendor, ...props}) {
    const {classes, startDate, endDate} = props;
    const isTableShown = statistic && statistic.vendorStatistic && statistic.vendorStatistic.length > 0;

    function onVendorSelect(vendorId) {
        getStatisticByVendor({startDate, endDate, vendorId});
    }


    return (
        <Paper className={classes.paper}>
            <div className={classes.contentWrapper}>
                {isTableShown ?
                    <Grid container spacing={2} alignItems="center">
                        <Grid item xs={4}>
                            <MainTable vendorStatistic={statistic.vendorStatistic} onSelect={onVendorSelect} />
                        </Grid>
                        <Grid item xs={8}>
                            <DetailsTable statisticByVendor={statistic.statisticByVendor}/>
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
    getStatisticByVendor
};

function mapStateToProps(state) {
    return {
        statistic: state.statistic
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(withStyles(styles)(Content));
