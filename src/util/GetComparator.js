function descendingComparator(a, b, orderBy) {
    for (const fieldName of orderBy) {
        if (b[fieldName] < a[fieldName]) {
            return -1;
        }
        if (b[fieldName] > a[fieldName]) {
            return 1;
        }
    }
    return 0;
}

export default function GetComparator(order, ...orderBy) {
    return order === 'desc'
        ? (a, b) => descendingComparator(a, b, orderBy)
        : (a, b) => -descendingComparator(a, b, orderBy);
}