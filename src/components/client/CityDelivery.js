import Typography from "@material-ui/core/Typography";
import React from "react";
import IconButton from "@material-ui/core/IconButton";
import AirportShuttleIcon from "@material-ui/icons/AirportShuttle";
import {withStyles} from "@material-ui/core/styles";
import Tooltip from "@material-ui/core/Tooltip";

function CityDelivery() {
    const bolder = {fontWeight: 800};
    const bigger = {fontWeight: 800, fontSize: 32};

    const HtmlTooltip = withStyles((theme) => ({
        tooltip: {
            backgroundColor: '#f5f5f9',
            color: 'rgba(0, 0, 0, 0.87)',
            maxWidth: 340,
            fontSize: theme.typography.pxToRem(12),
            border: '1px solid #dadde9',
        },
    }))(Tooltip);

    return (
        <HtmlTooltip title={
            <React.Fragment>
                До наступного виїзду авто залишилось:
                <Typography color="inherit" style={bigger}>00.01.25</Typography>
                Графік відправлень:
                <Typography color="inherit" style={bolder}>ПНД - ПТ: 10.30 12.30 14.30 16.30 18.30</Typography>
                <Typography color="inherit" style={bolder}>СБ: 10.30 12.30 14.30</Typography>
            </React.Fragment>
        }>
            <IconButton color="inherit">
                <AirportShuttleIcon/>
            </IconButton>
        </HtmlTooltip>

    )
}

export default CityDelivery;