import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import {
  appConfig,
  authConfig,
  databaseConfig,
  envValidationSchema,
} from './config';
import { PrismaModule } from './prisma/prisma.module';
import { SaludModule } from './modules/salud/salud.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [appConfig, authConfig, databaseConfig],
      validationSchema: envValidationSchema,
    }),
    PrismaModule,
    SaludModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
