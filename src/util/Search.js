export const removeSpecialCharacters = (data) => {
    const special = ['/', '%', '.', '-'];
    special.forEach(el => {
        const tokens = data.split(el);
        data = tokens.join('');
    });
    return data;
};

export const removeAllSpecialCharacters = (data) => {
    const special = ['@', '#', '_', '&', '-', '+', '(' , ')', '/', '*', '"', "'", ':', ';', '!', '?', '=', '[', ']', '©', '|', '\\', '%', ' ', '.' ];
    special.forEach(el => {
        const tokens = data.split(el);
        data = tokens.join('');
    });
    return data.toLowerCase();
};

export const htmlEncode = (data) => {
    const special = ['/'];
    special.forEach(el => {
        const tokens = data.split(el);
        data = tokens.join('%2F');
    });
    return data;
};

export const htmlDecode = (data) => {
    const special = [
        {html:'%2F', utf: '/'},
        {html:'%20', utf: ' '}
        ];
    special.forEach(el => {
        const tokens = data.split(el.html);
        data = tokens.join(el.utf);
    });
    return data;
};

export const getTables = (brand, numb, title, products) => {
    if(brand) {
        const restoredBrand = htmlDecode(brand);
        title += ` - ${restoredBrand}`;
    }
    if(numb) {
        title += ` - ${numb}`;
    }
    let generalRows = [], vendorRows = [], analogRows = [];

    if(products.length > 0 && brand) {
        const restoredBrand = htmlDecode(brand);
        generalRows = products.filter(x => x.available > 0 || x.reserve > 0);
        vendorRows = products.filter(x => x.available === 0 && x.brand === restoredBrand && x.reserve === 0 &&
            removeAllSpecialCharacters(x.number) === removeAllSpecialCharacters(numb));
        analogRows = products.filter(x => x.available === 0 && x.reserve === 0 && (x.brand !== restoredBrand ||
            removeAllSpecialCharacters(x.number) !== removeAllSpecialCharacters(numb)));
    }
    return {generalRows, vendorRows, analogRows, title};
};