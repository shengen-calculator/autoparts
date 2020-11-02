import React from 'react';
import ReactDOM from 'react-dom';
import App from './components/App';
import * as serviceWorker from './serviceWorker';
import {BrowserRouter as Router} from "react-router-dom";
import {Provider} from 'react-redux';
import {PersistGate} from 'redux-persist/integration/react'
import configureStore from "./redux/configureStore";
import { SnackbarProvider } from 'notistack';
import ToastrMessage from "./components/common/ToastrMessage";
import {HotKeys} from "react-hotkeys";


const {store, persistent} = configureStore();
const keyMap = {
    OPEN_FILTER_DIALOG: "l"
};
ReactDOM.render(
    <Provider store={store}>
        <HotKeys keyMap={keyMap}>
            <PersistGate loading={null} persistor={persistent}>
                <Router>
                    <SnackbarProvider maxSnack={3}>
                        <App/>
                        <ToastrMessage/>
                    </SnackbarProvider>
                </Router>
            </PersistGate>
        </HotKeys>
    </Provider>,
    document.getElementById('root'));

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
