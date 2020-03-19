import LinearProgress from "@material-ui/core/LinearProgress";
import React from "react";
import {connect} from "react-redux";

function Progress({inProgress}) {
    const isShown = inProgress > 0;
    return (isShown && <LinearProgress/>)
}

function mapStateToProps(state) {
    return {
        inProgress: state.apiCallsInProgress
    }
}

export default connect(mapStateToProps)(Progress);