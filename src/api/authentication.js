import {auth} from './database';

class AuthenticationApi {
    static logIn(credentials){
        return auth.signInWithEmailAndPassword(credentials.email, credentials.password);
    }
    static getTokenResult(){
        return auth.currentUser.getIdTokenResult();
    }
    static register(credentials){
        return auth.createUserWithEmailAndPassword(credentials.email, credentials.password);
    }
    static logOut() {
        return auth.signOut();
    }
}

export default AuthenticationApi;