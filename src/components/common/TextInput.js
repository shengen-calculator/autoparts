import React from "react";
import {TextField} from "@material-ui/core";


const TextInput = ({ name, label, onChange, error, type, value }) => {
    let isError = false;
    if (error && error.length > 0) {
        isError = true;
    }

    return (
        <TextField
            onChange={onChange}
            error={isError}
            variant="outlined"
            margin="normal"
            fullWidth
            id={label}
            label={label}
            helperText={error}
            type={type}
            name={name}
            value={value}
        />
    );
};

export default TextInput;