# Fase 3 - Modelo de Datos
## Sesión 5 - Cierre Formal

Fecha: 2026-02-17  
Tipo: Consolidación de modelo conceptual (MVP)

---

# 1. Objetivo del Cierre

Formalizar la identificación de entidades y relaciones del sistema,
garantizando coherencia con Fase 2 (Historias de Usuario) y con las reglas de negocio reales.

Este documento consolida:

- Entidades MVP y MVP+
- Relaciones globales
- Decisiones arquitectónicas clave
- Validación de consistencia

---

# 2. Entidades Finales Identificadas

## 2.1 Módulo Catálogo

MVP:
- Producto
- VarianteProducto

MVP+:
- InteresStock

---

## 2.2 Módulo Carrito y Proceso de Compra

MVP:
- Carrito
- CarritoItem
- DireccionEntrega
- ProcesoCompra

---

## 2.3 Módulo Pedidos

MVP:
- Pedido
- PedidoItem
- MovimientoInventario

MVP+:
- CambioPedido
- CambioPedidoItem
- CuponCliente

Post-MVP:
- FacturaElectronica

---

## 2.4 Módulo Usuario

MVP:
- Cliente

(Post-MVP se modelarán roles internos formales)

---

# 3. Relaciones Globales Consolidadas

Producto (1) —— (N) VarianteProducto  

VarianteProducto (1) —— (N) CarritoItem  

VarianteProducto (1) —— (N) PedidoItem  

VarianteProducto (1) —— (N) MovimientoInventario  

Carrito (1) —— (N) CarritoItem  

Carrito (1) —— (0..1) ProcesoCompra  

ProcesoCompra (1) —— (1) Pedido  

Pedido (1) —— (N) PedidoItem  

Pedido (1) —— (N) MovimientoInventario  

Pedido (1) —— (N) CambioPedido  

CambioPedido (1) —— (N) CambioPedidoItem  

Cliente (1) —— (N) Pedido  

Cliente (1) —— (N) Carrito  

Cliente (1) —— (N) CuponCliente  

Pedido (0..1) —— (1) FacturaElectronica [Post-MVP]

---

# 4. Decisiones Arquitectónicas Globales Confirmadas

✔ Autenticación obligatoria (no existe compra anónima).  
✔ No existe reserva al iniciar checkout.  
✔ Contra entrega (Quito) genera reserva al confirmar pedido.  
✔ Transferencia descuenta inventario solo al confirmar pago.  
✔ Transferencia expira automáticamente en 24 horas si no se confirma.  
✔ Inventario nunca se vuelve negativo.  
✔ MovimientoInventario centraliza toda modificación de stock.  
✔ Snapshot de producto y entrega en Pedido.  
✔ Se permite cambio de modelo con diferencia económica.  
✔ Diferencias negativas generan saldo interno (CuponCliente).  

---

# 5. Simplificaciones Logradas

Gracias a las decisiones tomadas:

- No se necesita tabla de reserva temporal.
- No se necesita sesión anónima.
- No se necesita expiración de carrito.
- No se necesita rollback complejo.
- No existe pago mock.
- No existe ambigüedad en reglas de inventario.

El modelo conceptual queda limpio, consistente y profesional.

---

# 6. Validación Final de Sesión 5

- [ ] Todas las historias MVP tienen al menos una entidad asociada.
- [ ] No existen entidades redundantes.
- [ ] Las reglas de negocio están formalizadas.
- [ ] Los estados del pedido están definidos.
- [ ] Las decisiones de inventario son coherentes.
- [ ] No existen contradicciones entre Fase 2 y Fase 3.
- [ ] El modelo está listo para validación lógica (Sesión 6).

---

# 7. Resultado de la Sesión

Sesión 5 queda oficialmente cerrada.

El sistema cuenta ahora con:

- Modelo conceptual completo del flujo de venta.
- Inventario formalizado.
- Estados claros.
- Reglas reales de negocio.
- Base sólida para diseño lógico y traducción a Prisma.

Siguiente paso natural:

Sesión 6 — Modelo lógico y validación estructural.
