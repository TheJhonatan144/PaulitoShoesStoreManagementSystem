import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { randomUUID } from 'node:crypto';
import { Request, Response } from 'express';
import {
  ApiErrorDetails,
  ApiErrorResponse,
} from '../types/api-error-response.type';

interface ErrorDefinition {
  error: string;
  message: string;
}

interface CustomExceptionResponse {
  error?: unknown;
  message?: unknown;
  details?: unknown;
}

const DEFAULT_ERROR: ErrorDefinition = {
  error: 'HTTP_ERROR',
  message: 'No fue posible procesar la solicitud',
};

const INTERNAL_SERVER_ERROR: ErrorDefinition = {
  error: 'INTERNAL_SERVER_ERROR',
  message: 'Ocurrió un error interno al procesar la solicitud',
};

const HTTP_ERROR_DEFINITIONS: Partial<Record<HttpStatus, ErrorDefinition>> = {
  [HttpStatus.BAD_REQUEST]: {
    error: 'VALIDATION_ERROR',
    message: 'Los datos enviados no son válidos',
  },
  [HttpStatus.UNAUTHORIZED]: {
    error: 'INVALID_TOKEN',
    message: 'El token de acceso no es válido',
  },
  [HttpStatus.FORBIDDEN]: {
    error: 'FORBIDDEN',
    message: 'No tiene permisos para realizar esta operación',
  },
  [HttpStatus.NOT_FOUND]: {
    error: 'RESOURCE_NOT_FOUND',
    message: 'El recurso solicitado no existe',
  },
  [HttpStatus.CONFLICT]: {
    error: 'RESOURCE_IN_USE',
    message: 'La solicitud entra en conflicto con el estado actual del recurso',
  },
  [HttpStatus.UNPROCESSABLE_ENTITY]: {
    error: 'UNPROCESSABLE_ENTITY',
    message: 'La solicitud no puede procesarse debido a una regla de negocio',
  },
  [HttpStatus.TOO_MANY_REQUESTS]: {
    error: 'TOO_MANY_REQUESTS',
    message:
      'Se realizaron demasiadas solicitudes. Intente nuevamente más tarde',
  },
};

@Catch()
export class ApiExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(ApiExceptionFilter.name);

  catch(exception: unknown, host: ArgumentsHost): void {
    const httpContext = host.switchToHttp();
    const request = httpContext.getRequest<Request>();
    const response = httpContext.getResponse<Response>();
    const statusCode =
      exception instanceof HttpException
        ? exception.getStatus()
        : HttpStatus.INTERNAL_SERVER_ERROR;
    const requestId = `req_${randomUUID().replaceAll('-', '')}`;
    const errorDefinition = this.getErrorDefinition(exception, statusCode);
    const details = this.getDetails(exception);

    const responseBody: ApiErrorResponse = {
      statusCode,
      error: errorDefinition.error,
      message: errorDefinition.message,
      ...(details === undefined ? {} : { details }),
      path: request.originalUrl,
      timestamp: new Date().toISOString(),
      requestId,
    };

    if (statusCode >= Number(HttpStatus.INTERNAL_SERVER_ERROR)) {
      this.logInternalError(exception, request, requestId);
    }

    response.setHeader('X-Request-Id', requestId);
    response.status(statusCode).json(responseBody);
  }

  private getErrorDefinition(
    exception: unknown,
    statusCode: number,
  ): ErrorDefinition {
    if (!(exception instanceof HttpException)) {
      return INTERNAL_SERVER_ERROR;
    }

    const exceptionResponse = exception.getResponse();

    if (this.isCustomExceptionResponse(exceptionResponse)) {
      return {
        error: exceptionResponse.error,
        message: exceptionResponse.message,
      };
    }

    return (
      HTTP_ERROR_DEFINITIONS[statusCode as HttpStatus] ??
      (statusCode >= Number(HttpStatus.INTERNAL_SERVER_ERROR)
        ? INTERNAL_SERVER_ERROR
        : DEFAULT_ERROR)
    );
  }

  private getDetails(exception: unknown): ApiErrorDetails | undefined {
    if (!(exception instanceof HttpException)) {
      return undefined;
    }

    const exceptionResponse = exception.getResponse();

    if (
      typeof exceptionResponse !== 'object' ||
      exceptionResponse === null ||
      !('details' in exceptionResponse)
    ) {
      return undefined;
    }

    const details = (exceptionResponse as CustomExceptionResponse).details;

    return this.isApiErrorDetails(details) ? details : undefined;
  }

  private isCustomExceptionResponse(
    response: string | object,
  ): response is { error: string; message: string } {
    if (typeof response !== 'object' || response === null) {
      return false;
    }

    const candidate = response as CustomExceptionResponse;

    return (
      typeof candidate.error === 'string' &&
      /^[A-Z][A-Z0-9_]*$/.test(candidate.error) &&
      typeof candidate.message === 'string'
    );
  }

  private isApiErrorDetails(value: unknown): value is ApiErrorDetails {
    return typeof value === 'object' && value !== null;
  }

  private logInternalError(
    exception: unknown,
    request: Request,
    requestId: string,
  ): void {
    const message = `${request.method} ${request.originalUrl} failed [${requestId}]`;
    const trace = exception instanceof Error ? exception.stack : undefined;

    this.logger.error(message, trace);
  }
}
