# Sesión 10 — Configuración inicial de NestJS

## Fase 6 — Backend

Fecha de cierre: 2026-09-01  
Proyecto: Paulito Shoes Store Management System

---

## 1. Objetivo

Preparar una base técnica reproducible, segura y verificable para implementar
posteriormente autenticación, catálogo, carrito, checkout, pedidos e inventario.

Esta sesión no implementa funcionalidades completas del dominio.

## 2. Estado inicial encontrado

El repositorio ya contenía:

- un proyecto NestJS 11;
- configuración inicial con `@nestjs/config` y Joi;
- Prisma conectado a PostgreSQL;
- el esquema y una migración inicial;
- un módulo de salud;
- CORS y `ValidationPipe` global;
- estructura vacía para los módulos futuros.

Las principales brechas eran:

- entorno de Node no declarado;
- `.env.example` incompleto;
- lint que modificaba archivos durante la comprobación;
- errores de formato y manejo de promesas;
- ausencia del prefijo global REST;
- falta de cabeceras de seguridad;
- ausencia del formato uniforme de errores;
- prueba e2e obsoleta del starter de Nest;
- README del backend sin información del proyecto.

## 3. Decisiones adoptadas

### 3.1 Entorno

- Node.js 24 LTS.
- npm 11 como administrador de paquetes.
- `.nvmrc` para seleccionar Node 24.
- secretos JWT obligatorios y sin valores inseguros de respaldo.
- longitud mínima de 32 caracteres para los secretos.

### 3.2 Calidad

- `lint` solo comprueba.
- `lint:fix` realiza correcciones explícitas.
- `format:check` no modifica archivos.
- Prettier mantiene el formato uniforme del código existente.

### 3.3 Bootstrap HTTP

- prefijo global `/api/v1`;
- health checks fuera del prefijo;
- configuración consumida mediante `ConfigService`;
- CORS con credenciales;
- Helmet con configuración predeterminada;
- `Logger` nativo de Nest;
- manejo explícito de errores durante el arranque.

La configuración HTTP se centralizó en `app.setup.ts` para reutilizarla en la
aplicación y en las pruebas e2e.

### 3.4 Errores

Se implementó el contrato de la Sesión 9 con:

- `statusCode`;
- `error`;
- `message`;
- `details` opcional;
- `path`;
- `timestamp`;
- `requestId`.

El backend genera siempre `requestId` mediante `crypto.randomUUID()` y lo expone
también como `X-Request-Id`. Los errores internos no revelan trazas al cliente.

### 3.5 Prisma y salud

- Prisma conecta en `onModuleInit`;
- Prisma desconecta en `onModuleDestroy`;
- `/health/live` no consulta la base;
- `/health` y `/health/ready` ejecutan una consulta real de disponibilidad;
- el nombre del servicio procede de `ConfigService`.

### 3.6 Pruebas

Las pruebas e2e normales utilizan Prisma simulado para ser rápidas y
deterministas. La conectividad real se comprobó adicionalmente con PostgreSQL 16
en Docker.

No se incorporó `@nestjs/terminus`, porque los tres health checks actuales no
justifican esa dependencia.

## 4. Archivos principales incorporados

```text
backend/
├── .nvmrc
├── src/
│  ├── app.setup.ts
│  ├── common/
│  │  ├── filters/api-exception.filter.ts
│  │  ├── types/api-error-response.type.ts
│  │  └── utils/validation-error.util.ts
│  └── prisma/prisma.service.spec.ts
└── test/app.e2e-spec.ts
```

## 5. Verificaciones realizadas

- formato Prettier correcto;
- ESLint sin errores;
- compilación NestJS correcta;
- siete pruebas unitarias aprobadas;
- cinco pruebas e2e aprobadas;
- esquema Prisma válido;
- migración inicial aplicada;
- PostgreSQL 16 aceptando conexiones;
- `/health`, `/health/live` y `/health/ready` respondiendo correctamente;
- `/api/v1/health/live` devolviendo `404 RESOURCE_NOT_FOUND`;
- cabeceras de Helmet verificadas.

## 6. Seguridad de dependencias

Se aplicó `npm audit fix` sin `--force`. Se corrigieron vulnerabilidades dentro
de los rangos compatibles de NestJS, Express, Joi y dependencias transitivas.

Permanecen tres alertas asociadas a:

```text
prisma -> @prisma/config -> deepmerge-ts
```

La cadena corresponde al CLI de desarrollo de Prisma. No se utilizó `--force`
porque npm proponía bajar Prisma a una versión anterior. Se revisará cuando
Prisma publique o adopte una corrección compatible.

## 7. Fuera del alcance

Quedan para sesiones posteriores:

- autenticación y JWT funcionales;
- persistencia de sesiones;
- roles y guards;
- recuperación de contraseña;
- productos y variantes;
- carrito y checkout;
- pedidos e inventario;
- rate limiting;
- logging estructurado externo;
- Swagger servido por la aplicación.

## 8. Resultado

La base de NestJS queda preparada para comenzar la Sesión 11 de autenticación
sin mezclar todavía reglas de negocio con infraestructura incompleta.
