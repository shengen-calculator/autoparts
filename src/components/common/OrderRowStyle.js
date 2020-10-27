import teal from '@material-ui/core/colors/teal';
import purple from "@material-ui/core/colors/purple";
import orange from "@material-ui/core/colors/orange";
import red from "@material-ui/core/colors/red";

export const getOrderRowClass = (row) => {
    switch (row.status) {
        case 0:
            return {backgroundColor: teal[50]};
        case 4:
            return {backgroundColor: red[500]};
        case 3:
            return {backgroundColor: orange[200]};
        case 2:
            return {backgroundColor: purple[200]};
        default:
            return {}
    }
};
