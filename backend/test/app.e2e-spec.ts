import { INestApplication, Logger } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import request from 'supertest';
import { App } from 'supertest/types';
import { ApiErrorResponse } from './../src/common/types/api-error-response.type';
import { AppModule } from './../src/app.module';
import { configureHttpApplication } from './../src/app.setup';
import { PrismaService } from './../src/prisma/prisma.service';

interface GeneralHealthResponse {
  status: string;
  service: string;
  timestamp: string;
}

interface HealthCheckResponse {
  status: string;
  check: string;
  timestamp: string;
}

function parseResponse<T>(response: request.Response): T {
  return JSON.parse(response.text) as T;
}

describe('Health endpoints (e2e)', () => {
  let app: INestApplication<App>;
  const queryRawMock = jest.fn().mockResolvedValue([{ result: 1 }]);

  beforeEach(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    })
      .overrideProvider(PrismaService)
      .useValue({ $queryRaw: queryRawMock })
      .compile();

    app = moduleFixture.createNestApplication();
    configureHttpApplication(app);
    await app.init();
  });

  afterEach(async () => {
    jest.restoreAllMocks();
    queryRawMock.mockReset().mockResolvedValue([{ result: 1 }]);
    await app.close();
  });

  it('GET /health returns the general status outside the API prefix', async () => {
    const response = await request(app.getHttpServer())
      .get('/health')
      .expect(200);
    const body = parseResponse<GeneralHealthResponse>(response);

    expect(body).toMatchObject({
      status: 'ok',
      service: 'Paulito Shoes API',
    });
    expect(body.timestamp).toEqual(expect.any(String));
    expect(response.headers['x-content-type-options']).toBe('nosniff');
    expect(queryRawMock).toHaveBeenCalledTimes(1);
  });

  it('GET /health/live does not query the database', async () => {
    const response = await request(app.getHttpServer())
      .get('/health/live')
      .expect(200);
    const body = parseResponse<HealthCheckResponse>(response);

    expect(body).toMatchObject({ status: 'ok', check: 'liveness' });
    expect(body.timestamp).toEqual(expect.any(String));
    expect(queryRawMock).not.toHaveBeenCalled();
  });

  it('GET /health/ready queries the database', async () => {
    const response = await request(app.getHttpServer())
      .get('/health/ready')
      .expect(200);
    const body = parseResponse<HealthCheckResponse>(response);

    expect(body).toMatchObject({ status: 'ok', check: 'readiness' });
    expect(queryRawMock).toHaveBeenCalledTimes(1);
  });

  it('returns the uniform error when the readiness query fails', async () => {
    jest.spyOn(Logger.prototype, 'error').mockImplementation(() => undefined);
    queryRawMock.mockRejectedValueOnce(new Error('database unavailable'));

    const response = await request(app.getHttpServer())
      .get('/health/ready')
      .expect(500);
    const body = parseResponse<ApiErrorResponse>(response);

    expect(body).toMatchObject({
      statusCode: 500,
      error: 'INTERNAL_SERVER_ERROR',
      message: 'Ocurrió un error interno al procesar la solicitud',
      path: '/health/ready',
    });
    expect(body.requestId).toMatch(/^req_[a-f0-9]{32}$/);
    expect(response.headers['x-request-id']).toBe(body.requestId);
  });

  it('does not expose health under the API prefix', async () => {
    const response = await request(app.getHttpServer())
      .get('/api/v1/health/live')
      .expect(404);
    const body = parseResponse<ApiErrorResponse>(response);

    expect(body).toMatchObject({
      statusCode: 404,
      error: 'RESOURCE_NOT_FOUND',
      path: '/api/v1/health/live',
    });
  });
});
