import React, {useState} from 'react';
import {connect} from "react-redux";
import {withStyles} from '@material-ui/core/styles';
import Button from "@material-ui/core/Button";
import Dialog from "@material-ui/core/Dialog";
import DialogContent from "@material-ui/core/DialogContent";
import DialogActions from "@material-ui/core/DialogActions";
import ukLocale from "date-fns/locale/uk";
import DateFnsUtils from '@date-io/date-fns';
import {createReserve} from "../../../redux/actions/searchActions";
import {showToastrMessage} from "../../../redux/actions/messageActions";
import {
    MuiPickersUtilsProvider,
    KeyboardDatePicker,
} from '@material-ui/pickers';


const styles = theme => ({
    root: {
        display: 'flex',
        minHeight: '100vh'
    },
});

function ReconciliationDialog(props) {
    const {isOpened, onClose, showToastrMessage} = props;
    const date = new Date();
    const [dateFilter, setDateFilter] = useState({
        startDate: new Date(date.setMonth(date.getMonth() - 1)),
        endDate: Date.now()
    });

    function handleStartDateChange(value) {
        setDateFilter(prev => ({
            ...prev,
            startDate: value
        }));
    }

    function onOpen() {
        const date = new Date();
        setDateFilter(prev => ({
            ...prev,
            startDate: new Date(date.setMonth(date.getMonth() - 1)),
            endDate: Date.now()
        }));
    }

    function handleEndDateChange(value) {
        setDateFilter(prev => ({
            ...prev,
            endDate: value
        }));
    }

    function handleDownloadClick(event) {
        event.preventDefault();
        const diffTime = dateFilter.endDate - dateFilter.startDate;
        if(diffTime < 0) {
            showToastrMessage({type: 'warning', message: 'Помилка!!! Дата початку періоду перевищує дату його завершення'})
        } else if(Math.ceil(diffTime / (1000 * 60 * 60 * 24)) > 92) {
            showToastrMessage({type: 'warning', message: 'Помилка!!! Період не може перевищувати 90 днів'})
        } else {
            alert('Start Download')
        }
    }


    return (
        <MuiPickersUtilsProvider utils={DateFnsUtils} locale={ukLocale}>
            <Dialog open={isOpened} aria-labelledby="form-dialog-title" onClose={onClose} onEnter={onOpen}>
                <form onSubmit={handleDownloadClick}>
                    <DialogContent>
                        <KeyboardDatePicker
                            margin="normal"
                            id="date-picker-start"
                            label="Починаючи з"
                            format="dd/MM/yyyy"
                            value={dateFilter.startDate}
                            onChange={handleStartDateChange}
                            KeyboardButtonProps={{
                                'aria-label': 'change date',
                            }}
                        />
                        <br/>
                        <KeyboardDatePicker
                            margin="normal"
                            id="date-picker-end"
                            label="до"
                            format="dd/MM/yyyy"
                            value={dateFilter.endDate}
                            onChange={handleEndDateChange}
                            KeyboardButtonProps={{
                                'aria-label': 'change date',
                            }}
                        />
                    </DialogContent>
                    <DialogActions>
                        <Button onClick={onClose} color="primary">
                            Відміна
                        </Button>
                        <Button type="submit" color="primary">
                            Завантажити
                        </Button>
                    </DialogActions>
                </form>
            </Dialog>
        </MuiPickersUtilsProvider>
    );
}

// noinspection JSUnusedGlobalSymbols
const mapDispatchToProps = {
    createReserve,
    showToastrMessage
};

function mapStateToProps(state) {
    return {
        client: state.client,
        auth: state.authentication
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(withStyles(styles)(ReconciliationDialog));