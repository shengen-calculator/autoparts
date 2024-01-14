import Avatar from "@material-ui/core/Avatar";
import LockOutlinedIcon from "@material-ui/icons/LockOutlined";
import Typography from "@material-ui/core/Typography";
import TextInput from "../common/TextInput";
import Button from "@material-ui/core/Button";
import Grid from "@material-ui/core/Grid";
import Box from "@material-ui/core/Box";
import Copyright from "../common/Copyright";
import React, {useEffect, useState} from "react";
import Link from "@material-ui/core/Link";
import {Link as RouterLink, useHistory} from 'react-router-dom';
import {authenticationRequest} from "../../redux/actions/authenticationActions";
import {connect} from "react-redux";
import {regEmail} from "../../util/Regs";
import {RoleEnum} from "../../util/Enums";

function LoginPage({
                       auth,
                       authenticationRequest,
                       ...props
                   }) {
    const {classes} = props;
    const [authentication, setAuthentication] = useState({
        email: '',
        password: '',
        requestInProcess: false
    });
    const [errors, setErrors] = useState({});
    let history = useHistory();


    useEffect(() => {
        if(auth.logging === true && authentication.requestInProcess === false) {
            setAuthentication(prev => ({
                ...prev,
                requestInProcess: true
            }));
        }

        if(auth.logging === false && authentication.requestInProcess === true) {
            setAuthentication(prev => ({
                ...prev,
                requestInProcess: false
            }));
            if(auth.role === RoleEnum.Manager || auth.role === RoleEnum.Admin) {
                history.push(`/manager/search/${auth.vip}`);
            } else {
                history.push('/');
            }

        }

    }, [auth.logging, auth.role, auth.vip, history, authentication]);


    function handleChange(event) {
        const { name, value } = event.target;
        setAuthentication(prev => ({
            ...prev,
            [name]: value
        }));
    }

    function formIsValid() {
        const { email, password } = authentication;
        const errors = {};

        if (!email) {
            errors.email = "Це поле обов'язкове для заповнення";
        } else if (!regEmail.test(String(email).toLowerCase())) {
            errors.email = "Email має некоректний формат";
        }

        if (!password) {
            errors.password = "Це поле обов'язкове для заповнення";
        }

        setErrors(errors);
        // Form is valid if the errors object still has no properties
        return Object.keys(errors).length === 0;
    }

    function handleRegistration(event) {
        event.preventDefault();
        if (!formIsValid()) return;
        const { email, password } = authentication;
        authenticationRequest({email: email, password: password});
    }

    return(
        <div className={classes.paper}>
            <Avatar className={classes.avatar}>
                <LockOutlinedIcon />
            </Avatar>
            <Typography component="h1" variant="h5">
                Вхід
            </Typography>
            <form className={classes.form} onSubmit={handleRegistration}>
                <TextInput
                    name="email"
                    label="Email адреса"
                    onChange={handleChange}
                    error={errors.email}
                    type="text"
                    value={authentication.email}
                />
                <TextInput
                    name="password"
                    label="Пароль"
                    onChange={handleChange}
                    error={errors.password}
                    type="password"
                    value={authentication.password}
                />

                <Button
                    type="submit"
                    fullWidth
                    variant="contained"
                    color="primary"
                    className={classes.submit}
                    disabled={authentication.requestInProcess}
                >
                    {authentication.requestInProcess ? "ВХІД..." : "ВХІД"}
                </Button>
                <Grid container>
                    <Grid item xs>

                    </Grid>
                    <Grid item>
                        <Link component={RouterLink} to="/auth/registration" variant="body2">
                            {"Немає акаунту? Зареєструватись"}
                        </Link>
                    </Grid>
                </Grid>
                <Box mt={5}>
                    <Copyright />
                </Box>
            </form>
        </div>
    );
}


function mapStateToProps(state) {
    return {
        auth: state.authentication
    }
}

// noinspection JSUnusedGlobalSymbols
const mapDispatchToProps = {
    authenticationRequest
};

export default connect(
    mapStateToProps,
    mapDispatchToProps
)(LoginPage);
