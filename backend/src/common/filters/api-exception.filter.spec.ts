import {
  ArgumentsHost,
  BadRequestException,
  HttpStatus,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import { Request, Response } from 'express';
import { ApiErrorResponse } from '../types/api-error-response.type';
import { ApiExceptionFilter } from './api-exception.filter';

interface HttpMocks {
  host: ArgumentsHost;
  json: jest.Mock;
  setHeader: jest.Mock;
  status: jest.Mock;
}

function createHttpMocks(): HttpMocks {
  const request = {
    method: 'POST',
    originalUrl: '/api/v1/carrito/items',
  } as Request;
  const json = jest.fn();
  const setHeader = jest.fn();
  const status = jest.fn().mockReturnValue({ json });
  const response = { json, setHeader, status } as unknown as Response;
  const host = {
    switchToHttp: () => ({
      getRequest: () => request,
      getResponse: () => response,
    }),
  } as ArgumentsHost;

  return { host, json, setHeader, status };
}

describe('ApiExceptionFilter', () => {
  let filter: ApiExceptionFilter;

  beforeEach(() => {
    filter = new ApiExceptionFilter();
  });

  it('preserves custom API errors and their details', () => {
    const { host, json, setHeader, status } = createHttpMocks();
    const exception = new BadRequestException({
      error: 'VALIDATION_ERROR',
      message: 'Los datos enviados no son válidos',
      details: [{ field: 'cantidad', message: 'La cantidad no es válida' }],
    });

    filter.catch(exception, host);

    expect(status).toHaveBeenCalledWith(HttpStatus.BAD_REQUEST);
    const [[responseBody]] = json.mock.calls as [[ApiErrorResponse]];
    expect(responseBody).toMatchObject({
      statusCode: 400,
      error: 'VALIDATION_ERROR',
      message: 'Los datos enviados no son válidos',
      details: [{ field: 'cantidad', message: 'La cantidad no es válida' }],
      path: '/api/v1/carrito/items',
    });
    expect(responseBody.requestId).toMatch(/^req_[a-f0-9]{32}$/);
    expect(responseBody.timestamp).toEqual(expect.any(String));
    expect(setHeader).toHaveBeenCalledWith(
      'X-Request-Id',
      responseBody.requestId,
    );
  });

  it('maps standard Nest exceptions to contract error codes', () => {
    const { host, json, status } = createHttpMocks();

    filter.catch(new NotFoundException(), host);

    expect(status).toHaveBeenCalledWith(HttpStatus.NOT_FOUND);
    expect(json).toHaveBeenCalledWith(
      expect.objectContaining({
        statusCode: 404,
        error: 'RESOURCE_NOT_FOUND',
        message: 'El recurso solicitado no existe',
      }),
    );
  });

  it('hides internal error details and logs the trace', () => {
    const { host, json, status } = createHttpMocks();
    const loggerSpy = jest
      .spyOn(Logger.prototype, 'error')
      .mockImplementation(() => undefined);

    filter.catch(new Error('database credentials exposed'), host);

    expect(status).toHaveBeenCalledWith(HttpStatus.INTERNAL_SERVER_ERROR);
    expect(json).toHaveBeenCalledWith(
      expect.objectContaining({
        statusCode: 500,
        error: 'INTERNAL_SERVER_ERROR',
        message: 'Ocurrió un error interno al procesar la solicitud',
      }),
    );
    expect(json).not.toHaveBeenCalledWith(
      expect.objectContaining({ message: 'database credentials exposed' }),
    );
    expect(loggerSpy).toHaveBeenCalled();
  });
});
