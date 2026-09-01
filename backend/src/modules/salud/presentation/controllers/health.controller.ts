import { Controller, Get } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../../../../prisma/prisma.service';

interface GeneralHealthResponse {
  status: 'ok';
  service: string;
  timestamp: string;
}

interface HealthCheckResponse {
  status: 'ok';
  check: 'liveness' | 'readiness';
  timestamp: string;
}

@Controller('health')
export class HealthController {
  constructor(
    private readonly prisma: PrismaService,
    private readonly configService: ConfigService,
  ) {}

  @Get()
  async getHealth(): Promise<GeneralHealthResponse> {
    await this.prisma.$queryRaw`SELECT 1`;

    return {
      status: 'ok',
      service: this.configService.getOrThrow<string>('app.name'),
      timestamp: new Date().toISOString(),
    };
  }

  @Get('live')
  getLiveness(): HealthCheckResponse {
    return {
      status: 'ok',
      check: 'liveness',
      timestamp: new Date().toISOString(),
    };
  }

  @Get('ready')
  async getReadiness(): Promise<HealthCheckResponse> {
    await this.prisma.$queryRaw`SELECT 1`;

    return {
      status: 'ok',
      check: 'readiness',
      timestamp: new Date().toISOString(),
    };
  }
}
