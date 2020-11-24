import React, {useEffect, useState} from "react";
import Dialog from "@material-ui/core/Dialog";
import DialogTitle from "@material-ui/core/DialogTitle";
import {connect} from "react-redux";
import CircularProgress from "@material-ui/core/CircularProgress";
import DialogContent from "@material-ui/core/DialogContent";
import Box from "@material-ui/core/Box";
import {withStyles} from "@material-ui/core/styles";

const styles = () => ({
    box: {
        display: 'flex',
        minHeight: '15vh'
    },
    progress: {
        margin: 40,

    }
});

function PhotoDialog(props) {
    const {isOpened, onClose, photos, calls, classes} = props;
    const [isPhotoHidden, setIsPhotoHidden] = useState(true);
    useEffect(() => {
        if (!calls) {
            if (!photos.length) {
                onClose();
            } else {
                setIsPhotoHidden(false);
            }
        }
    }, [calls, onClose, photos]);
    return (
        <Dialog open={isOpened} aria-labelledby="form-dialog-title" onClose={onClose} maxWidth="xl">
            {isPhotoHidden && <DialogTitle id="form-photo-dialog-title">Завантаження зображень...</DialogTitle>}

            <Box display="flex" justifyContent="center" className={classes.box}>
                {isPhotoHidden ?
                    <CircularProgress className={classes.progress}/> :
                    <DialogContent>
                        <h2>Тут мають бути фото запчастин</h2>
                    </DialogContent>
                }
            </Box>
        </Dialog>
    )
}

function mapStateToProps(state) {
    return {
        photos: state.product.photos.urls,
        calls: state.apiCallsInProgress
    }
}

export default connect(mapStateToProps)(withStyles(styles)(PhotoDialog));