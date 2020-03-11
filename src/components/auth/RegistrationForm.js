import Avatar from "@material-ui/core/Avatar";
import LockOutlinedIcon from "@material-ui/icons/LockOutlined";
import Typography from "@material-ui/core/Typography";
import Button from "@material-ui/core/Button";
import Grid from "@material-ui/core/Grid";
import Box from "@material-ui/core/Box";
import Copyright from "../common/Copyright";
import React, {useState} from "react";
import TextInput from "../common/TextInput";

export default function RegistrationPage(props) {

    const {classes} = props;

    const [registration, setRegistration] = useState({
        email: '',
        password: '',
        confirmation: ''
    });
    const [errors, setErrors] = useState({});
    const [registering, setRegistering] = useState(false);

    function handleChange(event) {
        const { name, value } = event.target;
        setRegistration(prev => ({
            ...prev,
            [name]: value
        }));
    }

    function formIsValid() {
        const { email, password, confirmation } = registration;
        const errors = {};

        const regEmail = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        const regPassword =/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;
        if (!email) {
            errors.email = "Це поле обов'язкове для заповнення";
        } else if (!regEmail.test(String(email).toLowerCase())) {
            errors.email = "Email має некоректний формат";
        }

        if (!password) {
            errors.password = "Це поле обов'язкове для заповнення";
        } else if(password.length < 8) {
            errors.password = "Пароль повинен містити не менше 8 символів";
            setRegistration(prev => ({
                ...prev,
                password: '',
                confirmation: ''
            }));
        } else if (!regPassword.test(String(password).toLowerCase())) {
            errors.password = "Пароль повинен містити мінімум одну цифру та одну букву";
        }

        if (!confirmation) {
            errors.confirmation = "Це поле обов'язкове для заповнення";
        } else if(password !== confirmation) {
            errors.confirmation = "Пароль не відповідає підтвердженню";
            setRegistration(prev => ({
                ...prev,
                confirmation: ''
            }));
        }

        setErrors(errors);
        // Form is valid if the errors object still has no properties
        return Object.keys(errors).length === 0;
    }

    function handleRegistration(event) {
        event.preventDefault();
        if (!formIsValid()) return;
        setRegistering(true);
    }


    return(
        <div className={classes.paper}>
            <Avatar className={classes.avatar}>
                <LockOutlinedIcon />
            </Avatar>
            <Typography component="h1" variant="h5">
                Реєстрація
            </Typography>
            <form className={classes.form} onSubmit={handleRegistration}>
                <TextInput
                    name="email"
                    label="Email адреса"
                    onChange={handleChange}
                    error={errors.email}
                    type="text"
                    value={registration.email}
                />
                <TextInput
                    name="password"
                    label="Пароль"
                    onChange={handleChange}
                    error={errors.password}
                    type="password"
                    value={registration.password}
                />
                <TextInput
                    name="confirmation"
                    label="Повторити пароль"
                    onChange={handleChange}
                    error={errors.confirmation}
                    type="password"
                    value={registration.confirmation}
                />

                <Button
                    type="submit"
                    fullWidth
                    variant="contained"
                    color="primary"
                    className={classes.submit}
                    disabled={registering}
                >
                    {registering ? "РЕЄСТРАЦІЯ..." : "ЗАРЕЄСТРУВАТИСЬ"}
                </Button>
                <Grid container>
                    <Grid item xs>

                    </Grid>
                    <Grid item>

                    </Grid>
                </Grid>
                <Box mt={5}>
                    <Copyright />
                </Box>
            </form>
        </div>
    );
}