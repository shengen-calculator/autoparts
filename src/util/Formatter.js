export const formatCurrency = (str, currency) =>
    new Intl.NumberFormat('de-DE', {style: 'currency', currency: currency}).format(str);