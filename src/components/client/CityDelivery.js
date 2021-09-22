import Typography from "@material-ui/core/Typography";
import React, {useState} from "react";
import IconButton from "@material-ui/core/IconButton";
import AirportShuttleIcon from "@material-ui/icons/AirportShuttle";
import {withStyles} from "@material-ui/core/styles";
import Tooltip from "@material-ui/core/Tooltip";
import {getDay, startOfToday, addMinutes, format} from 'date-fns'

function CityDelivery() {
    const bolder = {fontWeight: 800};
    const bigger = {fontWeight: 800, fontSize: 32};

    const [timer, setTimer] = useState({
        isShown: false
    });

    const HtmlTooltip = withStyles((theme) => ({
        tooltip: {
            backgroundColor: '#f5f5f9',
            color: 'rgba(0, 0, 0, 0.87)',
            maxWidth: 340,
            fontSize: theme.typography.pxToRem(12),
            border: '1px solid #dadde9',

        },
    }))(Tooltip);

    const formattedTime = (minutes) => {
        const helperDate = addMinutes(new Date(0), minutes - 180);
        return format(helperDate, 'hh:mm');
    };

    const handleClick = () => {
        const date = new Date();
        //0 represents Sunday
        let text = "";
        const current = (date - startOfToday()) / 1000 / 60;
        let dispatchTime;
        if ([1, 2, 3, 4, 5].includes(getDay(date))) {
            dispatchTime = [630, 750, 870, 990, 1110];
        } else if ([6].includes(getDay(date))) {
            dispatchTime = [630, 750, 870];
        } else {
            dispatchTime = [];
        }
        for (const time of dispatchTime) {
            if (current < time) {
                text = formattedTime(time - current);
                break;
            }
        }
        if (!text) {
            text = "--.--";
        }

        setTimer(prev => ({
            ...prev,
            isShown: !prev.isShown,
            text: text
        }));

    };

    return (
        <HtmlTooltip
            open={timer.isShown}
            disableFocusListener
            disableHoverListener
            disableTouchListener
            title={
                <React.Fragment>
                    До наступного виїзду авто залишилось:
                    <Typography color="inherit" style={bigger}>{timer.text}</Typography>
                    Графік виїздів:
                    <Typography color="inherit" style={bolder}>Пон-Пят: 10.30 12.30 14.30 16.30 18.30</Typography>
                    <Typography color="inherit" style={bolder}>Суб: 10.30 12.30 14.30</Typography>
                </React.Fragment>
            }>
            <IconButton color="inherit">
                <AirportShuttleIcon onClick={handleClick}/>
            </IconButton>
        </HtmlTooltip>
    )
}

export default CityDelivery;