import {withStyles} from "@material-ui/core/styles";
import TableCell from "@material-ui/core/TableCell";

export const StyledTableCell = withStyles(theme => ({
    head: {
        fontSize: 16,
        fontWeight: 600
    }
}))(TableCell);
