import { Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { configureHttpApplication } from './app.setup';

const bootstrapLogger = new Logger('Bootstrap');

async function bootstrap(): Promise<void> {
  const app = await NestFactory.create(AppModule);
  const configService = app.get(ConfigService);
  const appName = configService.getOrThrow<string>('app.name');
  const port = configService.getOrThrow<number>('app.port');

  configureHttpApplication(app);

  app.enableShutdownHooks();

  await app.listen(port);

  bootstrapLogger.log(`${appName} running on port ${port}`);
}

bootstrap().catch((error: unknown) => {
  const trace = error instanceof Error ? error.stack : undefined;

  bootstrapLogger.error('Failed to start the application', trace);
  process.exitCode = 1;
});
