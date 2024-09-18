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
import {getByNumber, getByBrand, getPhotos} from "../../../redux/actions/searchActions";
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
import {showToastrMessage} from "../../../redux/actions/messageActions";
import {HotKeys} from "react-hotkeys";
import PhotoDialog from "../../common/Dialog/PhotoDialog";

const styles = theme => SearchContentStyle(theme);

function Content({auth, calls, client, product, appState, getByBrand, getByNumber, getPhotos, showToastrMessage, ...props}) {
    const {classes, handleDrawerToggle} = props;
    const history = useHistory();
    const {numb, brand} = useParams();
    const [isPhotoDialogOpened, setIsPhotoDialogOpened] = React.useState(false);


    const openPhotoDialog = (selected) => {
        getPhotos({
            brand: selected.brand,
            number: selected.number
        });
        setIsPhotoDialogOpened(true);
    };

    const copyToBuffer = (selected) => {
        navigator.clipboard.writeText(selected.number).then(() => {
            showToastrMessage({type: 'success', message: 'Номер успішно скопійовано в буфер'});

        }, () => {
            showToastrMessage({type: 'error', message: 'Під час копіювання номеру в буфер виникла помилка'});
        });
    };

    const forward = (selected) => {
        history.push(`/search/${removeSpecialCharacters(selected.number)}/${htmlEncode(selected.brand)}`);
        document.body.scrollTop = 0; // For Safari
        document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
    };

    const handleCancelPhotoDialog = () => {
        setIsPhotoDialogOpened(false);
    };

    useEffect(() => {
        if (numb && appState.isSearchPaused) {
            showToastrMessage({
                type: 'warning',
                message: 'Проводиться планове обслуговування. Повторіть спробу через 15 хвилин'
            })
        } else {
            if (brand && brand !== product.criteria.brand) {
                getByBrand({
                    brand,
                    numb,
                    queryId: product.productsGrouped.length > 0 ? product.productsGrouped[0].queryId : null
                });
            } else if (numb && ((numb !== product.criteria.numb) || (!brand && product.criteria.brand && numb))) {
                getByNumber(numb);
            } else if (product.productsGrouped.length === 1 && !brand) {
                history.push(`/search/${removeSpecialCharacters(product.productsGrouped[0].number)}/${htmlEncode(product.productsGrouped[0].brand)}`)
            }
        }
    }, [numb, brand, getByNumber, getByBrand, product.criteria.brand, history,
        product.criteria.numb, product.productsGrouped, appState.isSearchPaused, showToastrMessage]);

    const tables = getTables(brand, numb, `Fenix - Клієнт`, product.products);
    const {generalRows, vendorRows, analogRows, title} = tables;

    const [filterDialog, setFilterDialog] = React.useState({
        isOpened: false
    });
    const onOpenFilterClick = () => {
        setFilterDialog({isOpened: true});
    };
    const closeFilterDialog = () => {
        setFilterDialog({isOpened: false});
    };
    const handlers = {
        OPEN_FILTER_DIALOG: onOpenFilterClick
    };

    return (
        <HotKeys className={classes.app} handlers={handlers}>
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
                                                                         onOpenPhotoDialog={openPhotoDialog}
                                                                         onCopyToBuffer={copyToBuffer}
                                                                         onForward={forward}
                                                                         isPriceShown={client.isPriceShown}/>}
                                {vendorRows.length > 0 && <VendorTable rows={StableSort(vendorRows,
                                    (GetComparator('asc', 'term')))} isEur={client.isEuroClient} role={auth.role}
                                                                       onOpenPhotoDialog={openPhotoDialog}
                                                                       onCopyToBuffer={copyToBuffer}
                                                                       onForward={forward}
                                                                       isPriceShown={client.isPriceShown}/>}
                                {analogRows.length > 0 && <AnalogTable rows={StableSort(analogRows,
                                    (GetComparator('asc', 'term')))} isEur={client.isEuroClient}
                                                                       role={auth.role}
                                                                       criteria={`${htmlDecode(brand)} ${numb}`}
                                                                       isFilterOpened={filterDialog.isOpened}
                                                                       onOpenFilterClick={onOpenFilterClick}
                                                                       closeDialog={closeFilterDialog}
                                                                       onOpenPhotoDialog={openPhotoDialog}
                                                                       onCopyToBuffer={copyToBuffer}
                                                                       onForward={forward}
                                                                       isPriceShown={client.isPriceShown}/>}
                            </React.Fragment>
                        }
                    </div>
                </Paper>}
            </main>
            <footer className={classes.footer}>
                <Copyright/>
            </footer>
            <PhotoDialog isOpened={isPhotoDialogOpened}
                         onClose={handleCancelPhotoDialog}/>
        </HotKeys>);
}

Content.propTypes = {
    classes: PropTypes.object.isRequired,
};

// noinspection JSUnusedGlobalSymbols
const mapDispatchToProps = {
    getByNumber,
    getByBrand,
    getPhotos,
    showToastrMessage
};

function mapStateToProps(state) {
    return {
        auth: state.authentication,
        client: state.client,
        product: state.product,
        calls: state.apiCallsInProgress,
        appState: state.appState
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(withStyles(styles)(Content));
