
const getPhotos = async (data, context) => {

    return {
      isPhotoFound: false,
      urls: [`https://www.google.com/search?q=${data.number}+${data.number}&client=safari&source=lnms&tbm=isch`]
    };

};

module.exports = getPhotos;