import React from 'react';
import { Redirect, Route } from 'react-router-dom';

const PrivateRoute = ({component: Component, role, only, ...rest}) => (
    <Route {...rest} render={(props) => {
        return only.includes(role)
            ? <Component {...props} />
            : <Redirect to={{
                pathname: '/auth/login',
                state: { from: props.location }
            }} />
    }}/>
);

export default PrivateRoute;