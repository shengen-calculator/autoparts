export const formatCurrency = (str, currency) =>
    new Intl.NumberFormat('de-DE', {style: 'currency', currency: currency}).format(str);

export const formatDate = (date) =>
{
    const year = new Intl.DateTimeFormat('en', { year: 'numeric' }).format(date);
    const month = new Intl.DateTimeFormat('en', { month: '2-digit' }).format(date);
    const day = new Intl.DateTimeFormat('en', { day: '2-digit' }).format(date);

    return `${year}-${month}-${day}`;
};