export const removeSpecialCharacters = (data) => {
    const special = ['/', '%', '.', '-'];
    special.forEach(el => {
        const tokens = data.split(el);
        data = tokens.join('');
    });
    return data;
};

export const removeAllSpecialCharacters = (data) => {
    const special = ['@', '#', '_', '&', '-', '+', '(' , ')', '/', '*', '"', "'", ':', ';', '!', '?', '=', '[', ']', '©', '|', '\\', '%', ' ' ];
    special.forEach(el => {
        const tokens = data.split(el);
        data = tokens.join('');
    });
    return data;
};