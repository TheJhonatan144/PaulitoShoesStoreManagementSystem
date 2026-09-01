# Backend de Paulito Shoes Store

API REST del sistema Paulito Shoes Store Management System, construida con
NestJS, Prisma y PostgreSQL.

## Requisitos

- Node.js `>=24 <25`
- npm `>=11`
- Docker Desktop con motor WSL2 e integración habilitada para Ubuntu
- Docker Compose

Si utilizas `nvm`, selecciona la versión declarada por el proyecto:

```bash
nvm install
nvm use
```

## Instalación

Desde la raíz del repositorio, inicia PostgreSQL:

```bash
docker compose up -d db
docker compose ps
```

Instala las dependencias:

```bash
cd backend
npm ci
```

Crea la configuración local:

```bash
cp .env.example .env
```

Genera dos secretos diferentes y copia uno en `JWT_ACCESS_SECRET` y el otro en
`JWT_REFRESH_SECRET`:

```bash
openssl rand -hex 32
openssl rand -hex 32
```

El archivo `.env` es local, está ignorado por Git y nunca debe contener secretos
compartidos en el repositorio.

Aplica las migraciones existentes:

```bash
npx prisma migrate deploy
npx prisma migrate status
```

## Variables de entorno

| Variable | Requerida | Valor local predeterminado o ejemplo |
|---|:---:|---|
| `NODE_ENV` | No | `development` |
| `PORT` | No | `3000` |
| `APP_NAME` | No | `Paulito Shoes API` |
| `APP_VERSION` | No | `1.0.0` |
| `CORS_ORIGIN` | No | `http://localhost:5173` |
| `DATABASE_URL` | Sí | URL PostgreSQL definida en `.env.example` |
| `JWT_ACCESS_SECRET` | Sí | Secreto local de al menos 32 caracteres |
| `JWT_ACCESS_EXPIRES_IN` | No | `15m` |
| `JWT_REFRESH_SECRET` | Sí | Secreto local diferente, mínimo 32 caracteres |
| `JWT_REFRESH_EXPIRES_IN` | No | `7d` |
| `BCRYPT_ROUNDS` | No | `12`, permitido entre 10 y 14 |

La aplicación valida estas variables al iniciar y falla tempranamente si alguna
configuración obligatoria es inválida.

## Ejecución

```bash
# Desarrollo con recarga
npm run start:dev

# Ejecución normal
npm run start

# Compilar y ejecutar la salida
npm run build
npm run start:prod
```

La ruta base de los módulos funcionales es:

```text
http://localhost:3000/api/v1
```

Los health checks permanecen fuera del prefijo:

```text
GET /health
GET /health/live
GET /health/ready
```

`/health/live` solo verifica el proceso. `/health` y `/health/ready` también
consultan PostgreSQL.

## Calidad y pruebas

```bash
# Comprobar formato sin modificar archivos
npm run format:check

# Aplicar formato
npm run format

# Comprobar lint
npm run lint

# Corregir problemas compatibles de lint
npm run lint:fix

# Pruebas unitarias
npm test -- --runInBand

# Pruebas e2e aisladas de infraestructura
npm run test:e2e -- --runInBand

# Validar el esquema Prisma
npx prisma validate
```

Las pruebas e2e reemplazan `PrismaService` por un mock controlado. La conexión
real puede verificarse con `npx prisma migrate status` y los health checks con el
contenedor PostgreSQL activo.

## Base técnica

La aplicación configura globalmente:

- prefijo `/api/v1` con exclusiones de salud;
- `ValidationPipe` con whitelist, rechazo de propiedades desconocidas y
  transformación;
- filtro uniforme de excepciones;
- identificador `requestId` para errores;
- CORS con credenciales;
- Helmet;
- configuración validada con Joi;
- conexión y desconexión de Prisma mediante el ciclo de vida de Nest.

## Estructura de `src`

```text
src/
├── common/       componentes transversales HTTP
├── config/       configuración y validación del entorno
├── modules/      módulos del dominio
├── prisma/       integración global con Prisma
├── app.module.ts
├── app.setup.ts
└── main.ts
```

## Detener el entorno local

Desde la raíz del repositorio:

```bash
docker compose stop db
```

Para detener y eliminar el contenedor sin borrar el volumen persistente:

```bash
docker compose down
```
