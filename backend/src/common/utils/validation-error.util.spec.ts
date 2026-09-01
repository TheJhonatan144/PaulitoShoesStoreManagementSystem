import { ValidationError } from 'class-validator';
import { mapValidationErrors } from './validation-error.util';

describe('mapValidationErrors', () => {
  it('maps constraints to the API validation detail format', () => {
    const errors = [
      {
        property: 'email',
        constraints: {
          isEmail: 'El email debe tener un formato válido',
        },
      } as ValidationError,
    ];

    expect(mapValidationErrors(errors)).toEqual([
      {
        field: 'email',
        message: 'El email debe tener un formato válido',
      },
    ]);
  });

  it('uses dot notation for nested properties', () => {
    const errors = [
      {
        property: 'direccion',
        children: [
          {
            property: 'ciudad',
            constraints: {
              isNotEmpty: 'La ciudad es obligatoria',
            },
          } as ValidationError,
        ],
      } as ValidationError,
    ];

    expect(mapValidationErrors(errors)).toEqual([
      {
        field: 'direccion.ciudad',
        message: 'La ciudad es obligatoria',
      },
    ]);
  });
});
