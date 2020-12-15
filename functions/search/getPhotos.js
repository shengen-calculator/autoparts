const util = require('../util');
const admin = require('firebase-admin');
const configuration = require('../settings');

const getPhotos = async (data, context) => {

    util.checkForClientRole(context);

    const bucket =
        admin.storage().bucket(`${configuration.photos}`);

    const options = {
        prefix: `${data.brand}/${data.number.toUpperCase()}/`,
        delimiter:'/'
    };

    const [files] = await bucket.getFiles(options);

    const config = {
        action: 'read',
        expires: '01-01-2021',
    };

    if (files.length) {
        const result = [];
        for (const file of files) {
            if(file.name !== `${data.brand}/${data.number}/`) {
                const resultFile = bucket.file(file.name);
                // eslint-disable-next-line no-await-in-loop
                const url = await resultFile.getSignedUrl(config);
                result.push(url);
            }
        }
        return {
            isPhotoFound: true,
            urls: result
        }

    } else {
        return {
            isPhotoFound: false,
            urls: [`https://www.google.com/search?q=${data.brand}+${data.number}&client=safari&source=lnms&tbm=isch`]
        };
    }
};

module.exports = getPhotos;