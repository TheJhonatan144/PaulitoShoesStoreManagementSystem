import * as Joi from 'joi';

export const envValidationSchema = Joi.object({
    NODE_ENV: Joi.string()
        .valid('development', 'test', 'production')
        .default('development'),

    PORT: Joi.number().default(3000),

    APP_NAME: Joi.string().default('Paulito Shoes API'),
    APP_VERSION: Joi.string().default('1.0.0'),

    DATABASE_URL: Joi.string().required(),

    JWT_ACCESS_SECRET: Joi.string().required(),
    JWT_ACCESS_EXPIRES_IN: Joi.string().default('15m'),

    JWT_REFRESH_SECRET: Joi.string().required(),
    JWT_REFRESH_EXPIRES_IN: Joi.string().default('7d'),

    BCRYPT_ROUNDS: Joi.number().default(12),
});