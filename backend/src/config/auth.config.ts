export default () => ({
    auth: {
        accessTokenSecret: process.env.JWT_ACCESS_SECRET || 'changeme_access',
        accessTokenExpiresIn: process.env.JWT_ACCESS_EXPIRES_IN || '15m',
        refreshTokenSecret: process.env.JWT_REFRESH_SECRET || 'changeme_refresh',
        refreshTokenExpiresIn: process.env.JWT_REFRESH_EXPIRES_IN || '7d',
        bcryptRounds: parseInt(process.env.BCRYPT_ROUNDS || '12', 10),
    },
});