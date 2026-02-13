# Fase 3 - Modelo de Datos
## Sesión 5 - Carrito y Proceso de Compra (Modelo Conceptual MVP)

Fecha: 2026-02-12  
Tipo: Modelo Conceptual (sin Prisma / sin SQL)

---

# 1. Objetivo del módulo (MVP)

Permitir que un cliente:

- Agregue variantes de producto al carrito.
- Ajuste cantidades (si hay stock).
- Inicie el proceso de compra y genere un borrador con datos mínimos.
- Registre dirección y datos de contacto para la entrega.
- Seleccione un método de pago real.

Regla crítica:

- Si stockDisponible = 0 en una VarianteProducto, no se puede agregar al carrito ni comprar.

El negocio permite:
- Entrega a domicilio
- Retiro en tienda
- Pago contra entrega
- Transferencia bancaria (incluye código DeUna)

---

# 2. Entidades MVP — Carrito y Proceso de Compra

---

## 2.1 Carrito

### Propósito
Representa el carrito activo de un cliente (anónimo o autenticado).

### Atributos MVP
- id
- identificadorSesion (para cliente anónimo)
- clienteId (opcional, si está autenticado)
- estado (activo, convertido, abandonado)
- fechaCreacion
- fechaActualizacion

### Reglas
- Un cliente anónimo tiene un carrito por sesión.
- Un cliente autenticado puede tener un carrito activo.
- El carrito contiene ítems (CarritoItem).

---

## 2.2 CarritoItem

### Propósito
Representa una línea del carrito: una VarianteProducto + cantidad.

### Atributos MVP
- id
- carritoId
- varianteProductoId
- cantidad
- precioUnitarioRegistrado (precio capturado al momento de agregar)
- fechaCreacion
- fechaActualizacion

### Reglas
- La cantidad debe ser >= 1.
- No se permite agregar si la variante está sin stock.
- La cantidad no debe exceder el stock disponible.
- El precioUnitarioRegistrado se guarda para trazabilidad.

---

## 2.3 DireccionEntrega

### Propósito
Guardar los datos de entrega cuando el tipoEntrega sea domicilio.

### Atributos MVP
- id
- carritoId
- clienteId (opcional)
- nombreCompleto
- telefono
- provincia
- ciudad
- direccionLinea1
- direccionLinea2 (opcional)
- referencia (opcional)
- notasEntrega (opcional)
- fechaCreacion
- fechaActualizacion

### Reglas
- Solo es obligatoria cuando tipoEntrega = domicilio.
- Puede existir aunque el cliente no esté registrado.

---

## 2.4 ProcesoCompra

### Propósito
Representa el proceso de confirmación del carrito antes de crear un Pedido.

### Atributos MVP
- id
- carritoId
- estado (iniciado, datosCompletados, confirmado, cancelado)
- subtotal
- costoEnvio
- total
- metodoPago (contraEntrega, transferencia)
- tipoEntrega (domicilio, retiroEnTienda)
- codigoTransferencia (opcional, si metodoPago = transferencia)
- fechaCreacion
- fechaActualizacion

### Reglas
- Un carrito activo puede generar un ProcesoCompra.
- tipoEntrega es obligatorio.
- Si tipoEntrega = retiroEnTienda, no se requiere DireccionEntrega.
- Si metodoPago = transferencia, puede registrarse codigoTransferencia.
- Al confirmar, se crea un Pedido (módulo siguiente).
- Antes de confirmar, debe validarse nuevamente el stock.

---

# 3. Relaciones Conceptuales

Carrito (1) —— (N) CarritoItem  

VarianteProducto (1) —— (N) CarritoItem  

Carrito (1) —— (0..1) ProcesoCompra  

Carrito (1) —— (0..1) DireccionEntrega  

Cliente (0..1) —— (N) Carrito  

Cliente (0..1) —— (N) DireccionEntrega  

---

# 4. Decisiones Arquitectónicas Tomadas (MVP)

✔ El carrito soporta clientes anónimos mediante identificadorSesion.  
✔ CarritoItem guarda precioUnitarioRegistrado para trazabilidad.  
✔ tipoEntrega es obligatorio (domicilio o retiroEnTienda).  
✔ DireccionEntrega solo es obligatoria si tipoEntrega = domicilio.  
✔ Se permite transferencia bancaria como método real de pago.  
✔ Si metodoPago = transferencia, puede registrarse codigoTransferencia.  
✔ Se valida stock antes de confirmar el ProcesoCompra.  
✔ Si stockDisponible = 0, no se permite agregar al carrito ni comprar.  

---

# 5. Validación MVP

- [ ] Se puede crear carrito anónimo (por sesión).
- [ ] Se puede crear carrito autenticado (por cliente).
- [ ] Se pueden agregar variantes con cantidad.
- [ ] No se permite agregar variantes sin stock.
- [ ] Se puede seleccionar tipoEntrega (domicilio o retiro).
- [ ] Se puede capturar dirección cuando corresponde.
- [ ] Se puede seleccionar metodoPago (contraEntrega o transferencia).
- [ ] Se puede registrar codigoTransferencia.
- [ ] Se puede confirmar el ProcesoCompra.
- [ ] El ProcesoCompra queda listo para crear Pedido.
