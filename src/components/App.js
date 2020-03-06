import React from "react";
import { Route, Switch } from "react-router-dom";
import ClientPage from "./client/App";
import ManagerPage from "./manager/App";
import PageNotFound from "./PageNotFound";
import LoginPage from "./auth/LoginPage";
import RegistrationPage from "./auth/RegistrationPage";

function App() {
    return (
        <div>
            <Switch>
                <Route exact path="/" component={ClientPage} />
                <Route path="/client" component={ClientPage} />
                <Route path="/manager" component={ManagerPage} />
                <Route path="/login" component={LoginPage} />
                <Route path="/registration" component={RegistrationPage} />
                <Route component={PageNotFound} />
            </Switch>
        </div>
    );
}

export default App;