import React from 'react';
import CssBaseline from '@material-ui/core/CssBaseline';
import Paper from '@material-ui/core/Paper';
import Grid from '@material-ui/core/Grid';
import { makeStyles } from '@material-ui/core/styles';
import {Route, Switch} from "react-router-dom";
import LoginForm from "./LoginForm";
import RegistrationForm from "./RegistrationForm";

const useStyles = makeStyles(theme => ({
    root: {
        height: '100vh',
    },
    image: {
        backgroundImage: 'url(https://firebasestorage.googleapis.com/v0/b/autoparts-95d56.appspot.com/o/alessio-lin--6LYjG0H32E-unsplash.jpg?alt=media&token=520f22e9-ac54-4dd4-863f-0b75822906e8)',
        backgroundRepeat: 'no-repeat',
        backgroundColor:
            theme.palette.type === 'dark' ? theme.palette.grey[900] : theme.palette.grey[50],
        backgroundSize: 'cover',
        backgroundPosition: 'center',
    },
    paper: {
        margin: theme.spacing(8, 4),
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
    },
    avatar: {
        margin: theme.spacing(1),
        backgroundColor: theme.palette.secondary.main,
    },
    form: {
        width: '100%', // Fix IE 11 issue.
        marginTop: theme.spacing(1),
    },
    submit: {
        margin: theme.spacing(3, 0, 2),
    },
}));

export default function Auth(props) {
    const classes = useStyles();
    const {match} = props;

    return (
        <Grid container component="main" className={classes.root}>
            <CssBaseline />
            <Grid item xs={false} sm={4} md={7} className={classes.image} />
            <Grid item xs={12} sm={8} md={5} component={Paper} elevation={6} square>
                <Switch>
                    <Route path={`${match.path}/login`}>
                        <LoginForm classes={classes} />
                    </Route>
                    <Route path={`${match.path}/registration`}>
                        <RegistrationForm classes={classes}/>
                    </Route>
                    <Route exact path={`${match.path}/`}>
                        <LoginForm classes={classes}/>
                    </Route>
                </Switch>
            </Grid>
        </Grid>
    );
}
