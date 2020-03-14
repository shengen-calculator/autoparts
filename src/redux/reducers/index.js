import {combineReducers} from 'redux';
import authentication from './authenticationReducer';
import message from './messageReducer';

const rootReducer = combineReducers({
    authentication,
    message
});

export default rootReducer;