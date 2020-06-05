import { useSnackbar } from 'notistack';
import {connect} from "react-redux";
import React, {useEffect} from "react";

function ToastrMessage({message}) {
    const { enqueueSnackbar } = useSnackbar();

    useEffect(() => {
        if(message && message.text) {
            enqueueSnackbar(message.text, {
                variant: message.type,
                anchorOrigin: {vertical: 'top', horizontal: 'right'},
                autoHideDuration: 2000
            });
        }
    }, [message, enqueueSnackbar]);
    return (<React.Fragment/>);
}

function mapStateToProps(state) {
    return {
        message: state.message
    }
}
export default connect(
    mapStateToProps
)(ToastrMessage);