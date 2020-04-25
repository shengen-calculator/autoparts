export const removeSpecialCharacters = (data) => {
    const special = ['/', '%'];
    special.forEach(el => {
        const tokens = data.split(el);
        data = tokens.join('');
    });
    return data;
};