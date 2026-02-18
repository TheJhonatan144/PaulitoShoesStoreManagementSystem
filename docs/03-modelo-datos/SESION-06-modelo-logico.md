# Fase 3 - Modelo de Datos
## Sesión 6 - Modelo lógico (pre-Prisma)

Fecha: 2026-02-12  
Tipo: Modelo lógico (sin Prisma / sin SQL)

---

# 1. Objetivo de la sesión

Convertir el modelo conceptual (Sesión 5) en un modelo lógico validado,
definiendo enumeraciones, restricciones, unicidades y convenciones
para que en Sesión 7 se traduzca a Prisma sin contradicciones.

---

# 2. Decisiones confirmadas (MVP)

- Estados del sistema se modelan como ENUM (no tabla de estados).
- Producto y VarianteProducto usan estado (activo/archivado), no soft delete.
- Existe historial de cambios de estado del Pedido (auditoría mínima).
- CuponCliente no tiene vencimiento obligatorio (fecha opcional).
- stockDisponible es un campo físico en VarianteProducto.
- MovimientoInventario audita todos los cambios de stock.
- numeroPedido sigue formato PS-YYYY-XXXXXX.
- Autenticación de Clientes con correo + contraseña (MVP).
- Teléfono no es obligatorio en registro; se requiere en datos de entrega/checkout.
- No existe libreta de direcciones en MVP: la dirección se guarda como snapshot por Pedido.
---

# 3. Convenciones de nombres y consistencia

- Entidades en singular: Producto, VarianteProducto, Pedido, etc.
- Campos de auditoría: fechaCreacion, fechaActualizacion.
- Campos FK: <entidad>Id (ej: clienteId, productoId).
- Estados en minúsculas camelCase (ej: pendientePago, canceladoAutomatico).

---

# 4. Restricciones lógicas mínimas (MVP)

## 4.1 Unicidades (UNIQUE)
- VarianteProducto: (productoId + talla + color) debe ser único.
- VarianteProducto.codigoInterno debe ser único global.
- InteresStock: (varianteProductoId + clienteId) único.
- Pedido.numeroPedido debe ser único.
- Cliente.email debe ser único.

## 4.2 Requeridos (NOT NULL conceptuales)
- Carrito.clienteId obligatorio.
- ProcesoCompra.clienteId obligatorio.
- Pedido.clienteId obligatorio.
- Pedido.procesoCompraId obligatorio.
- Pedido.metodoPago y Pedido.tipoEntrega obligatorios.

## 4.3 Reglas de integridad
- Inventario nunca negativo.
- stockDisponible solo se modifica mediante MovimientoInventario.
- PedidoItem y snapshots no deben depender de cambios futuros en catálogo.

--- 

# 5. Regla de generación de numeroPedido (MVP)

Formato:
PS-YYYY-XXXXXX

Ejemplo:
PS-2026-000001

Reglas:
- Se genera al crear el Pedido.
- El correlativo es incremental y reinicia cada año.
- Debe ser único en todo el sistema (UNIQUE).
- El año (YYYY) se toma desde la fechaCreacion del Pedido.
- El correlativo (XXXXXX) se rellena con ceros a la izquierda hasta 6 dígitos.
- Si existen colisiones (concurrencia), la generación debe ser transaccional en backend
  (definir mecanismo en Sesión 7).

---

# 6. Pendientes para Sesión 7 (Prisma)

- Definir tipos exactos (string/int/decimal/date).
- Definir índices recomendados.
- Definir estrategias de transacción y concurrencia (stock).

