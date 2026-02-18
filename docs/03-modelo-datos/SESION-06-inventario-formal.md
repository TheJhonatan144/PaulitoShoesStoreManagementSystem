# Fase 3 - Modelo de Datos
## Sesión 6 - Inventario formal (MVP)

Fecha: 2026-02-17  
Tipo: Reglas lógicas de stock (sin Prisma / sin SQL)

---

# 1. Objetivo

Formalizar cómo se administra y audita el inventario para evitar sobreventa,
manteniendo rendimiento alto en catálogo.

---

# 2. Estrategia oficial (MVP)

- VarianteProducto.stockDisponible es el valor operativo principal.
- MovimientoInventario audita cada cambio (entrada/salida/ajuste).
- Ninguna acción debe modificar stockDisponible sin registrar un MovimientoInventario.

---

# 3. Reglas de consistencia

- stockDisponible nunca puede quedar negativo.
- Toda disminución/aumento de stock debe ser atómica (conceptualmente transaccional).
- Antes de confirmar ProcesoCompra/Pedido se valida stock nuevamente.

---

# 4. Tipos de MovimientoInventario y efecto

- reserva: disminuye stockDisponible
- liberacionReserva: aumenta stockDisponible
- salidaVenta: disminuye stockDisponible
- ingresoCambio: aumenta stockDisponible
- salidaCambio: disminuye stockDisponible
- ajuste: puede aumentar o disminuir (según nota)

Recomendación:
- Guardar cantidad como número positivo y aplicar signo según tipo
  (o guardar con signo y validar por tipo). Definir esto en Sesión 7.

---

# 5. Momentos clave de inventario (MVP)

## 5.1 Contra entrega (Quito)
- Al confirmar Pedido: reserva
- Si cancelado/noEntregado: liberacionReserva
- entregado: no modifica stock (solo estado)

## 5.2 Transferencia
- pendientePago: no toca stock
- pagadoConfirmado: salidaVenta
- Si canceladoAutomatico o cancelado en pendientePago: no hay movimientos de inventario.

---

# 6. Reglas anti-errores (operación real)

- Si una VarianteProducto llega a stockDisponible = 0:
  - No se permite agregar al carrito ni comprar
  - Se muestra “sin stock”
  - Se permite registrar InteresStock (único por cliente)

---

# 7. Reglas de concurrencia y consistencia (MVP)

1) El carrito NO bloquea inventario.
- Se valida stock al agregar al carrito (validación suave).
- La validación final y definitiva ocurre al confirmar el Pedido (validación fuerte).

2) Transferencia (metodoPago = transferencia)
- El Pedido inicia en estado pendientePago.
- No se reserva ni descuenta inventario en pendientePago.
- Solo al confirmar pago:
  - se registra MovimientoInventario tipo salidaVenta
  - el Pedido pasa a pagadoConfirmado
- Si pasan 24 horas sin pago:
  - Pedido -> canceladoAutomatico
  - no se libera inventario (porque no se tocó stock).

3) Contra entrega Quito (metodoPago = contraEntrega)
- Al confirmar Pedido:
  - se registra MovimientoInventario tipo reserva (disminuye stockDisponible)
  - el Pedido inicia en estado reservado
- Si el Pedido pasa a cancelado o noEntregado:
  - se registra MovimientoInventario tipo liberacionReserva (aumenta stockDisponible)
- Al marcar entregado:
  - solo cambia el estado, no modifica inventario (ya estaba reservado).

4) Regla de fallo por stock insuficiente
- Si al confirmar Pedido el stockDisponible no alcanza:
  - la confirmación debe fallar (no se crea Pedido / o se revierte la operación)
  - inventario nunca puede quedar negativo.