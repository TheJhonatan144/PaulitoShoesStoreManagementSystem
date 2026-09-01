# Paulito Shoes Store Management System

Sistema de comercio electrónico y gestión de inventario para una tienda real
de calzado ubicada en Quito, Ecuador.

El proyecto busca digitalizar el catálogo, las ventas, los pedidos y el control
de stock de Paulito Shoes Store mediante un MVP profesional y evolutivo.

## Estado actual

El proyecto completó las fases de visión, historias de usuario, modelo de datos,
arquitectura y diseño REST. La Fase 6 inició con la base técnica del backend en
NestJS.

Implementado actualmente:

- configuración validada mediante variables de entorno;
- PostgreSQL 16 con Docker Compose;
- Prisma y migración inicial;
- prefijo REST `/api/v1`;
- validación global de DTO;
- formato uniforme de errores;
- CORS y cabeceras de seguridad;
- health checks;
- pruebas unitarias y e2e de la infraestructura base.

Los módulos funcionales de autenticación, catálogo, carrito, checkout, pedidos,
inventario y administración se implementarán progresivamente.

## Tecnologías

- Node.js 24 LTS
- NestJS 11
- TypeScript
- Prisma 6
- PostgreSQL 16
- Docker Compose
- Jest y Supertest

## Estructura

```text
.
├── backend/   API NestJS y modelo Prisma
├── docs/      documentación por fases
└── docker-compose.yml
```

## Inicio rápido

```bash
docker compose up -d db
cd backend
npm ci
cp .env.example .env
```

Antes de iniciar, reemplaza los secretos JWT de `.env` con dos valores locales
diferentes. Consulta las instrucciones completas en
[backend/README.md](backend/README.md).

```bash
npx prisma migrate deploy
npm run start:dev
```

La API se ejecuta por defecto en `http://localhost:3000`.

## Documentación principal

- [Visión y alcance](docs/01-vision-y-alcance/01_Vision_y_Alcance_Paulito_Shoes_Store.md)
- [Historias de usuario](docs/02-historias-usuario/README.md)
- [Arquitectura general](docs/04-arquitectura/SESION-08-arquitectura-general-y-patrones.md)
- [Diseño de la API REST](docs/05-diseno-api/SESION-09-diseno-api-rest.md)
- [Contrato OpenAPI](docs/05-diseno-api/openapi/paulito-shoes-api-v1.yaml)
- [Sesión 10: configuración inicial de NestJS](docs/06-backend/SESION-10-configuracion-inicial-nestjs.md)
