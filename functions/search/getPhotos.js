const getPhotos = async (data, context) => {

    if (data.number === '5413') {
        return {
            isPhotoFound: true,
            urls: ['f30b788d-43fe-4dd1-933f-76521d545ae6.jpg',
                '2424b2f4-5306-486b-a8a7-84c8d8ab7b04.jpg',
                'f161f38c-6901-4ea1-8858-c3ced090412b.jpg',
                '11d8fe54-60f9-4e1c-9747-0d03f4b4485e.jpg']
        }

    } else {
        return {
            isPhotoFound: false,
            urls: [`https://www.google.com/search?q=${data.brand}+${data.number}&client=safari&source=lnms&tbm=isch`]
        };
    }

};

module.exports = getPhotos;