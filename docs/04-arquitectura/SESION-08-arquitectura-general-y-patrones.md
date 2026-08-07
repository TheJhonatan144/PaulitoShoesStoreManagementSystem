# SESION-08 — Arquitectura General y Patrones de Diseño  
## Fase 4 — Arquitectura  
### Proyecto: Paulito Shoes Store Management System

---

## 1. Objetivo arquitectónico

Definir una arquitectura técnica sólida, coherente y profesional para el sistema Paulito Shoes Store Management System, permitiendo implementar el MVP real del e-commerce sin contradicciones con el negocio.

La arquitectura busca cumplir tres objetivos:

- Académico: documentar decisiones y estructura
- Profesional: simular un sistema real
- Práctico: permitir implementación progresiva en WSL2 + Docker + NestJS

---

## 2. Principios de diseño

### Modularidad por dominio
El sistema se organiza por módulos del negocio (auth, catálogo, pedidos, etc).

### Separación de responsabilidades
Cada capa tiene una función clara (presentación, aplicación, dominio, infraestructura).

### DDD ligero
Se separan reglas de negocio sin complejidad innecesaria.

### Trazabilidad
Inventario y estados de pedido deben ser auditables.

### Coherencia con negocio real
No se contradicen reglas definidas en fases anteriores.

---

## 3. Arquitectura por capas

### Capa de presentación
Controllers, DTOs, guards, validaciones HTTP.

### Capa de aplicación
Casos de uso, orquestación de lógica.

### Capa de dominio
Reglas de negocio, validaciones, estados.

### Capa de infraestructura
Prisma, JWT, bcrypt, logs, base de datos.

---

## 4. Estilo arquitectónico

Arquitectura modular + capas internas por módulo.

Cada módulo representa una parte del negocio:

- Auth
- Clientes
- Catálogo
- Carrito
- Checkout
- Pedidos
- Inventario
- InteresesStock
- Admin
- Salud

---

## 5. Reglas de negocio clave

- El carrito no bloquea stock
- El stock solo cambia mediante MovimientoInventario
- Transferencia no reserva stock
- Contra entrega sí reserva stock
- Inventario nunca puede ser negativo
- Cliente debe estar autenticado
- Dirección es snapshot en pedido
- Interés en stock es único por cliente y variante

---

## 6. Estrategia de inventario

### Transferencia
- Pedido inicia en pendientePago
- No toca inventario
- Solo al confirmar pago se descuenta stock

### Contra entrega
- Pedido inicia en reservado
- Se descuenta stock inmediatamente
- Si falla → se libera stock
- Entregado no modifica stock

Regla oficial:

> “La reserva ya descuenta stockDisponible; la entrega no modifica stock, solo estado”

---

## 7. Estados del pedido

Estados oficiales:

- pendientePago
- reservado
- pagadoConfirmado
- preparado
- enviado
- entregado
- cancelado
- noEntregado
- canceladoAutomatico

Se implementará una máquina de estados controlada en código.

---

## 8. Seguridad base

- Hash de contraseñas: bcrypt
- JWT con access + refresh token
- Refresh token en cookie httpOnly
- Validación con class-validator
- CORS controlado
- Helmet para seguridad básica

---

## 9. Logging y observabilidad

- Logs estructurados
- Registro de requests
- Registro de errores
- Auditoría con:
  - MovimientoInventario
  - PedidoEstadoHistorial
- Health checks:
  - /health
  - /health/live
  - /health/ready

---

## 10. Patrones de diseño

- Service Layer
- Repository
- Domain Service
- Strategy (métodos de pago)
- State Machine (pedido)
- Factory simple

---

## 11. Decisiones arquitectónicas finales

### Roles
- admin
- vendedor
- cliente

### Hash
- bcrypt

### Autenticación
- access token en JSON
- refresh token en cookie httpOnly

### Admin MVP
Incluye:
- gestión de pedidos
- gestión de inventario
- CRUD de catálogo

Pero se implementa después del flujo core de compra.

---

## 12. Conclusión

La arquitectura del sistema queda definida como modular, escalable y alineada con el negocio real, permitiendo construir el MVP de forma ordenada, segura y profesional.