export interface ValidationErrorDetail {
  field: string;
  message: string;
}

export type ApiErrorDetails = ValidationErrorDetail[] | Record<string, unknown>;

export interface ApiErrorResponse {
  statusCode: number;
  error: string;
  message: string;
  details?: ApiErrorDetails;
  path: string;
  timestamp: string;
  requestId: string;
}
