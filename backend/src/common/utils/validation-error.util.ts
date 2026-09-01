import { ValidationError } from 'class-validator';
import { ValidationErrorDetail } from '../types/api-error-response.type';

export function mapValidationErrors(
  errors: ValidationError[],
  parentPath = '',
): ValidationErrorDetail[] {
  return errors.flatMap((validationError) => {
    const field = parentPath
      ? `${parentPath}.${validationError.property}`
      : validationError.property;

    const currentDetails = Object.values(validationError.constraints ?? {}).map(
      (message) => ({ field, message }),
    );

    const childDetails = mapValidationErrors(
      validationError.children ?? [],
      field,
    );

    return [...currentDetails, ...childDetails];
  });
}
