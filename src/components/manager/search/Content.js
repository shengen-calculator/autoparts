import React, {useEffect} from 'react';
import PropTypes from 'prop-types';
import AppBar from '@material-ui/core/AppBar';
import Paper from '@material-ui/core/Paper';
import {useParams, useHistory} from 'react-router-dom';
import {withStyles} from '@material-ui/core/styles';
import GeneralTable from "../../common/Tables/GeneralTable";
import VendorTable from "../../common/Tables/VendorTable";
import AnalogTable from "../../common/Tables/AnalogTable";
import Header from '../Header';
import Copyright from '../../common/Copyright';
import {connect} from "react-redux";
import {Helmet} from "react-helmet";
import GroupedTable from "../../common/Tables/GroupedTable";
import {getByNumber, getByBrand} from "../../../redux/actions/searchActions";
import Typography from "@material-ui/core/Typography";
import {
    getTables, htmlDecode,
    htmlEncode,
    removeSpecialCharacters
} from "../../../util/Search";
import GetComparator from "../../../util/GetComparator";
import StableSort from "../../../util/StableSort";
import SearchContentStyle from "../../common/SearchContentStyle";
import AnalogListDialog from "./dialog/AnalogListDialog";

const styles = theme => SearchContentStyle(theme);

function Content({auth, calls, client, product, getByBrand, getByNumber, ...props}) {
    const {classes, handleDrawerToggle} = props;
    const history = useHistory();
    const {vip, numb, brand} = useParams();
    const [isAnalogListDialogOpened, setIsAnalogListDialogOpened] = React.useState(false);

    useEffect(() => {
        if (!vip) {
            if (!client.vip) {
                history.push(`/manager/search/${auth.vip}`)
            } else {
                history.push(`/manager/search/${client.vip}`)
            }
        }
    }, [vip, client.vip, auth.vip, history]);

    useEffect(() => {
        if (brand && brand !== product.criteria.brand) {
            const record = product.productsGrouped.find(x => x.brand === brand && x.number === numb);
            getByBrand({brand, numb, clientId: client.id, analogId: record ? record.analogId : null});
        } else if ((numb && numb !== product.criteria.numb) || (!brand && product.criteria.brand && numb)) {
            getByNumber(numb);
        } else if (product.productsGrouped.length === 1 && !brand) {
            history.push(`/manager/search/${client.vip}/${removeSpecialCharacters(product.productsGrouped[0].number)}/${htmlEncode(product.productsGrouped[0].brand)}`)
        }
    }, [numb, brand, getByNumber, getByBrand, product.criteria.brand, client.vip, history,
        product.criteria.numb, client.id, product.productsGrouped]);

    const openAnalogListDialog = () => {
        setIsAnalogListDialogOpened(true);
    };
    const handleCancelAnalogDialog = () => {
        setIsAnalogListDialogOpened(false);
    };

    const tables = getTables(brand, numb, `Fenix - Клієнт - ${client.vip}`, product.products);
    const {generalRows, vendorRows, analogRows, title} = tables;

    return (
        <div className={classes.app}>
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
                                <GroupedTable rows={product.productsGrouped} vip={vip} role={auth.role}/>}
                                {generalRows.length > 0 && <GeneralTable rows={StableSort(generalRows,
                                    (GetComparator('asc', 'cost')))} isEur={client.isEuroClient} role={auth.role}
                                                                         isPriceShown={true} onOpenAnalogDialog={openAnalogListDialog}/>}
                                {vendorRows.length > 0 && <VendorTable rows={StableSort(vendorRows,
                                    (GetComparator('asc', 'cost')))} isEur={client.isEuroClient} role={auth.role}
                                                                       isPriceShown={true} inOrder={product.inOrder}
                                                                       onOpenAnalogDialog={openAnalogListDialog}/>}
                                {analogRows.length > 0 && <AnalogTable rows={StableSort(analogRows,
                                    (GetComparator('asc', 'cost')))} isEur={client.isEuroClient}
                                                                       role={auth.role}
                                                                       criteria={`${htmlDecode(brand)} ${numb}`}
                                                                       isPriceShown={true} inOrder={product.inOrder}
                                                                       onOpenAnalogDialog={openAnalogListDialog}/>}
                            </React.Fragment>
                        }
                    </div>
                </Paper>}
            </main>
            <footer className={classes.footer}>
                <Copyright/>
            </footer>
            <AnalogListDialog isOpened={isAnalogListDialogOpened}
                              onClose={handleCancelAnalogDialog}/>/>
        </div>
    );
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
