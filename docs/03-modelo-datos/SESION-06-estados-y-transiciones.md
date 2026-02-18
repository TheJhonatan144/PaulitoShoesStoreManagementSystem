# Fase 3 - Modelo de Datos
## Sesión 6 - Estados y transiciones (MVP)

Fecha: 2026-02-12  
Tipo: Reglas de transición (sin Prisma / sin SQL)

---

# 1. Objetivo

Definir estados oficiales y transiciones válidas para evitar inconsistencias
y preparar validaciones en backend.

---

# 2. ENUMs oficiales (MVP)

## 2.1 EstadoProducto
- borrador
- activo
- archivado

## 2.2 EstadoVarianteProducto
- activo
- inactivo
- descontinuado

## 2.3 MetodoPago
- transferencia
- contraEntrega

## 2.4 MetodoPago (Post-MVP)
- tarjeta (pasarela)

Nota:
En MVP solo se soportan transferencia y contraEntrega.
El método tarjeta se incorpora en Post-MVP junto a una entidad Pago
y estados de pago (pendiente, autorizado, rechazado, confirmado).

## 2.5 TipoEntrega
- domicilio
- retiroEnTienda

## 2.6 EstadoPedido (MVP)
- pendientePago
- reservado
- pagadoConfirmado
- preparado
- enviado
- entregado
- cancelado
- noEntregado
- canceladoAutomatico

---

# 3. Transiciones permitidas de EstadoPedido

## 3.1 Transferencia (flujo principal)
pendientePago -> pagadoConfirmado -> preparado -> enviado -> entregado

Reglas:
- Si pasan 24h sin confirmación: pendientePago -> canceladoAutomatico
- Si se cancela manualmente: pendientePago -> cancelado

## 3.2 Contra entrega (solo Quito)
reservado -> preparado -> enviado -> entregado

Reglas:
- Al confirmar pedido (contraEntrega Quito): estado inicial reservado
- Si no se entrega: reservado/preparado/enviado -> noEntregado
- Si se cancela antes de entregar: reservado/preparado -> cancelado

---

# 4. Historial de estados (auditoría mínima)

## 4.1 Entidad: PedidoEstadoHistorial (MVP recomendado)

Propósito:
Registrar quién cambió el estado, cuándo y de qué estado a cuál,
para trazabilidad operativa.

Atributos lógicos:
- id
- pedidoId
- estadoAnterior
- estadoNuevo
- actorTipo (admin, vendedor, sistema)
- actorId (opcional)
- nota (opcional)
- fechaCreacion

Reglas:
- Cada cambio de estado debe crear un registro en historial.
- Cambios automáticos (canceladoAutomatico) se registran con actorTipo = sistema.

---

# 5. Estados de cambios (MVP+)

## 5.1 EstadoCambioPedido
- solicitado
- aprobado
- completado
- rechazado

# 6. Pagos con pasarela (Post-MVP)

## 6.1 Entidad: Pago

Propósito:
Modelar pagos con pasarela (tarjeta) y registrar su estado real
sin mezclar la lógica de inventario con la lógica financiera.

Atributos lógicos:
- id
- pedidoId
- proveedorPago (kushki, datafast, payphone, stripe, etc.)
- estadoPago (pendiente, autorizado, rechazado, confirmado, reembolsado)
- monto
- referenciaExterna
- fechaCreacion
