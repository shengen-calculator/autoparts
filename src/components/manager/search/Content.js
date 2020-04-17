import React, {useEffect} from 'react';
import PropTypes from 'prop-types';
import AppBar from '@material-ui/core/AppBar';
import Paper from '@material-ui/core/Paper';
import {useParams, useHistory} from 'react-router-dom';
import {withStyles} from '@material-ui/core/styles';
import GeneralTable from "./GeneralTable";
import VendorTable from "./VendorTable";
import AnalogTable from "./AnalogTable";
import Header from '../Header';
import Copyright from '../../common/Copyright';
import {connect} from "react-redux";
import {Helmet} from "react-helmet";
import GroupedTable from "./GroupedTable";
import {getByNumber, getByBrand} from "../../../redux/actions/searchActions";
import Typography from "@material-ui/core/Typography";


const drawerWidth = 256;
const styles = theme => ({
    root: {
        display: 'flex',
        minHeight: '100vh'
    },
    drawer: {
        [theme.breakpoints.up('sm')]: {
            width: drawerWidth,
            flexShrink: 0
        }
    },
    app: {
        flex: 1,
        display: 'flex',
        flexDirection: 'column'
    },
    main: {
        flex: 1,
        padding: theme.spacing(1, 2),
        background: '#eaeff1'
    },
    footer: {
        padding: theme.spacing(4),
        background: '#eaeff1'
    },
    paper: {
        margin: 'auto',
        overflow: 'hidden'
    },
    searchBar: {
        borderBottom: '1px solid rgba(0, 0, 0, 0.12)'
    },
    searchInput: {
        fontSize: theme.typography.fontSize
    },
    block: {
        display: 'block'
    },
    addUser: {
        marginRight: theme.spacing(1)
    },
    contentWrapper: {
        margin: '40px 16px'
    }
});

function Content({auth, client, product, getByBrand, getByNumber, ...props}) {
    const {classes, handleDrawerToggle} = props;
    const history = useHistory();
    const {vip, numb, brand} = useParams();


    useEffect(() => {
        if (!vip) {
            if(!client.vip) {
                history.push(`/manager/search/${auth.vip}`)
            } else {
                history.push(`/manager/search/${client.vip}`)
            }
        }
    }, [vip, client.vip, auth.vip, history]);

    useEffect(() => {
        if (brand && brand !== product.criteria.brand) {
            getByBrand({brand, numb});
        } else if(numb && numb !== product.criteria.numb) {
            getByNumber(numb);
        }
    }, [numb, brand, getByNumber, getByBrand, product.criteria.brand, product.criteria.numb]);

    let title = `Autoparts - Клієнт - ${client.vip}`;

    if(brand) {
        title += ` - ${brand}`;
    }
    if(numb) {
        title += ` - ${numb}`;
    }
    let generalRows = [], vendorRows = [], analogRows = [];
    if(product.products.length > 0) {
        generalRows = product.products.filter(x => x.available > 0);
        vendorRows = product.products.filter(x => x.available === 0 && x.brand === brand && x.number === numb);
        analogRows = product.products.filter(x => x.available === 0 && (x.brand !== brand || x.number !== numb));
    }


    return (<div className={classes.app}>
        <Header onDrawerToggle={handleDrawerToggle}/>
        <Helmet>
            <title>{title}</title>
        </Helmet>
        <main className={classes.main}>
            <Paper className={classes.paper}>
                <AppBar className={classes.searchBar} position="static" color="default" elevation={0}/>
                <div className={classes.contentWrapper}>
                    {(product.productsGrouped.length === 0 && product.products.length === 0) ?
                        <Typography color="textSecondary" align="center">
                            По Вашему запросу ничего не найдено
                        </Typography> :
                        <React.Fragment>
                            {product.productsGrouped.length > 0 && <GroupedTable rows={product.productsGrouped} vip={vip}/>}
                            {generalRows.length > 0 && <GeneralTable rows={generalRows} isEur={client.isEuroClient}/>}
                            {vendorRows.length > 0 && <VendorTable rows={vendorRows} isEur={client.isEuroClient}/>}
                            {analogRows.length > 0 && <AnalogTable rows={analogRows} isEur={client.isEuroClient}/>}
                        </React.Fragment>
                    }
                </div>
            </Paper>
        </main>
        <footer className={classes.footer}>
            <Copyright/>
        </footer>
    </div>);
}

Content.propTypes = {
    classes: PropTypes.object.isRequired,
};

// noinspection JSUnusedGlobalSymbols
const mapDispatchToProps = {
    getByNumber,
    getByBrand

};

function mapStateToProps(state) {
    return {
        auth: state.authentication,
        client: state.client,
        product: state.product
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(withStyles(styles)(Content));
