import pink from '@material-ui/core/colors/pink';
import teal from '@material-ui/core/colors/teal';

export const getOrderRowClass = (row) => row.status === 0 ? {backgroundColor: teal[50]} :
    (row.status === 2 || row.status === 3 || row.status === 4) ? {backgroundColor: pink[50]} : {};

