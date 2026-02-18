# Fase 3 - Modelo de Datos
## Sesión 6 - Integridad y reglas globales (MVP)

Fecha: 2026-02-17  
Tipo: Reglas transversales (sin Prisma / sin SQL)

---

# 1. Objetivo

Definir reglas transversales que aplican a múltiples módulos:
integridad referencial, unicidad, consistencia y auditoría mínima.

---

# 2. Integridad referencial (conceptual)

- No se debe permitir PedidoItem sin Pedido.
- No se debe permitir PedidoItem sin VarianteProducto.
- No se debe permitir CarritoItem sin Carrito.
- ProcesoCompra pertenece a un Carrito y se convierte en Pedido (1 a 1).

---

# 3. Reglas de consistencia cross-módulo

- Pedido se crea solo desde ProcesoCompra confirmado.
- ProcesoCompra confirmado no se reutiliza.
- Precio y datos críticos deben quedar como snapshot en Pedido/PedidoItem.
- InteresStock solo se crea si stockDisponible = 0.
- El Cliente se identifica por correo único.
- El teléfono se exige cuando tipoEntrega = domicilio o cuando el flujo requiere coordinación de entrega (checkout).
- La dirección de entrega no se utiliza como "dirección guardada": se almacena como snapshot en Pedido.

---

# 4. Estrategia de “borrado” (MVP)

- No se borra Producto/VarianteProducto: se archiva o desactiva por estado.
- Pedidos nunca se eliminan (solo cambian de estado).
- MovimientoInventario nunca se elimina (auditoría).

---

# 5. Auditoría mínima (MVP)

- fechaCreacion y fechaActualizacion en entidades principales.
- PedidoEstadoHistorial registra cambios de estado del pedido.
- MovimientoInventario registra cambios de stock.

---

# 6. Pendientes para Sesión 7

- Índices recomendados para rendimiento.
- Estrategia de transacciones y locks para confirmar stock.
- Definir precisión de precios (decimal) y moneda.
