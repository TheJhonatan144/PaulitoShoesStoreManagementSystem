# Fase 3 — Modelo de datos
## Sesión 5 — Identificación de entidades y relaciones

**Fecha:** 2026-02-12  
**Alcance:** Modelo conceptual (NO Prisma/SQL)

---

## 0. Reglas de la sesión

- No Prisma schema ni migraciones
- No endpoints ni pantallas
- Prioridad: MVP; marcar MVP+ / Post-MVP cuando aplique
- Orden por módulos
- Este documento funciona como índice y vista macro (los detalles viven en los documentos por módulo)

---

## 1. Mapa de módulos → documentos

### 1.1 Catálogo y variantes
- Documento: [SESION-05-catalogo-variantes.md](./SESION-05-catalogo-variantes.md)

### 1.2 Carrito y proceso de compra
- Documento: [SESION-05-carrito-checkout.md](./SESION-05-carrito-checkout.md)

### 1.3 Pedidos e inventario
- Documento: [SESION-05-pedidos.md](./SESION-05-pedidos.md)

### 1.4 Consolidación de la sesión
- Documento: [SESION-05-cierre-formal.md](./SESION-05-cierre-formal.md)

> Nota: Usuarios/Roles, Inventario/Compras (proveedores), Soporte, Marketing/Contenido y Reportes
se documentarán en sesiones posteriores (Sesión 6 en adelante).

---

## 2. Entidades consolidadas (vista macro)

### 2.1 Catálogo (MVP / MVP+)
- **Producto** (MVP)
- **VarianteProducto** (MVP)
- **Marca** (MVP)
- **Categoria** (MVP)
- **InteresStock** (MVP+)

### 2.2 Carrito y proceso de compra (MVP)
- **Carrito**
- **CarritoItem**
- **DireccionEntrega**
- **ProcesoCompra**

### 2.3 Pedidos e inventario (MVP / MVP+ / Post-MVP)
- **Pedido** (MVP)
- **PedidoItem** (MVP)
- **MovimientoInventario** (MVP)
- **CambioPedido** (MVP+)
- **CambioPedidoItem** (MVP+)
- **CuponCliente** (MVP+)
- **FacturaElectronica** (Post-MVP)

### 2.4 Usuarios (MVP)
- **Cliente** (MVP)

---

## 3. Relaciones globales (vista macro)

- Marca (1) —— (N) Producto
- Categoria (1) —— (N) Producto
- Producto (1) —— (N) VarianteProducto

- Cliente (1) —— (N) Carrito
- Carrito (1) —— (N) CarritoItem
- VarianteProducto (1) —— (N) CarritoItem
- Carrito (1) —— (0..1) DireccionEntrega
- Carrito (1) —— (0..1) ProcesoCompra

- ProcesoCompra (1) —— (1) Pedido
- Cliente (1) —— (N) Pedido
- Pedido (1) —— (N) PedidoItem
- VarianteProducto (1) —— (N) PedidoItem

- VarianteProducto (1) —— (N) MovimientoInventario
- Pedido (1) —— (N) MovimientoInventario

- Pedido (1) —— (N) CambioPedido
- CambioPedido (1) —— (N) CambioPedidoItem
- Cliente (1) —— (N) CuponCliente

- VarianteProducto (1) —— (N) InteresStock
- Cliente (1) —— (N) InteresStock

- Pedido (0..1) —— (1) FacturaElectronica [Post-MVP]

---

## 4. Decisiones arquitectónicas consolidadas (MVP)

- Autenticación obligatoria (no existe compra como invitado).
- No existe reserva al iniciar checkout.
- **Contra entrega (Quito):** al confirmar pedido se reserva stock (MovimientoInventario: `reserva`).
- **Transferencia:** stock se descuenta solo al confirmar pago (MovimientoInventario: `salidaVenta`).
- **Transferencia:** expiración automática a 24h si sigue en `pendientePago` → `canceladoAutomatico` (no afecta stock).
- Inventario nunca negativo.
- Pedido y PedidoItem almacenan snapshots (producto y entrega) para trazabilidad histórica.
- Cambios permitidos (15 días), con diferencia:
  - diferencia positiva: paga adicional
  - diferencia negativa: saldo interno (CuponCliente)
- “Me interesa” (InteresStock) es único por cliente y solo cuando stockDisponible = 0.

---

## 5. Checklist de cierre de Sesión 5

- [ ] Los documentos por módulo existen y están enlazados desde este índice.
- [ ] Entidades principales (MVP) están identificadas y coherentes.
- [ ] Relaciones globales no se contradicen con los módulos.
- [ ] Reglas críticas de stock/pago/reserva están consistentes con Fase 2.
- [ ] El modelo conceptual está listo para Sesión 6 (validación y modelo lógico).
