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
    return data;
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