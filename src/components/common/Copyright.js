import React from 'react';
import Link from '@material-ui/core/Link';
import Typography from '@material-ui/core/Typography';

function Copyright() {
  return (
      <Typography variant="body2" color="textSecondary" align="center">
        {'Copyright © FenixParts '}
          {new Date().getFullYear()}
          {'.'}
          <br/>
        <Link color="inherit" href="mailto:vasya_mail@ukr.net">
            Designed by bass.
        </Link>{' '}
      </Typography>
  );
}

export default Copyright;
