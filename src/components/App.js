import React from "react";
import { Route, Switch } from "react-router-dom";
import ClientPage from "./client/App";
import ManagerPage from "./manager/App";
import PageNotFound from "./PageNotFound";

function App() {
    return (
        <div>
            <Switch>
                <Route exact path="/" component={ClientPage} />
                <Route path="/client" component={ClientPage} />
                <Route path="/manager" component={ManagerPage} />
                <Route component={PageNotFound} />
            </Switch>
        </div>
    );
}

export default App;