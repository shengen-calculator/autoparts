export default function PaymentStyle(theme) {
  return {
      paper: {
          margin: 'auto',
          overflow: 'hidden',
          maxWidth: 650,
      },
      app: {
          flex: 1,
          display: 'flex',
          flexDirection: 'column'
      },
      contentWrapper: {
          margin: '40px 16px',
      },
      main: {
          flex: 1,
          padding: theme.spacing(1, 2),
          background: '#eaeff1'
      },
      footer: {
          padding: theme.spacing(4),
          background: '#eaeff1'
      },
      debt: {
          color: '#e91e63'
      },
      advance : {
          color: '#009688'
      },
      centered: {
          display: 'flex',
          margin: '40px',
          justifyContent: 'space-around'
      }
  };
}
