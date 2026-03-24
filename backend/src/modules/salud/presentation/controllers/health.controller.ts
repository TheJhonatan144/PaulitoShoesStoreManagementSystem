import { Controller, Get } from '@nestjs/common';
import { PrismaService } from '../../../../prisma/prisma.service';

@Controller('health')
export class HealthController {
    constructor(private readonly prisma: PrismaService) { }

    @Get()
    async getHealth() {
        await this.prisma.$queryRaw`SELECT 1`;

        return {
            status: 'ok',
            service: 'Paulito Shoes API',
            timestamp: new Date().toISOString(),
        };
    }

    @Get('live')
    getLiveness() {
        return {
            status: 'ok',
            check: 'liveness',
            timestamp: new Date().toISOString(),
        };
    }

    @Get('ready')
    async getReadiness() {
        await this.prisma.$queryRaw`SELECT 1`;

        return {
            status: 'ok',
            check: 'readiness',
            timestamp: new Date().toISOString(),
        };
    }
}