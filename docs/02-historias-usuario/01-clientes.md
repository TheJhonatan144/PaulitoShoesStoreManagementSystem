# Fase 2 – Historias de Usuario
## Módulo: Cliente

### 1. Explorar catálogo

#### HU-CL-01 – Ver catálogo de productos
Como cliente,
quiero ver un listado de productos del catálogo,
para elegir qué zapatos me interesan y comparar opciones.
[MVP]

---

#### HU-CL-02 – Buscar productos
Como cliente,
quiero buscar productos por nombre o palabra clave,
para encontrar rápidamente el zapato que me interesa.
[MVP]

---

### HU-CL-03-Filtrar productos
Como cliente, 
quiero filtrar los productos por talla, precio o categaria,
para reducir las opciones y encontrar lo que se ajuste a mis necesidades.
[MVP]

### HU-CL-04-Ver detalle de un producto
Como cliente,
quiero ver el detalle de un producto,
para conocer su precio, descripcion, imagenes y tallas disposibles antes de comprar.
[MVP]

---

### HU-CL-05-Seleccionar vaiantes (talla)
Como cliente, 
quiero seleccionar la talla de un producto,
para asegurarme de que el zapato que compro es el adecuado para mi.
[MVP]

---

### 2. Carrito de comparas

### HU-CL-06-Agregar producto al carrito
Como cliente,
quiero agregar un producto con su talla seleccionada al carrito,
para prepararlo para la compra.
[MVP]

---

### HU-CL-07-Ver carrito
Como cliente,
quiero ver los productos agregados a mi carrito, 
para revisar lo que estoy a punto de comprar.
[MVP]

---

### HU-CL-08 – Modificar cantidad en el carrito
Como cliente,
quiero cambiar la cantidad de un producto en el carrito,
para ajustar mi compra según lo que necesito.
[MVP]

---

### HU-CL-09 – Eliminar producto del carrito
Como cliente,
quiero eliminar un producto del carrito,
para quitar artículos que ya no deseo comprar.
[MVP]

---

### HU-CL-10 – Ver total estimado del carrito
Como cliente,
quiero ver el subtotal y total estimado de mi carrito,
para saber cuánto voy a pagar antes de continuar con la compra.
[MVP]

---

### 3. Autenticación (obligatoria)


### HU-CL-11 - Registrarme como cliente
Como cliente,
quiero crear una cuenta en la tienda,
para poder realizar compras y tener un historial de mis pedidos.
[MVP]

---

### HU-CL-12 - Iniciar Sesión
Como cliente registrado,
quiero iniciar sesión en mi cuenta,
para acceder a mi carrito y continuar con la compra.
[MVP]

---

### HU-CL-13 - Recuperar contraseña
Como cliente registrado,
quiero recuperar mi contraseña si la olvido,
para volver a acceder a mi cuenta sin problemas.
[MVP]

---

### 4. Checkout

### HU-CL-14 – Ingresar datos de envío
Como cliente autenticado,
quiero ingresar mis datos de envío,
para que mi pedido pueda ser entregado correctamente.
[MVP]

---

#### HU-CL-15 – Seleccionar método de entrega
Como cliente autenticado,
quiero seleccionar si deseo envío a domicilio o retiro en tienda,
para elegir la forma que más me convenga al recibir mi compra.
[MVP]

---

### HU-CL-16 – Ver resumen del pedido
Como cliente autenticado,
quiero ver un resumen final de mi pedido,
para confirmar productos, cantidades, método de entrega y método de pago antes de confirmar la compra.
[MVP]

---

### HU-CL-17 – Seleccionar método de pago
Como cliente autenticado,
quiero seleccionar un método de pago (transferencia bancaria o contra entrega en Quito),
para definir cómo se procesará mi pedido.
[MVP]


---

### HU-CL-18 – Confirmar pedido
Como cliente autenticado,
quiero confirmar mi pedido,
para que el sistema registre la compra y aplique las reglas de inventario correspondientes.
[MVP]

---

### 5. Pago

### HU-CL-19 – Enviar comprobante de pago por transferencia
Como cliente autenticado,
quiero enviar el comprobante de mi transferencia bancaria (incluyendo código DeUna si aplica),
para que el negocio pueda confirmar el pago y procesar mi pedido.
[MVP]

---

### HU-CL-20 – Ver estado del pedido y del pago
Como cliente autenticado,
quiero visualizar el estado de mi pedido (pendientePago, confirmado, entregado, noEntregado, cancelado o canceladoAutomatico),
para saber en qué etapa se encuentra mi compra.
[MVP]

---

### HU-CL-21 – Ver estado del pedido y del pago
Como cliente autenticado,
quiero visualizar el estado de mi pedido (pendiente de pago, confirmado, entregado, no entregado o cancelado),
para saber en qué etapa se encuentra mi compra.
[MVP]

### Reglas de pago y expiración (MVP)

Método de pago: Transferencia bancaria

- El pedido se crea en estado pendientePago.
- El stock NO se descuenta hasta que el pago sea confirmado manualmente.
- El cliente dispone de un máximo de 24 horas para enviar y confirmar el pago.
- Si el pago no es confirmado dentro de ese plazo, el sistema cambia
  automáticamente el estado del pedido a canceladoAutomatico.
- No se descuenta stock si el pago no fue confirmado.

Método de pago: Contra entrega (Quito)

- El pedido se confirma inmediatamente al ser creado.
- El stock se reserva al confirmar el pedido.
- El estado evoluciona hasta entregado o noEntregado.
- Si el pedido no se entrega, la reserva se libera y el stock vuelve a estar 
  disponible.

Justificación

- Evita acumulación de pedidos impagos.
- Mantiene inventario disponible.
- Replica el flujo real del negocio.
- Simplifica el modelo conceptual.
- Mantiene coherencia entre Fase 2 y Fase 3.


---

### 6. Post-compra mínima

### HU-CL-22 – Ver historial de pedidos
Como cliente autenticado,
quiero ver el historial de mis pedidos,
para revisar compras realizadas anteriormente.
[MVP]

---

### HU-CL-23 – Ver detalle de un pedido
Como cliente autenticado,
quiero ver el detalle de un pedido específico,
para conocer su estado y la información de la compra.
[MVP]

---

### HU-CL-24 – Recibir comprobante digital de compra
Como cliente autenticado,
quiero recibir un comprobante digital de mi compra,
para tener constancia formal del pedido realizado.
[MVP]

