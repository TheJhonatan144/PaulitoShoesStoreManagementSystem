import {
  BadRequestException,
  INestApplication,
  RequestMethod,
  ValidationPipe,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ValidationError } from 'class-validator';
import helmet from 'helmet';
import { ApiExceptionFilter } from './common/filters/api-exception.filter';
import { mapValidationErrors } from './common/utils/validation-error.util';

export function configureHttpApplication(app: INestApplication): void {
  const configService = app.get(ConfigService);
  const corsOrigin = configService.getOrThrow<string>('app.corsOrigin');

  app.setGlobalPrefix('api/v1', {
    exclude: [
      { path: 'health', method: RequestMethod.GET },
      { path: 'health/live', method: RequestMethod.GET },
      { path: 'health/ready', method: RequestMethod.GET },
    ],
  });

  app.use(helmet());

  app.enableCors({
    origin: corsOrigin,
    credentials: true,
  });

  app.useGlobalFilters(new ApiExceptionFilter());

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
      exceptionFactory: (errors: ValidationError[]) =>
        new BadRequestException({
          error: 'VALIDATION_ERROR',
          message: 'Los datos enviados no son válidos',
          details: mapValidationErrors(errors),
        }),
    }),
  );
}
