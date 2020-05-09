export default function ContentStyle(theme) {
    return {
        root: {
            display: 'flex',
            minHeight: '100vh'
        },

        app: {
            flex: 1,
            display: 'flex',
            flexDirection: 'column'
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
        paper: {
            margin: 'auto',
            overflow: 'hidden'
        },
        searchBar: {
            borderBottom: '1px solid rgba(0, 0, 0, 0.12)'
        },
        searchInput: {
            fontSize: theme.typography.fontSize
        },
        block: {
            display: 'block'
        },
        addUser: {
            marginRight: theme.spacing(1)
        },
        contentWrapper: {
            margin: '40px 16px'
        }
    }
}