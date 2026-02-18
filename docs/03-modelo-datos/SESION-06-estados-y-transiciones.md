# Fase 3 - Modelo de Datos
## Sesión 6 - Estados y transiciones (MVP)

Fecha: 2026-02-12  
Tipo: Reglas de transición (sin Prisma / sin SQL)

---

# 1. Objetivo

Definir estados oficiales y transiciones válidas para evitar inconsistencias
y preparar validaciones en backend.

---

# 2. ENUMs oficiales (MVP y Post-MVP)

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
- Al crear el Pedido con transferencia: estado inicial pendientePago.

## 3.2 Contra entrega (solo Quito)
reservado -> preparado -> enviado -> entregado

Reglas:
- Al confirmar pedido (contraEntrega Quito): estado inicial reservado
- Si no se entrega: reservado/preparado/enviado -> noEntregado
- Si se cancela antes de entregar: reservado/preparado -> cancelado

Nota (retiro en tienda):
En MVP no se incluye un estado separado "listoRetiro".      
Para pedidos con tipoEntrega = retiroEnTienda, el estado "preparado" significa
"listo para retiro".

Nota (confirmación):
En MVP no se utiliza un estado genérico "confirmado".       
La confirmación se representa con estados específicos según método de pago:

- contraEntrega (Quito): reservado
- transferencia: pagadoConfirmado

Nota (concurrencia):
El stock se valida de forma definitiva al confirmar el Pedido.
Si no existe stock suficiente en ese momento, la confirmación falla y no se permite crear el Pedido.


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
- actorId es obligatorio solo cuando actorTipo = admin o vendedor.
- Si actorTipo = sistema, actorId debe ser NULL.

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
