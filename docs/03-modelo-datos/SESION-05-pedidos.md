# Fase 3 - Modelo de Datos
## Sesión 5 - Pedidos (Modelo Conceptual MVP)

Fecha: 2026-02-12  
Tipo: Modelo Conceptual (sin Prisma / sin SQL)

---

# 1. Objetivo del módulo (MVP)

Representar la venta formal registrada en el sistema.

Un Pedido se crea cuando:
- El ProcesoCompra es confirmado.
- El stock ha sido validado.
- Se han definido método de pago y tipo de entrega.

El Pedido es el registro oficial de la transacción y base para inventario, cambios y facturación futura.

---

# 2. Entidades MVP — Pedidos

---

## 2.1 Pedido

### Propósito
Representar una venta generada desde un ProcesoCompra.

### Atributos MVP

- id
- numeroPedido (código interno visible y único)
- clienteId (opcional si fue compra anónima)
- procesoCompraId
- estado (
  pendientePago,
  reservado,
  pagadoConfirmado,
  preparado,
  enviado,
  entregado,
  cancelado,
  noEntregado
)
- subtotal
- costoEnvio
- total
- metodoPago (contraEntrega, transferencia)
- tipoEntrega (domicilio, retiroEnTienda)
- ciudadEntrega (requerido si tipoEntrega = domicilio)
- provinciaEntrega (requerido si tipoEntrega = domicilio)
- codigoTransferencia (opcional)
- fechaReserva (opcional)
- fechaPagoConfirmado (opcional)
- fechaEntregado (opcional)
- fechaCreacion
- fechaActualizacion

---

### Reglas de Negocio

1. numeroPedido debe ser único.

2. Antes de crear o confirmar el Pedido:
   - Validar stock nuevamente.

3. Contra entrega (solo aplica dentro de Quito):
   - Al confirmar el pedido:
     - Se RESERVA el stock (se descuenta stockDisponible).
     - Se crea un MovimientoInventario tipo reserva.
     - El estado pasa a reservado o preparado.
   - Si el pedido se cancela o no se entrega:
     - Se libera la reserva (MovimientoInventario tipo liberacionReserva).

4. Transferencia bancaria:
   - El stock se descuenta cuando el pago es confirmado.
   - Se crea MovimientoInventario tipo salidaVenta.
   - El estado pasa a pagadoConfirmado.

5. Entregado:
   - Solo cambia el estado.
   - El stock ya debió haber sido reservado o descontado.

6. No entregado:
   - Aplica cuando el cliente no recibe el pedido.
   - Se debe liberar el stock si estaba reservado.

---

## 2.2 PedidoItem

### Propósito
Representar cada línea vendida dentro del Pedido.

### Atributos MVP

- id
- pedidoId
- varianteProductoId
- nombreProductoRegistrado
- tallaRegistrada
- colorRegistrado
- codigoInternoRegistrado
- cantidad
- precioUnitarioRegistrado
- subtotalLinea

### Reglas

- Guarda snapshot del producto para mantener histórico.
- subtotalLinea = cantidad * precioUnitarioRegistrado.
- No depende de cambios futuros en Producto o VarianteProducto.

---

## 2.3 MovimientoInventario (MVP recomendado)

### Propósito
Registrar todos los cambios de stock de forma auditada.

### Atributos MVP

- id
- varianteProductoId
- tipo (
  reserva,
  liberacionReserva,
  salidaVenta,
  ingresoCambio,
  salidaCambio,
  ajuste
)
- cantidad
- referenciaTipo (pedido, cambio, ajusteManual)
- referenciaId
- nota (opcional)
- fechaCreacion

### Reglas

- Contra entrega (Quito):
  - Al confirmar pedido → reserva.
  - Si se cancela o no se entrega → liberacionReserva.

- Transferencia:
  - Al confirmar pago → salidaVenta.

- Cambios:
  - ingresoCambio para la variante devuelta.
  - salidaCambio para la nueva variante entregada.

---

# 3. Cambios de Producto (MVP+)

## 3.1 Regla de negocio

El cliente puede realizar cambios dentro de 15 días.
Puede cambiar por:
- Misma referencia (otra talla)
- Otro modelo pagando diferencia

---

## 3.2 CambioPedido

### Atributos

- id
- pedidoId
- estado (solicitado, aprobado, completado, rechazado)
- motivo (opcional)
- fechaSolicitud
- fechaCompletado (opcional)

---

## 3.3 CambioPedidoItem

### Atributos

- id
- cambioPedidoId
- varianteDevueltaId
- varianteEntregadaId
- cantidad
- diferenciaTotal (puede ser positiva o negativa)
- metodoAjuste (efectivo, transferencia, saldoInterno)
- nota (opcional)

### Reglas

- Puede cambiar a otro modelo.
- Si diferenciaTotal > 0:
  - El cliente paga adicional.
- Si diferenciaTotal < 0:
  - Se genera saldo interno (CupónCliente).
- Al completar:
  - ingresoCambio para lo devuelto.
  - salidaCambio para lo entregado.

---

## 3.4 CuponCliente (MVP+ recomendado)

### Propósito
Representar saldo a favor generado por cambios con diferencia negativa.

### Atributos

- id
- clienteId
- montoDisponible
- estado (activo, utilizado, vencido)
- fechaCreacion
- fechaVencimiento (opcional)

### Reglas

- Se crea cuando diferenciaTotal < 0.
- No es dinero reembolsable en efectivo en MVP.
- Puede aplicarse en futuros pedidos.

---

# 4. Post-MVP — Facturación Electrónica

Se modela desde ahora para evitar reestructuración futura.

## FacturaElectronica (Post-MVP)

### Atributos

- id
- pedidoId
- tipoComprobante
- identificacionComprador (cedula, ruc, consumidorFinal)
- emailEnvio
- claveAccesoSRI
- estado (generada, firmada, enviada, autorizada, rechazada)
- fechaEmision
- fechaAutorizacion (opcional)

---

# 5. Relaciones Conceptuales

ProcesoCompra (1) —— (1) Pedido  

Pedido (1) —— (N) PedidoItem  

VarianteProducto (1) —— (N) PedidoItem  

VarianteProducto (1) —— (N) MovimientoInventario  

Pedido (1) —— (N) MovimientoInventario  

Pedido (1) —— (N) CambioPedido  

CambioPedido (1) —— (N) CambioPedidoItem  

Cliente (0..1) —— (N) Pedido  

Cliente (1) —— (N) CuponCliente  

Pedido (0..1) —— (1) FacturaElectronica [Post-MVP]

---

# 6. Decisiones Arquitectónicas Tomadas

✔ Se separan estados cancelado y noEntregado.  
✔ Contra entrega en Quito genera reserva de stock.  
✔ Transferencia descuenta stock al confirmar pago.  
✔ Se implementa MovimientoInventario para trazabilidad.  
✔ Se permiten cambios de modelo con diferencia.  
✔ Diferencias negativas generan saldo interno (CupónCliente).  
✔ Facturación electrónica se modela como Post-MVP.

---

# 7. Validación MVP

- [ ] Se puede crear Pedido desde ProcesoCompra.
- [ ] Se valida stock antes de confirmar.
- [ ] Se reserva stock en contra entrega Quito.
- [ ] Se descuenta stock en transferencia confirmada.
- [ ] Se registran movimientos de inventario.
- [ ] Se permiten cambios con diferencia.
- [ ] Se generan cupones internos cuando corresponde.
- [ ] Se pueden diferenciar estados cancelado y noEntregado.
