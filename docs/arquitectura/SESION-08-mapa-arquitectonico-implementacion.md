# SESION-08 — Mapa Arquitectónico de Implementación  
## Fase 4 — Arquitectura  
### Proyecto: Paulito Shoes Store Management System

---

## 1. Objetivo

Traducir la arquitectura general a una estructura real de implementación.

Define:

- módulos del sistema
- dependencias
- orden de construcción
- estructura del backend y frontend

---

## 2. Módulos principales

### Auth
Registro, login, JWT, refresh token, roles.

### Clientes
Perfil y datos del cliente.

### Catálogo
Productos, variantes, categorías, marcas.

### Carrito
Gestión de productos antes de comprar.

### Checkout
Validación de datos antes del pedido.

### Pedidos
Creación y gestión de pedidos.

### Inventario
Reservas, liberaciones, movimientos.

### InteresesStock
Registro de interés en productos agotados.

### Admin
Gestión interna del negocio.

### Salud
Health checks del sistema.

---

## 3. Flujo principal del sistema

Auth → Catálogo → Carrito → Checkout → Pedidos → Inventario

---

## 4. Reglas de dependencia

- Controllers → solo servicios
- Servicios → lógica de negocio
- Dominio → sin dependencia de NestJS ni Prisma
- Infraestructura → acceso a base de datos
- Inventario → único módulo que modifica stock

---

## 5. Estructura del backend

```txt
backend/
├─ src/
│  ├─ common/
│  ├─ config/
│  ├─ prisma/
│  ├─ modules/
│  │  ├─ auth/
│  │  ├─ clientes/
│  │  ├─ catalogo/
│  │  ├─ carrito/
│  │  ├─ checkout/
│  │  ├─ pedidos/
│  │  ├─ inventario/
│  │  ├─ intereses-stock/
│  │  ├─ admin/
│  │  └─ salud/
```

## 6. Orden de implementacion

Etapa 1 - Base
- Config
- Prisma
- Logging
- Health

Etapa 2 - Auth
- Login
- Registro
- JWT

Etapa 3 - Catalogo
- Productos
- Variantes

Etapa 4 - Carrito
- Agregar productos
- Editar carrito

Etapa 5 - Intereses
- Registrar interes

Etapa 6 - Checkout + Pedidos
- Crear pedido
- Estados

Etapa 7 - Inventario
- Reservas
- Movimientos

Etapa 8 - Admin operativo
- Confirmar pagos
- Ver pedidos

Etapa 9 - Admin completo
- CRUD catalogos
- Inventario

Etapa 10 - Endurecimiento
- Seguridad
- Test

## 7. Estructura del frontend

```txt
frontend/
├─ src/
│  ├─ app/
│  ├─ shared/
│  ├─ features/
│  ├─ pages/
│  ├─ layouts/
```

## 8. Reglas clave de implementacion
- No modificar stock fuera de inventario
- No poner lógica en controllers
- No acoplar frontend a Prisma
- Implementar por etapas, no todo a la vez
- Mantener documentación actualizada

## 9. Resultado de la sesión

Se define: 
- arquitectura completa
- módulos del sistema
- estructura del backend
- orden de desarrollo

Con esto el sistema está listo para comenzar implementación real.
