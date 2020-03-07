import Avatar from "@material-ui/core/Avatar";
import LockOutlinedIcon from "@material-ui/icons/LockOutlined";
import Typography from "@material-ui/core/Typography";
import TextField from "@material-ui/core/TextField";
import Button from "@material-ui/core/Button";
import Grid from "@material-ui/core/Grid";
import Box from "@material-ui/core/Box";
import Copyright from "../common/Copyright";
import React from "react";
import Link from "@material-ui/core/Link";
import { Link as RouterLink } from 'react-router-dom';

export default function LoginPage(props) {
    const {classes} = props;
    return(
        <div className={classes.paper}>
            <Avatar className={classes.avatar}>
                <LockOutlinedIcon />
            </Avatar>
            <Typography component="h1" variant="h5">
                Вхід
            </Typography>
            <form className={classes.form} noValidate>
                <TextField
                    variant="outlined"
                    margin="normal"
                    required
                    fullWidth
                    id="email"
                    label="Email адреса"
                    name="email"
                    autoComplete="email"
                    autoFocus
                />
                <TextField
                    variant="outlined"
                    margin="normal"
                    required
                    fullWidth
                    name="password"
                    label="Пароль"
                    type="password"
                    id="password"
                    autoComplete="current-password"
                />

                <Button
                    type="submit"
                    fullWidth
                    variant="contained"
                    color="primary"
                    className={classes.submit}
                >
                    ВВІЙТИ
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