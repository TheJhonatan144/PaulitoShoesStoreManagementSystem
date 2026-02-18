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

Los datos de entrega y totales se almacenan como snapshot al momento de la confirmación.

---

# 2. Entidades MVP — Pedidos

---

## 2.1 Pedido

### Propósito
Representar una venta generada desde un ProcesoCompra confirmado.

### Atributos MVP

- id
- numeroPedido (código interno visible y único)
- clienteId (obligatorio)
- procesoCompraId
- estado (
  pendientePago,
  reservado,
  pagadoConfirmado,
  preparado,
  enviado,
  entregado,
  cancelado,
  noEntregado,
  canceladoAutomatico
)
- subtotal
- costoEnvio
- total
- metodoPago (contraEntrega, transferencia)
- tipoEntrega (domicilio, retiroEnTienda)

### Snapshot de entrega (copiados desde DireccionEntrega)

- nombreCompletoEntrega
- telefonoEntrega
- provinciaEntrega
- ciudadEntrega
- direccionLinea1Entrega
- direccionLinea2Entrega (opcional)
- referenciaEntrega (opcional)

### Control de pago

- codigoTransferencia (opcional)
- fechaReserva (opcional)
- fechaPagoConfirmado (opcional)
- fechaEntregado (opcional)

- fechaCreacion
- fechaActualizacion

---

### Reglas de Negocio

1. numeroPedido debe ser único.

2. Antes de confirmar el Pedido:
   - Validar stock nuevamente.

3. Contra entrega (solo Quito):
   - Al confirmar el pedido:
     - Se RESERVA el stock (se descuenta stockDisponible).
     - Se crea MovimientoInventario tipo reserva.
     - El estado pasa a reservado.
   - Si el pedido pasa a estado cancelado o noEntregado:
     - Se crea MovimientoInventario tipo liberacionReserva.


4. Transferencia bancaria:
   - El stock se descuenta cuando el pago es confirmado.
   - Se crea MovimientoInventario tipo salidaVenta.
   - El estado pasa a pagadoConfirmado.

5. Entregado:
   - Solo cambia el estado.
   - El stock ya debió estar reservado o descontado.

6. No entregado:
   - Aplica cuando el cliente no recibe el pedido.
   - Se debe liberar el stock si estaba reservado.

7. Al crear el Pedido:
   - El ProcesoCompra pasa a estado confirmado.
   - No puede reutilizarse.

8. Expiración automática de pago (solo transferencia):

   - Si metodoPago = transferencia, el Pedido inicia en estado pendientePago.
   - El cliente dispone de un plazo máximo de 24 horas desde fechaCreacion para confirmar el pago.
   - Si el pago no es confirmado dentro de ese plazo:
     - El estado del Pedido cambia automáticamente a canceladoAutomatico.
   - Esta expiración no requiere liberar inventario,
     ya que en transferencia no se reserva ni descuenta stock
     hasta que el pago es confirmado.

Nota:

En el caso de contraEntrega (Quito),
la reserva ya descuenta stockDisponible al confirmar el Pedido.
La transición a estado entregado no modifica inventario,
solo finaliza el ciclo operativo del Pedido.


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

- La cantidad puede representarse como positiva o negativa según tipo:
  - reserva / salidaVenta / salidaCambio → disminuyen stock
  - liberacionReserva / ingresoCambio → aumentan stock

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

- Misma referencia (otra talla).
- Otro modelo pagando diferencia.

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
  - Se genera saldo interno (CuponCliente).
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

Cliente (1) —— (N) Pedido  

Cliente (1) —— (N) CuponCliente  

Pedido (0..1) —— (1) FacturaElectronica [Post-MVP]

---

# 6. Decisiones Arquitectónicas Tomadas

✔ Se separan estados cancelado y noEntregado.  
✔ Contra entrega en Quito genera reserva de stock.  
✔ Transferencia descuenta stock al confirmar pago.  
✔ Se implementa MovimientoInventario para trazabilidad.  
✔ Se almacenan snapshots de datos de entrega en Pedido.  
✔ Se permiten cambios de modelo con diferencia.  
✔ Diferencias negativas generan saldo interno (CuponCliente).  
✔ Facturación electrónica se modela como Post-MVP.

---

# 7. Validación MVP

- [ ] Se puede crear Pedido desde ProcesoCompra.
- [ ] Se valida stock antes de confirmar.
- [ ] Se reserva stock en contra entrega Quito.
- [ ] Se descuenta stock en transferencia confirmada.
- [ ] Se registran movimientos de inventario.
- [ ] Se almacenan snapshots de entrega.
- [ ] Se permiten cambios con diferencia.
- [ ] Se generan cupones internos cuando corresponde.
- [ ] Se pueden diferenciar estados cancelado y noEntregado.
