import React, {useEffect, useState} from "react";
import Dialog from "@material-ui/core/Dialog";
import DialogTitle from "@material-ui/core/DialogTitle";
import {connect} from "react-redux";
import CircularProgress from "@material-ui/core/CircularProgress";
import DialogContent from "@material-ui/core/DialogContent";
import Box from "@material-ui/core/Box";
import Slider from "react-slick";
import {withStyles} from "@material-ui/core/styles";

const styles = () => ({
    box: {
        display: 'flex',
        justifyContent: 'center'
    },
    progress: {
        margin: 40,

    },
    photos: {
        margin: 40,
        minWidth: '100px',
        minHeight: '320px'
    }
});

function PhotoDialog(props) {
    const {isOpened, onClose, photos, calls, classes} = props;
    const [isPhotoHidden, setIsPhotoHidden] = useState(true);

    const settings = {
        dots: true,
        infinite: true,
        adaptiveHeight: true,
        speed: 500,
        slidesToShow: 1,
        slidesToScroll: 1
    };

    useEffect(() => {
        if (!calls) {
            if (!photos.length) {
                onClose();
            } else {
                setIsPhotoHidden(false);
            }
        }
    }, [calls, onClose, photos]);

    useEffect(() => {
        if (isOpened) {
            setIsPhotoHidden(true);
        }
    }, [isOpened]);

    return (
        <Dialog open={isOpened} aria-labelledby="form-dialog-title" onClose={onClose} maxWidth="sm">
            {isPhotoHidden && <DialogTitle id="form-photo-dialog-title">Завантаження зображень...</DialogTitle>}
            <DialogContent>
                {isPhotoHidden ?
                    <Box className={classes.box}>
                        <CircularProgress className={classes.progress}/>
                    </Box>
                    :
                    <Slider {...settings} className={classes.photos}>
                        {
                            photos.map((src, index) => (
                                <div>
                                    <img src={src} alt={`img-${index}`}/>
                                </div>
                            ))
                        }
                    </Slider>
                }
            </DialogContent>
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