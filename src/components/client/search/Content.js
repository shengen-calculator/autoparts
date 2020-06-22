import React, {useEffect} from 'react';
import PropTypes from 'prop-types';
import AppBar from '@material-ui/core/AppBar';
import Paper from '@material-ui/core/Paper';
import {useParams, useHistory} from 'react-router-dom';
import {withStyles} from '@material-ui/core/styles';
import Header from '../Header';
import Copyright from '../../common/Copyright';
import {connect} from "react-redux";
import {Helmet} from "react-helmet";
import {getByNumber, getByBrand} from "../../../redux/actions/searchActions";
import Typography from "@material-ui/core/Typography";
import {
    getTables, htmlDecode,
    htmlEncode,
    removeSpecialCharacters
} from "../../../util/Search";
import GetComparator from "../../../util/GetComparator";
import StableSort from "../../../util/StableSort";
import GeneralTable from "../../common/Tables/GeneralTable";
import VendorTable from "../../common/Tables/VendorTable";
import AnalogTable from "../../common/Tables/AnalogTable";
import GroupedTable from "../../common/Tables/GroupedTable";
import SearchContentStyle from "../../common/SearchContentStyle";

const styles = theme => SearchContentStyle(theme);

function Content({auth, calls, client, product, getByBrand, getByNumber, ...props}) {
    const {classes, handleDrawerToggle} = props;
    const history = useHistory();
    const {numb, brand} = useParams();


    useEffect(() => {
        if (brand && brand !== product.criteria.brand) {
            getByBrand({
                brand,
                numb,
                queryId: product.productsGrouped.length > 0 ? product.productsGrouped[0].queryId : null
            });
        } else if (numb && ((numb !== product.criteria.numb) || (!brand && product.criteria.brand))) {
            getByNumber(numb);
        } else if (product.productsGrouped.length === 1 && !brand) {
            history.push(`/search/${removeSpecialCharacters(product.productsGrouped[0].number)}/${htmlEncode(product.productsGrouped[0].brand)}`)
        }
    }, [numb, brand, getByNumber, getByBrand, product.criteria.brand, history,
        product.criteria.numb, product.productsGrouped]);

    const tables = getTables(brand, numb, `Fenix - Клієнт`, product.products);
    const {generalRows, vendorRows, analogRows, title} = tables;

    return (<div className={classes.app}>
        <Header onDrawerToggle={handleDrawerToggle}/>
        <Helmet>
            <title>{title}</title>
        </Helmet>
        <main className={classes.main}>
            {(product.products.length > 0 || product.productsGrouped.length || calls === 0) &&
            <Paper className={classes.paper}>
                <AppBar className={classes.searchBar} position="static" color="default" elevation={0}/>
                <div className={classes.contentWrapper}>
                    {(product.productsGrouped.length === 0 && product.products.length === 0) ?
                        <Typography color="textSecondary" align="center">
                            Інформація відсутня
                        </Typography> :
                        <React.Fragment>
                            {product.productsGrouped.length > 1 &&
                            <GroupedTable rows={product.productsGrouped} role={auth.role}/>}
                            {generalRows.length > 0 && <GeneralTable rows={StableSort(generalRows,
                                (GetComparator('asc', 'cost')))} isEur={client.isEuroClient} role={auth.role}
                                                                     isPriceShown={client.isPriceShown}/>}
                            {vendorRows.length > 0 && <VendorTable rows={StableSort(vendorRows,
                                (GetComparator('asc', 'cost')))} isEur={client.isEuroClient} role={auth.role}
                                                                   isPriceShown={client.isPriceShown}/>}
                            {analogRows.length > 0 && <AnalogTable rows={StableSort(analogRows,
                                (GetComparator('asc', 'cost')))} isEur={client.isEuroClient}
                                                                   role={auth.role}
                                                                   criteria={`${htmlDecode(brand)} ${numb}`}
                                                                   isPriceShown={client.isPriceShown}/>}
                        </React.Fragment>
                    }
                </div>
            </Paper>}
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
        product: state.product,
        calls: state.apiCallsInProgress
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(withStyles(styles)(Content));
