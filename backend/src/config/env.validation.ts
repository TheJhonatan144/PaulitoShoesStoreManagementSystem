import * as Joi from 'joi';

export const envValidationSchema = Joi.object({
  NODE_ENV: Joi.string()
    .valid('development', 'test', 'production')
    .default('development'),

  PORT: Joi.number().port().default(3000),

  APP_NAME: Joi.string().trim().default('Paulito Shoes API'),
  APP_VERSION: Joi.string().trim().default('1.0.0'),
  CORS_ORIGIN: Joi.string().uri().default('http://localhost:5173'),

  DATABASE_URL: Joi.string()
    .uri({ scheme: ['postgresql', 'postgres'] })
    .required(),

  JWT_ACCESS_SECRET: Joi.string().min(32).required(),
  JWT_ACCESS_EXPIRES_IN: Joi.string().default('15m'),

  JWT_REFRESH_SECRET: Joi.string().min(32).required(),
  JWT_REFRESH_EXPIRES_IN: Joi.string().default('7d'),

  BCRYPT_ROUNDS: Joi.number().integer().min(10).max(14).default(12),
});
