# Sesión 9 — Diseño de la API REST

## Paulito Shoes Store Management System

| Campo | Detalle |
|---|---|
| Fase | 5 — Diseño de API |
| Sesión | 9 |
| Tema | Definición de endpoints REST |
| Estado | En progreso |
| Versión del documento | 1.0 |
| Ruta base | `/api/v1` |

---

## 1. Objetivo de la sesión

Definir el contrato inicial de la API REST de Paulito Shoes Store, estableciendo los recursos, endpoints, métodos HTTP, niveles de acceso, estructuras de solicitud y respuesta, códigos de estado y convenciones generales que orientarán la implementación posterior del backend y su integración con el frontend.

La sesión se concentra en el diseño de la comunicación entre los clientes del sistema y el backend. La implementación completa de controladores, servicios, casos de uso y repositorios se realizará progresivamente durante la fase de backend.

---

## 2. Contexto previo

Antes de iniciar la Sesión 9, el proyecto cuenta con:

- requerimientos y alcance documentados;
- historias de usuario para cliente, administrador y vendedor;
- modelo lógico validado;
- modelo de datos implementado con Prisma;
- PostgreSQL ejecutándose mediante Docker;
- arquitectura modular por dominio;
- separación conceptual por capas;
- configuración global de NestJS;
- validación de variables de entorno;
- integración global de Prisma;
- endpoints técnicos de salud;
- entorno oficial de desarrollo en WSL2 Ubuntu.

Los endpoints técnicos existentes son:

```http
GET /health
GET /health/live
GET /health/ready
```


## 3. Alcance de la sesión

Durante esta sesión se definirán los contratos iniciales de los siguientes módulos:

1. Salud y disponibilidad.
2. Autenticación.
3. Clientes.
4. Catálogo y variantes.
5. Carrito.
6. Checkout.
7. Pedidos y devoluciones.
8. Inventario.
9. Intereses por variantes sin stock.
10. Operaciones administrativas.

El diseño funcionará como contrato y mapa de implementación progresiva. La existencia de un endpoint en este documento no implica que deba desarrollarse inmediatamente dentro del MVP.

---

## 4. Resultados esperados

Al finalizar la Sesión 9, el proyecto deberá contar con:

- convenciones REST documentadas;
- ruta base y estrategia de versionado;
- inventario de endpoints por módulo;
- definición de accesos por rol;
- estructuras generales de solicitud y respuesta;
- formato uniforme de errores;
- reglas de paginación, filtrado y ordenamiento;
- códigos HTTP definidos;
- reglas de negocio relevantes para la API;
- trazabilidad inicial con las historias de usuario;
- especificación OpenAPI inicial.

---

## 5. Convenciones REST

### 5.1 Ruta base

La API utilizará como prefijo general:

`/api/v1`

### 5.2 Versionado

La API utilizará versionado mediante la URL.

La primera versión será:

`/api/v1`

Si en el futuro se introducen cambios incompatibles con el contrato actual, se podrá crear una nueva versión:

`/api/v2`

El versionado permitirá mantener compatibilidad con clientes anteriores mientras se desarrolla una nueva versión del sistema.

### 5.3 Idioma de las rutas

Las rutas de la API se definirán principalmente en español para mantener coherencia con:

- la documentación del proyecto;
- las historias de usuario;
- el dominio del negocio;
- los nombres funcionales utilizados por el equipo.

Ejemplos:

`/api/v1/productos`

`/api/v1/clientes`

`/api/v1/pedidos`

`/api/v1/inventario`

Los términos técnicos ampliamente utilizados podrán conservarse en inglés cuando su uso sea más claro y reconocible dentro del desarrollo web.

Ejemplos:

`/api/v1/auth/login`

`/api/v1/auth/logout`

`/api/v1/auth/refresh`

Esta decisión busca mantener una API comprensible para el equipo sin forzar traducciones artificiales de términos técnicos ampliamente aceptados.

### 5.4 Nombres de recursos

Las rutas utilizarán sustantivos en plural para representar colecciones de recursos.

Ejemplos correctos:

`GET /api/v1/productos`

`GET /api/v1/clientes`

`GET /api/v1/pedidos`

`GET /api/v1/categorias`

Para consultar un recurso específico se agregará su identificador como parámetro de ruta.

Ejemplos:

`GET /api/v1/productos/:productoId`

`GET /api/v1/clientes/:clienteId`

`GET /api/v1/pedidos/:pedidoId`

Se evitará incluir verbos en las rutas cuando la operación pueda expresarse mediante el método HTTP.

Ejemplos que deben evitarse:

`GET /api/v1/obtener-productos`

`POST /api/v1/crear-pedido`

`PATCH /api/v1/actualizar-cliente/:clienteId`

`DELETE /api/v1/eliminar-producto/:productoId`

En su lugar, se utilizarán rutas orientadas a recursos:

`GET /api/v1/productos`

`POST /api/v1/pedidos`

`PATCH /api/v1/clientes/:clienteId`

`DELETE /api/v1/productos/:productoId`

Los nombres de recursos deberán ser:

- descriptivos;
- consistentes;
- fáciles de relacionar con el dominio;
- escritos en minúsculas;
- separados mediante guiones cuando contengan más de una palabra.

Ejemplos:

`/api/v1/intereses-stock`

`/api/v1/metodos-pago`

`/api/v1/movimientos-inventario`

Se evitarán abreviaturas ambiguas o nombres excesivamente técnicos que no representen claramente el dominio del negocio.

### 5.5 Métodos HTTP

La API utilizará los métodos HTTP de acuerdo con la operación que se realiza sobre cada recurso.

| Método | Uso principal | Ejemplo |
|---|---|---|
| `GET` | Consultar uno o varios recursos | `GET /api/v1/productos` |
| `POST` | Crear un recurso o iniciar una operación | `POST /api/v1/pedidos` |
| `PUT` | Reemplazar completamente un recurso | `PUT /api/v1/carrito/direccion-entrega` |
| `PATCH` | Actualizar parcialmente un recurso | `PATCH /api/v1/clientes/me` |
| `DELETE` | Eliminar o desactivar un recurso | `DELETE /api/v1/carrito/items/:itemId` |

#### Uso de GET

`GET` se utilizará para consultar información sin modificar el estado del sistema.

Ejemplos:

`GET /api/v1/productos`

`GET /api/v1/productos/:productoId`

`GET /api/v1/pedidos/:pedidoId`

Las solicitudes `GET` no deberán incluir datos de modificación en el cuerpo de la petición.

#### Uso de POST

`POST` se utilizará para crear nuevos recursos o ejecutar operaciones que generen un cambio en el sistema.

Ejemplos:

`POST /api/v1/auth/registro`

`POST /api/v1/carrito/items`

`POST /api/v1/pedidos`

También podrá utilizarse para operaciones especiales que no correspondan directamente a un CRUD tradicional.

Ejemplos:

`POST /api/v1/auth/login`

`POST /api/v1/auth/refresh`

`POST /api/v1/checkout/confirmar`

#### Uso de PUT

`PUT` se reservará para operaciones que reemplacen completamente la representación de un recurso.

Ejemplo:

`PUT /api/v1/carrito/direccion-entrega`

El cliente deberá enviar todos los campos obligatorios del recurso, incluso aquellos que no hayan cambiado.

Debido a que la mayoría de actualizaciones del sistema serán parciales, el uso de `PUT` será menos frecuente que el de `PATCH`.

#### Uso de PATCH

`PATCH` se utilizará para actualizar uno o varios campos de un recurso sin reemplazarlo completamente.

Ejemplos:

`PATCH /api/v1/clientes/me`

`PATCH /api/v1/admin/productos/:productoId`

`PATCH /api/v1/admin/pedidos/:pedidoId/estado`

El cuerpo de la solicitud contendrá únicamente los campos que deben modificarse.

#### Uso de DELETE

`DELETE` se utilizará para eliminar recursos temporales o solicitar la desactivación de recursos persistentes.

Ejemplos:

`DELETE /api/v1/carrito/items/:itemId`

`DELETE /api/v1/carrito/direccion-entrega`

`DELETE /api/v1/admin/productos/:productoId`

Cuando el recurso tenga valor histórico o relaciones comerciales, la operación podrá realizar una eliminación lógica en lugar de borrar físicamente el registro.

#### Restricciones generales

No se utilizarán métodos HTTP para operaciones distintas de su propósito.

Se evitarán prácticas como:

`GET /api/v1/productos/eliminar/:productoId`

`POST /api/v1/productos/consultar`

`PUT /api/v1/auth/login`

La combinación entre método y ruta deberá expresar claramente la intención de cada operación.

### 5.6 Identificadores

Los recursos individuales se identificarán mediante parámetros de ruta descriptivos.

Ejemplos:

`GET /api/v1/productos/:productoId`

`GET /api/v1/pedidos/:pedidoId`

`PATCH /api/v1/variantes/:varianteId`

Se utilizarán nombres específicos para los parámetros en lugar de identificadores genéricos cuando una ruta pueda contener varios recursos.

Se recomienda:

`/productos/:productoId`

En lugar de:

`/productos/:id`

Esta convención facilita la lectura y evita ambigüedades en rutas anidadas.

Ejemplo:

`POST /api/v1/productos/:productoId/variantes/:varianteId/imagenes`

Los identificadores expuestos por la API utilizarán el formato CUID definido actualmente en el modelo de datos de Prisma y se representarán como cadenas.

El cliente no deberá asumir que los identificadores son secuenciales ni utilizarlos para inferir información sobre la cantidad de registros existentes.


### 5.7 Recursos relacionados

Los recursos relacionados podrán representarse mediante rutas anidadas cuando la relación sea necesaria para comprender la operación.

Ejemplos:

`GET /api/v1/productos/:productoId/variantes`

`POST /api/v1/productos/:productoId/variantes`

`GET /api/v1/carrito/direccion-entrega`

`PUT /api/v1/carrito/direccion-entrega`

Las rutas anidadas se utilizarán principalmente para:

- consultar recursos que pertenecen a otro recurso;
- crear recursos dentro de un contexto específico;
- expresar relaciones claras del dominio;
- evitar que el cliente deba enviar identificadores redundantes en el cuerpo.

Por ejemplo, al crear una variante dentro de un producto:

`POST /api/v1/admin/productos/:productoId/variantes`

El identificador del producto se obtiene desde la ruta, por lo que no será necesario repetir `productoId` en el cuerpo de la solicitud.

Ejemplo de cuerpo:

```json
{
  "talla": 40,
  "color": "negro",
  "tipoSerie": "mediana",
  "precio": 49.99,
  "codigoInterno": "PS-DEP-NEG-40"
}
```

La variante se creará inicialmente con stock disponible igual a cero. El stock inicial deberá registrarse mediante una operación del módulo de inventario para garantizar la creación del movimiento correspondiente.

Se evitará utilizar demasiados niveles de anidación, ya que las rutas excesivamente profundas dificultan su lectura y mantenimiento.

Ejemplo que debe evitarse:

`/api/v1/clientes/:clienteId/pedidos/:pedidoId/items/:itemId/variante/:varianteId`

Cuando un recurso tenga identidad propia y pueda gestionarse independientemente, se utilizará una ruta directa.

Ejemplo recomendado:

`PATCH /api/v1/admin/variantes/:varianteId`

En lugar de:

`PATCH /api/v1/admin/productos/:productoId/variantes/:varianteId`

La ruta anidada se utilizará para representar el contexto de creación o consulta, mientras que la ruta directa se utilizará para modificar o desactivar un recurso identificado de manera única.

### 5.8 Operaciones especiales

Las operaciones que no puedan representarse claramente mediante un CRUD tradicional podrán expresarse mediante acciones explícitas dentro de la ruta.

Estas operaciones deberán utilizarse únicamente cuando exista una acción de negocio específica y no sea suficiente trabajar directamente con un recurso mediante `GET`, `POST`, `PUT`, `PATCH` o `DELETE`.

Ejemplos:

`POST /api/v1/auth/login`

`POST /api/v1/auth/logout`

`POST /api/v1/auth/refresh`

`POST /api/v1/checkout/validar`

`POST /api/v1/checkout/confirmar`

`PATCH /api/v1/admin/pedidos/:pedidoId/estado`

En estos casos, términos como `login`, `logout`, `refresh`, `validar`, `confirmar` y `estado` representan operaciones concretas del dominio o del flujo de autenticación.

Se evitará crear acciones explícitas cuando la operación pueda expresarse correctamente mediante una ruta orientada a recursos.

Ejemplo que debe evitarse:

`POST /api/v1/productos/crear`

En su lugar se utilizará:

`POST /api/v1/productos`

Otro ejemplo que debe evitarse:

`POST /api/v1/clientes/:clienteId/actualizar`

En su lugar se utilizará:

`PATCH /api/v1/clientes/:clienteId`

Las operaciones especiales deberán cumplir las siguientes condiciones:

- representar una acción de negocio claramente identificable;
- utilizar un método HTTP coherente;
- evitar duplicar operaciones CRUD existentes;
- mantener nombres breves y comprensibles;
- documentar sus efectos y posibles estados resultantes;
- protegerse mediante autenticación y autorización cuando corresponda.

En operaciones sensibles, como la confirmación de checkout, el cierre de sesión o el cambio de estado de un pedido, el backend deberá validar que la transición solicitada sea válida antes de aplicar el cambio.

### 5.9 Formato de datos

La API recibirá y responderá información principalmente en formato JSON.

Las solicitudes que incluyan un cuerpo deberán utilizar el encabezado:

`Content-Type: application/json`

Las respuestas JSON utilizarán el encabezado:

`Content-Type: application/json`

Ejemplo de solicitud:

```json
{
  "email": "cliente@example.com",
  "password": "ContrasenaSegura123"
}
```

Ejemplo de respuesta:

```json
{
  "data": {
    "id": "cm123example456",
    "email": "cliente@example.com",
    "rol": "cliente"
  }
}
```

Las propiedades JSON utilizarán la convención `camelCase`.

Ejemplo:

```json
{
  "productoId": "cm123producto456",
  "precioUnitario": 49.99,
  "stockDisponible": 12,
  "creadoEn": "2026-08-06T23:45:00.000Z"
}
```

Se evitará exponer directamente nombres internos de tablas, columnas o estructuras específicas de Prisma cuando estos no sean adecuados para el contrato público de la API.

Aunque la base de datos utilice nombres distintos o relaciones internas, la API deberá mantener propiedades comprensibles y consistentes para el frontend.

Los valores monetarios serán representados con precisión decimal y nunca se calcularán utilizando valores enviados por el cliente como fuente definitiva.

Ejemplo:

```json
{
  "subtotal": 89.98,
  "descuento": 5.00,
  "costoEnvio": 3.00,
  "total": 87.98,
  "moneda": "USD"
}
```

El backend será responsable de calcular y validar:

- precios;
- descuentos;
- impuestos cuando correspondan;
- costo de envío;
- total del pedido.

Los valores booleanos utilizarán únicamente `true` o `false`.

No se utilizarán representaciones ambiguas como:

- `"si"`;
- `"no"`;
- `1`;
- `0`.

Los valores nulos se representarán mediante `null` cuando una propiedad opcional no tenga valor.

Ejemplo:

```json
{
  "segundoNombre": null
}
```

Las propiedades sensibles no deberán incluirse en las respuestas.

Entre ellas:

- hash de contraseña;
- refresh tokens;
- secretos de autenticación;
- datos internos de seguridad;
- credenciales de servicios externos;
- información técnica que no sea necesaria para el cliente.

### 5.10 Fechas y horas

Las fechas y horas expuestas por la API utilizarán el estándar ISO 8601.

Ejemplo:

```json
{
  "creadoEn": "2026-08-07T00:15:00.000Z"
}
```

La API almacenará y devolverá las fechas y horas utilizando la zona horaria UTC.

El sufijo `Z` indica que el valor corresponde a UTC.

El frontend será responsable de convertir estas fechas a la zona horaria local del usuario para su presentación.

Por ejemplo, una fecha recibida desde la API podrá mostrarse en la zona horaria de Ecuador sin modificar el valor original almacenado en el backend.

Las propiedades relacionadas con fechas y horas utilizarán nombres descriptivos en `camelCase`.

Ejemplos:

```json
{
  "creadoEn": "2026-08-07T00:15:00.000Z",
  "actualizadoEn": "2026-08-07T01:30:00.000Z",
  "pagadoEn": null,
  "enviadoEn": null,
  "entregadoEn": null
}
```

Cuando una acción todavía no haya ocurrido, su fecha podrá representarse mediante `null`.

Ejemplo:

```json
{
  "estado": "preparado",
  "pagadoEn": "2026-08-07T00:20:00.000Z",
  "enviadoEn": null,
  "entregadoEn": null
}
```

Las fechas que no requieran una hora específica podrán representarse mediante el formato:

`YYYY-MM-DD`

Ejemplo:

```json
{
  "fechaNacimiento": "2004-09-09"
}
```

Los parámetros de consulta relacionados con períodos de tiempo seguirán la misma convención.

Ejemplo:

`GET /api/v1/admin/pedidos?desde=2026-08-01&hasta=2026-08-31`

Cuando los parámetros representen fechas completas, se utilizará el formato `YYYY-MM-DD`.

Cuando sea necesario representar una fecha con hora exacta, se utilizará ISO 8601 completo.

Ejemplo:

`2026-08-07T00:15:00.000Z`

El backend deberá validar que:

- las fechas tengan un formato válido;
- la fecha inicial no sea posterior a la fecha final;
- las fechas requeridas no sean nulas;
- las fechas futuras o pasadas sean aceptables según la regla de negocio;
- las transiciones temporales mantengan coherencia.

Por ejemplo, un pedido no podrá tener una fecha de entrega anterior a su fecha de envío.

### 5.11 Nombres de propiedades JSON

Las propiedades expuestas por la API utilizarán la convención `camelCase`.

Ejemplo:

```json
{
  "productoId": "cm123producto456",
  "nombreProducto": "Zapato deportivo",
  "precioUnitario": 49.99,
  "stockDisponible": 12,
  "creadoEn": "2026-08-07T00:15:00.000Z"
}
```

Se evitará utilizar otras convenciones dentro del contrato público de la API.

Ejemplos que deben evitarse:

```json
{
  "producto_id": "cm123producto456",
  "NombreProducto": "Zapato deportivo",
  "PRECIO_UNITARIO": 49.99
}
```

Aunque la base de datos utilice nombres en `snake_case` o convenciones internas diferentes, la API deberá transformar sus propiedades para mantener un contrato uniforme.

Los nombres deberán ser:

- descriptivos;
- breves, pero no ambiguos;
- coherentes con el dominio;
- consistentes entre solicitudes y respuestas;
- fáciles de relacionar con los campos utilizados por el frontend.

Se preferirá:

```json
{
  "stockDisponible": 10,
  "precioUnitario": 49.99,
  "costoEnvio": 3.00
}
```

En lugar de:

```json
{
  "stock": 10,
  "precio": 49.99,
  "costo": 3.00
}
```

Cuando una propiedad represente un identificador, deberá indicar claramente el recurso relacionado.

Ejemplos:

```json
{
  "productoId": "cm123producto456",
  "varianteId": "cm123variante456",
  "clienteId": "cm123cliente456",
  "pedidoId": "cm123pedido456"
}
```

Se evitará utilizar únicamente `id` dentro de objetos que contengan varios recursos relacionados, excepto cuando el contexto haga evidente a qué recurso pertenece.

Ejemplo válido:

```json
{
  "id": "cm123example456",
  "nombre": "Zapato deportivo",
  "activo": true
}
```

Ejemplo que puede resultar ambiguo:

```json
{
  "id": "cm123example456",
  "producto": "cm123producto456",
  "cliente": "cm123cliente456"
}
```

En su lugar se utilizará:

```json
{
  "pedidoId": "cm123pedido456",
  "productoId": "cm123producto456",
  "clienteId": "cm123cliente456"
}
```

Las propiedades booleanas deberán expresar claramente una condición.

Ejemplos:

```json
{
  "activo": true,
  "disponible": true,
  "requiereEnvio": false,
  "correoVerificado": true
}
```

Se evitarán nombres ambiguos como:

```json
{
  "estado": true,
  "valor": false
}
```

Las colecciones utilizarán nombres en plural.

Ejemplo:

```json
{
  "productos": [],
  "variantes": [],
  "direcciones": []
}
```

Los objetos individuales utilizarán nombres en singular cuando se encuentren dentro de una estructura mayor.

Ejemplo:

```json
{
  "cliente": {
    "id": "cm123example456",
    "nombre": "Cliente de ejemplo"
  }
}
```

---

### 5.12 Eliminación de recursos

La eliminación de recursos dependerá de su naturaleza y de su importancia para la trazabilidad del sistema.

Se distinguirán dos estrategias:

1. Eliminación física.
2. Eliminación lógica.

#### Eliminación física

La eliminación física borrará definitivamente el registro de la base de datos.

Se utilizará únicamente para recursos temporales o que no tengan valor histórico.

Ejemplos:

- elementos del carrito;
- sesiones expiradas;
- tokens invalidados;
- archivos temporales;
- direcciones que no estén asociadas a pedidos históricos.

Ejemplo de endpoint:

`DELETE /api/v1/carrito/items/:itemId`

Una eliminación exitosa podrá responder con el código HTTP `204 No Content`.

#### Eliminación lógica

La eliminación lógica conservará el registro, pero impedirá que continúe utilizándose dentro de operaciones activas.

Podrá representarse mediante propiedades como:

```json
{
  "activo": false
}
```

También podrá utilizarse una fecha de desactivación:

```json
{
  "eliminadoEn": "2026-08-07T00:15:00.000Z"
}
```

La eliminación lógica se utilizará especialmente para:

- productos;
- variantes;
- categorías;
- clientes;
- usuarios;
- proveedores;
- registros relacionados con pedidos;
- entidades necesarias para auditoría.

Esta estrategia permitirá mantener:

- historial de pedidos;
- movimientos de inventario;
- relaciones con clientes;
- reportes comerciales;
- trazabilidad administrativa;
- consistencia referencial.

Un producto desactivado no deberá aparecer normalmente en el catálogo público, pero deberá seguir existiendo para consultar pedidos históricos en los que haya participado.

Ejemplo:

`DELETE /api/v1/admin/productos/:productoId`

Aunque el método utilizado sea `DELETE`, internamente la operación podrá cambiar el estado del producto a inactivo sin borrar físicamente el registro.

La documentación de cada endpoint deberá indicar si la operación realiza una eliminación física o lógica.

No se permitirá eliminar recursos cuando la operación pueda romper reglas de integridad o destruir información comercial necesaria.

Cuando un recurso no pueda eliminarse debido a relaciones activas, la API deberá devolver un error de negocio adecuado.

Ejemplo:

```json
{
  "statusCode": 409,
  "error": "RESOURCE_IN_USE",
  "message": "El producto no puede eliminarse porque tiene pedidos asociados"
}
```

---

### 5.13 Idempotencia

La idempotencia permite repetir una solicitud sin producir efectos adicionales después de la primera ejecución exitosa.

Los métodos de consulta y actualización deberán procurar un comportamiento idempotente cuando corresponda.

Generalmente se consideran idempotentes:

- `GET`;
- `PUT`;
- `DELETE`;
- determinadas operaciones con `PATCH`.

Por ejemplo, ejecutar varias veces:

`DELETE /api/v1/carrito/items/:itemId`

no deberá crear efectos adicionales después de que el elemento haya sido eliminado.

Las operaciones de creación mediante `POST` no son idempotentes por naturaleza.

Por esta razón, las operaciones críticas deberán protegerse contra solicitudes duplicadas.

Entre ellas:

- confirmación del checkout;
- creación de pedidos;
- registro de pagos;
- solicitudes de devolución;
- movimientos manuales de inventario;
- creación de reembolsos.

En una fase posterior se podrá utilizar el encabezado:

`Idempotency-Key: valor-unico`

Ejemplo:

```http
POST /api/v1/checkout/confirmar
Idempotency-Key: 92fdb37c-2f14-46fb-857d-41485d09db77
Content-Type: application/json
```

El backend almacenará temporalmente la clave de idempotencia junto con el resultado de la operación.

Si el cliente repite la misma solicitud con la misma clave, el backend deberá devolver el resultado previamente registrado en lugar de crear un segundo pedido.

La clave deberá:

- ser única por operación;
- ser generada por el cliente;
- tener un período de validez limitado;
- relacionarse con el usuario autenticado;
- asociarse con el contenido de la solicitud;
- impedir el procesamiento duplicado.

Si una misma clave se utiliza con datos diferentes, la API deberá rechazar la solicitud.

Ejemplo de respuesta:

```json
{
  "statusCode": 409,
  "error": "IDEMPOTENCY_KEY_CONFLICT",
  "message": "La clave de idempotencia ya fue utilizada con una solicitud diferente"
}
```

Para el MVP, la idempotencia podrá documentarse como una medida preparada para operaciones críticas y aplicarse progresivamente al implementar checkout y pagos.

---

## 6. Autenticación y autorización

La API utilizará autenticación basada en JSON Web Tokens para identificar a los usuarios y proteger los recursos privados del sistema.

El mecanismo combinará:

- access token de corta duración;
- refresh token de mayor duración;
- control de acceso basado en roles;
- validación de propiedad sobre recursos;
- sesiones revocables;
- almacenamiento seguro de contraseñas;
- protección contra intentos repetidos de autenticación.

---

### 6.1 Modelo general de autenticación

El flujo general de autenticación será:

1. El usuario se registra o inicia sesión.
2. El backend valida sus credenciales.
3. El backend genera un access token.
4. El backend genera un refresh token.
5. El access token se devuelve dentro de la respuesta JSON.
6. El refresh token se envía mediante una cookie `httpOnly`.
7. El cliente utiliza el access token para acceder a recursos protegidos.
8. Cuando el access token expira, el cliente solicita uno nuevo mediante el refresh token.
9. Al cerrar sesión, el refresh token y la sesión asociada son revocados.

El sistema no utilizará sesiones tradicionales almacenadas únicamente en memoria del servidor.

La autenticación deberá permitir revocar sesiones sin depender exclusivamente de la fecha de expiración del JWT.

---

### 6.2 Roles del sistema

El sistema contará inicialmente con los siguientes roles:

- `cliente`;
- `vendedor`;
- `admin`.

#### Cliente

El cliente podrá:

- consultar el catálogo público;
- administrar su perfil;
- registrar y actualizar la dirección de entrega de su carrito activo;
- gestionar su carrito;
- realizar el checkout;
- consultar sus propios pedidos;
- solicitar cambios o devoluciones cuando corresponda;
- registrar interés por variantes sin stock.

El cliente no podrá acceder a información de otros clientes ni a operaciones administrativas.

#### Vendedor

El vendedor podrá acceder a operaciones relacionadas con la gestión operativa del negocio.

Su alcance inicial podrá incluir:

- consultar pedidos;
- actualizar determinados estados de pedidos;
- consultar inventario;
- registrar movimientos autorizados de inventario;
- consultar clientes cuando sea necesario para atender un pedido;
- registrar notas operativas.

El vendedor no podrá:

- cambiar roles;
- crear administradores;
- modificar configuraciones críticas;
- acceder a secretos del sistema;
- eliminar información histórica;
- realizar operaciones reservadas exclusivamente al administrador.

El alcance definitivo del vendedor será detallado posteriormente en la matriz de acceso por roles.

#### Administrador

El administrador tendrá acceso a las operaciones administrativas del sistema.

Su alcance incluirá:

- gestionar productos;
- gestionar variantes;
- gestionar categorías;
- gestionar inventario;
- consultar y actualizar pedidos;
- administrar usuarios y roles;
- consultar reportes;
- revisar intereses de stock;
- realizar operaciones administrativas autorizadas.

Incluso el administrador deberá estar sujeto a validaciones de negocio, auditoría y restricciones de integridad.

---

### 6.3 Registro público

El registro público estará disponible mediante:

`POST /api/v1/auth/registro`

El registro público permitirá crear únicamente usuarios con rol:

`cliente`

El rol no deberá recibirse como un valor configurable desde el frontend.

Ejemplo de solicitud:

```json
{
  "nombreCompleto": "Juan Pérez",
  "email": "juan.perez@example.com",
  "password": "ContrasenaSegura123"
}
```

No se aceptará una solicitud como:

```json
{
  "nombreCompleto": "Juan Pérez",
  "email": "juan.perez@example.com",
  "password": "ContrasenaSegura123",
  "rol": "admin"
}
```

Aunque el cliente envíe un campo `rol`, el backend deberá ignorarlo o rechazar la solicitud.

Los usuarios con roles `vendedor` y `admin` deberán ser creados mediante un procedimiento administrativo protegido.

Después de un registro exitoso, el sistema podrá autenticar inmediatamente al cliente y devolver:

- datos básicos del usuario;
- access token;
- tiempo de expiración;
- refresh token mediante cookie segura.

Ejemplo de respuesta:

```json
{
  "data": {
    "usuario": {
      "id": "cm123example456",
      "nombreCompleto": "Juan Pérez",
      "email": "juan.perez@example.com",
      "rol": "cliente"
    },
    "accessToken": "jwt-access-token",
    "tokenType": "Bearer",
    "expiresIn": 900
  }
}
```

El email deberá ser único dentro del sistema.

---

### 6.4 Inicio de sesión

El inicio de sesión estará disponible mediante:

`POST /api/v1/auth/login`

Ejemplo de solicitud:

```json
{
  "email": "juan.perez@example.com",
  "password": "ContrasenaSegura123"
}
```

El backend deberá:

1. validar el formato del email;
2. buscar al usuario por su email;
3. verificar que la cuenta se encuentre activa;
4. comparar la contraseña con el hash almacenado;
5. generar el access token;
6. generar el refresh token;
7. registrar o actualizar la sesión;
8. devolver los datos públicos del usuario.

Ejemplo de respuesta:

```json
{
  "data": {
    "usuario": {
      "id": "cm123example456",
      "nombreCompleto": "Juan Pérez",
      "email": "juan.perez@example.com",
      "rol": "cliente"
    },
    "accessToken": "jwt-access-token",
    "tokenType": "Bearer",
    "expiresIn": 900
  }
}
```

El refresh token no deberá incluirse dentro de la respuesta JSON.

Será enviado mediante una cookie `httpOnly`.

La respuesta de credenciales incorrectas no deberá revelar si el email existe o si únicamente la contraseña es incorrecta.

Mensaje recomendado:

```json
{
  "statusCode": 401,
  "error": "INVALID_CREDENTIALS",
  "message": "Email o contraseña incorrectos"
}
```

---

### 6.5 Access token

El access token será un JWT de corta duración utilizado para acceder a endpoints protegidos.

La duración será configurable mediante variables de entorno.

Variable prevista:

`JWT_ACCESS_EXPIRES_IN`

Valor inicial sugerido:

`15m`

El token contendrá únicamente la información necesaria para identificar y autorizar al usuario.

Ejemplo conceptual del payload:

```json
{
  "sub": "cuid-del-usuario",
  "rol": "cliente",
  "sessionId": "cuid-de-la-sesion",
  "iat": 1786068000,
  "exp": 1786068900
}
```

Significado de las propiedades:

| Propiedad | Descripción |
|---|---|
| `sub` | Identificador del usuario |
| `rol` | Rol actual del usuario |
| `sessionId` | Identificador de la sesión |
| `iat` | Fecha de emisión |
| `exp` | Fecha de expiración |

El token no deberá contener:

- contraseña;
- hash de contraseña;
- refresh token;
- secretos;
- direcciones completas;
- información sensible innecesaria;
- datos que puedan quedar obsoletos rápidamente.

El access token será firmado utilizando:

`JWT_ACCESS_SECRET`

La aplicación deberá utilizar un secreto suficientemente largo y almacenado únicamente mediante variables de entorno.

---

### 6.6 Envío del access token

Los clientes deberán enviar el access token mediante el encabezado `Authorization`.

Formato:

```http
Authorization: Bearer jwt-access-token
```

Ejemplo:

```http
GET /api/v1/auth/me
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

El backend deberá rechazar solicitudes cuando:

- el encabezado no exista;
- el formato no utilice `Bearer`;
- el token sea inválido;
- el token haya expirado;
- la sesión haya sido revocada;
- el usuario se encuentre inactivo;
- la firma no sea válida.

---

### 6.7 Refresh token

El refresh token tendrá una duración superior a la del access token.

Su función será permitir la creación de un nuevo access token sin solicitar nuevamente la contraseña del usuario.

La duración será configurable mediante:

`JWT_REFRESH_EXPIRES_IN`

Valor inicial sugerido:

`7d`

El refresh token será firmado utilizando:

`JWT_REFRESH_SECRET`

Este secreto deberá ser diferente del utilizado para el access token.

El refresh token deberá enviarse mediante una cookie con las siguientes características:

- `httpOnly: true`;
- `secure: true` en producción;
- `sameSite: lax` inicialmente;
- ruta limitada a los endpoints de autenticación;
- duración coherente con la expiración del refresh token.

Ejemplo conceptual:

```http
Set-Cookie: refreshToken=jwt-refresh-token; HttpOnly; Secure; SameSite=Lax; Path=/api/v1/auth
```

Durante el desarrollo local, la opción `secure` podrá desactivarse cuando la aplicación no utilice HTTPS.

El frontend no deberá acceder directamente al refresh token mediante JavaScript.

---

### 6.8 Renovación del access token

La renovación se realizará mediante:

`POST /api/v1/auth/refresh`

El cliente no enviará el refresh token dentro del cuerpo de la solicitud.

El navegador enviará automáticamente la cookie correspondiente.

El backend deberá:

1. obtener el refresh token desde la cookie;
2. validar su firma;
3. verificar su expiración;
4. comprobar que la sesión siga activa;
5. verificar que el usuario no esté bloqueado o desactivado;
6. rotar el refresh token cuando corresponda;
7. generar un nuevo access token;
8. devolver el access token actualizado;
9. actualizar la cookie del refresh token.

Ejemplo de respuesta:

```json
{
  "data": {
    "accessToken": "nuevo-jwt-access-token",
    "tokenType": "Bearer",
    "expiresIn": 900
  }
}
```

La rotación del refresh token impedirá que un token anterior continúe utilizándose después de generar uno nuevo.

Si se detecta el uso de un refresh token revocado o reutilizado, el sistema podrá invalidar toda la sesión asociada.

---

### 6.9 Cierre de sesión

El cierre de sesión se realizará mediante:

`POST /api/v1/auth/logout`

La operación deberá:

- invalidar la sesión actual;
- revocar el refresh token;
- eliminar la cookie;
- impedir nuevas renovaciones;
- conservar únicamente los registros necesarios para auditoría.

La cookie deberá eliminarse utilizando las mismas propiedades con las que fue creada.

La respuesta podrá utilizar:

`204 No Content`

El cierre de sesión deberá ser idempotente.

Si el usuario intenta cerrar una sesión que ya fue revocada, la operación no deberá generar un efecto adicional ni crear una nueva sesión.

---

### 6.10 Consulta del usuario autenticado

El usuario autenticado podrá consultar su información básica mediante:

`GET /api/v1/auth/me`

La solicitud deberá incluir el access token.

Ejemplo de respuesta:

```json
{
  "data": {
    "id": "cm123example456",
    "nombreCompleto": "Juan Pérez",
    "email": "juan.perez@example.com",
    "rol": "cliente",
    "activo": true,
    "creadoEn": "2026-08-07T00:15:00.000Z"
  }
}
```

La respuesta no deberá incluir información sensible.

---

### 6.11 Autorización basada en roles

Después de autenticar al usuario, el backend deberá verificar si su rol permite realizar la operación solicitada.

Ejemplo de endpoint público:

`GET /api/v1/productos`

Ejemplo de endpoint para usuarios autenticados:

`GET /api/v1/pedidos`

Ejemplo de endpoint administrativo:

`POST /api/v1/admin/productos`

Ejemplo de endpoint restringido al administrador:

`PATCH /api/v1/admin/usuarios/:usuarioId/rol`

El sistema utilizará controles equivalentes a guards de NestJS para:

- validar el access token;
- obtener al usuario autenticado;
- verificar su rol;
- comprobar permisos adicionales;
- rechazar accesos no autorizados.

La presencia de un rol dentro del JWT no sustituirá las validaciones necesarias sobre el estado actual del usuario y de la sesión.

---

### 6.12 Autorización basada en propiedad

Además del rol, el sistema deberá comprobar que un usuario tenga derecho a acceder al recurso solicitado.

Un cliente podrá consultar:

`GET /api/v1/pedidos/:pedidoId`

únicamente cuando el pedido le pertenezca.

No será suficiente comprobar que el usuario tenga rol `cliente`.

También será necesario verificar:

`pedido.clienteId === usuarioAutenticado.id`

La misma regla se aplicará a:

- direcciones;
- carrito;
- pedidos;
- devoluciones;
- intereses de stock;
- datos personales;
- métodos de pago almacenados, si se implementan.

Un cliente nunca deberá poder acceder a recursos de otro cliente modificando manualmente un identificador dentro de la URL.

---

### 6.13 Estados de la cuenta

La autenticación deberá considerar el estado actual de la cuenta.

Estados iniciales posibles:

- activa;
- bloqueada;
- desactivada.

Una cuenta activa podrá iniciar sesión normalmente.

Una cuenta bloqueada no podrá iniciar sesión hasta que se cumpla la condición de desbloqueo o intervenga un administrador.

Una cuenta desactivada no podrá:

- iniciar sesión;
- renovar tokens;
- acceder a endpoints protegidos;
- crear nuevos pedidos.

El backend deberá validar el estado de la cuenta tanto en el login como durante la renovación de tokens.

---

### 6.14 Gestión de contraseñas

Las contraseñas nunca serán almacenadas en texto plano.

Se utilizará `bcrypt` para generar el hash de la contraseña.

El número de rondas será configurable mediante una variable de entorno.

Variable prevista:

`BCRYPT_SALT_ROUNDS`

Valor inicial sugerido:

`12`

La política inicial de contraseñas deberá requerir:

- mínimo 8 caracteres;
- máximo compatible con la estrategia de hash seleccionada;
- rechazo de valores vacíos;
- validación de tipo;
- confirmación de contraseña en el frontend cuando corresponda.

El backend no deberá confiar únicamente en la validación realizada por el frontend.

La API nunca devolverá:

- la contraseña;
- el hash;
- el salt;
- información que permita reconstruir la contraseña.

Los procesos de cambio o recuperación de contraseña deberán utilizar tokens de un solo uso y duración limitada.

---

### 6.15 Persistencia y revocación de sesiones

El sistema deberá conservar información suficiente para revocar sesiones activas.

La implementación podrá almacenar:

- identificador de sesión;
- identificador del usuario;
- hash del refresh token;
- fecha de creación;
- fecha de expiración;
- fecha de revocación;
- información básica del dispositivo;
- dirección IP cuando sea apropiado;
- motivo de revocación.

El refresh token completo no deberá almacenarse directamente.

Se almacenará una representación segura o un hash que permita verificarlo sin exponerlo.

La sesión podrá revocarse cuando:

- el usuario cierre sesión;
- el usuario cambie su contraseña;
- la cuenta sea desactivada;
- se detecte reutilización de un refresh token;
- un administrador cierre sesiones activas;
- expire el tiempo máximo de la sesión.

Si el modelo de datos actual no contempla la persistencia de sesiones o refresh tokens revocables, deberá registrarse el ajuste correspondiente antes de implementar el módulo de autenticación.

---

### 6.16 Protección contra fuerza bruta

Los endpoints de autenticación deberán aplicar limitación de solicitudes.

Se protegerán especialmente:

- `POST /api/v1/auth/login`;
- `POST /api/v1/auth/registro`;
- `POST /api/v1/auth/refresh`;
- futuros endpoints de recuperación de contraseña.

Cuando se supere el límite permitido, la API responderá con:

`429 Too Many Requests`

Ejemplo:

```json
{
  "statusCode": 429,
  "error": "TOO_MANY_REQUESTS",
  "message": "Se realizaron demasiados intentos. Intente nuevamente más tarde"
}
```

La estrategia podrá considerar:

- dirección IP;
- email utilizado;
- usuario;
- ventana de tiempo;
- cantidad de intentos fallidos.

Los mensajes de error no deberán facilitar la enumeración de cuentas existentes.

---

### 6.17 Protección de cookies y CSRF

El refresh token se almacenará en una cookie `httpOnly`, por lo que deberá considerarse la protección contra solicitudes CSRF.

La estrategia inicial incluirá:

- uso de `SameSite=Lax`;
- validación del origen de la solicitud;
- configuración restrictiva de CORS;
- uso de métodos `POST` para renovar o cerrar sesiones;
- prohibición de comodines de origen en producción;
- envío de credenciales únicamente desde orígenes autorizados.

Si el frontend y el backend deben operar en sitios diferentes y se requiere `SameSite=None`, deberá implementarse una protección CSRF adicional.

Esta protección podrá utilizar:

- token CSRF;
- patrón double submit cookie;
- validación estricta de `Origin`;
- validación de `Referer` cuando corresponda.

La configuración exacta dependerá de la infraestructura final de despliegue.

---

### 6.18 CORS y credenciales

El backend permitirá solicitudes únicamente desde orígenes configurados.

Variable prevista:

`CORS_ORIGIN`

Durante el desarrollo podrá utilizarse:

`http://localhost:5173`

Cuando se utilicen cookies, la configuración deberá permitir credenciales:

```typescript
credentials: true
```

No se deberá utilizar simultáneamente:

```typescript
origin: '*'
```

con credenciales habilitadas.

En producción se configurará explícitamente el dominio autorizado del frontend.

---

### 6.19 Respuestas de autenticación y autorización

Los errores de autenticación utilizarán principalmente:

| Código | Uso |
|---|---|
| `400 Bad Request` | Datos de entrada inválidos |
| `401 Unauthorized` | Credenciales o token inválidos |
| `403 Forbidden` | Usuario autenticado sin permisos |
| `409 Conflict` | Correo duplicado o conflicto de sesión |
| `429 Too Many Requests` | Exceso de intentos |
| `500 Internal Server Error` | Error interno no controlado |

Se utilizará `401 Unauthorized` cuando:

- no exista access token;
- el token sea inválido;
- el token haya expirado;
- las credenciales sean incorrectas;
- el refresh token no sea válido.

Se utilizará `403 Forbidden` cuando:

- el usuario esté autenticado;
- su sesión sea válida;
- pero no tenga permisos para ejecutar la operación.

Ejemplo:

```json
{
  "statusCode": 403,
  "error": "FORBIDDEN",
  "message": "No tiene permisos para realizar esta operación"
}
```

---

### 6.20 Auditoría de seguridad

Las operaciones sensibles deberán generar registros de auditoría.

Entre ellas:

- inicio de sesión exitoso;
- intentos fallidos repetidos;
- cierre de sesión;
- renovación de tokens;
- revocación de sesiones;
- cambio de contraseña;
- cambio de rol;
- bloqueo de cuenta;
- desactivación de usuario;
- acceso administrativo sensible.

Los registros no deberán almacenar:

- contraseñas;
- tokens completos;
- secretos;
- datos de tarjetas;
- información sensible innecesaria.

Los logs deberán permitir investigar incidentes sin convertirse ellos mismos en una filtración convenientemente organizada.

---

### 6.21 Reglas de seguridad adoptadas

La autenticación y autorización deberán cumplir las siguientes reglas:

- las contraseñas se almacenan mediante `bcrypt`;
- el registro público crea únicamente clientes;
- el access token se devuelve en JSON;
- el refresh token se envía mediante cookie `httpOnly`;
- los secretos se almacenan mediante variables de entorno;
- access y refresh token utilizan secretos diferentes;
- el access token tiene corta duración;
- el refresh token puede ser revocado;
- las sesiones se validan durante la renovación;
- los endpoints privados requieren autenticación;
- los endpoints administrativos requieren autorización;
- los clientes solo acceden a sus propios recursos;
- las cuentas inactivas no pueden renovar tokens;
- los intentos de login están limitados;
- las respuestas no exponen información sensible;
- las operaciones críticas generan auditoría.

---

### 6.22 Endpoints iniciales de autenticación

El módulo de autenticación contará inicialmente con:

| Método | Ruta | Acceso | Descripción |
|---|---|---|---|
| `POST` | `/api/v1/auth/registro` | Público | Registrar un cliente |
| `POST` | `/api/v1/auth/login` | Público | Iniciar sesión |
| `POST` | `/api/v1/auth/refresh` | Cookie de sesión | Renovar el access token |
| `POST` | `/api/v1/auth/logout` | Sesión activa | Cerrar la sesión actual |
| `GET` | `/api/v1/auth/me` | Autenticado | Consultar al usuario actual |
| `POST` | `/api/v1/auth/recuperar-password` | Público | Solicitar recuperación de contraseña |
| `POST` | `/api/v1/auth/restablecer-password` | Token temporal | Establecer una nueva contraseña |

Los contratos detallados de estos endpoints se desarrollarán nuevamente dentro del catálogo de endpoints de la sección 10.

---

## 7. Formato estándar de respuestas

La API utilizará estructuras de respuesta consistentes para facilitar su consumo desde el frontend, las pruebas automatizadas y cualquier integración futura.

Todas las respuestas serán enviadas principalmente en formato JSON, excepto aquellas operaciones que utilicen el código `204 No Content`.

---

### 7.1 Respuesta exitosa de un recurso individual

Las consultas o modificaciones que devuelvan un recurso individual utilizarán la propiedad `data`.

Ejemplo:

```json
{
  "data": {
    "id": "cm123example456",
    "nombre": "Zapato deportivo",
    "descripcion": "Calzado deportivo para uso diario",
    "estado": "activo"
  }
}
```

La propiedad `data` contendrá únicamente la representación pública del recurso.

No deberán incluirse:

- hashes de contraseña;
- refresh tokens;
- secretos;
- campos internos de seguridad;
- datos técnicos innecesarios;
- propiedades no autorizadas para el usuario.

---

### 7.2 Respuesta exitosa de una colección

Las respuestas que contengan una lista utilizarán un arreglo dentro de `data`.

Ejemplo:

```json
{
  "data": [
    {
      "id": "cm123example456",
      "nombre": "Zapato deportivo",
      "estado": "activo"
    },
    {
      "id": "cm789example012",
      "nombre": "Bota de montaña",
      "estado": "activo"
    }
  ]
}
```

Cuando la colección esté paginada, se incluirá la propiedad `meta`.

Ejemplo:

```json
{
  "data": [
    {
      "id": "cm123example456",
      "nombre": "Zapato deportivo"
    }
  ],
  "meta": {
    "pagina": 1,
    "limite": 20,
    "total": 48,
    "totalPaginas": 3,
    "tienePaginaAnterior": false,
    "tienePaginaSiguiente": true
  }
}
```

---

### 7.3 Respuesta de creación

Cuando un recurso sea creado correctamente, la API responderá normalmente con:

`201 Created`

Ejemplo:

```json
{
  "data": {
    "id": "cm123example456",
    "nombre": "Zapato deportivo",
    "estado": "borrador",
    "creadoEn": "2026-08-07T00:15:00.000Z"
  },
  "message": "Producto creado correctamente"
}
```

La propiedad `message` será opcional y se utilizará cuando aporte contexto útil al consumidor de la API.

---

### 7.4 Respuesta de actualización

Cuando una actualización devuelva el recurso modificado, la API utilizará:

`200 OK`

Ejemplo:

```json
{
  "data": {
    "id": "cm123example456",
    "nombre": "Zapato deportivo actualizado",
    "estado": "activo",
    "actualizadoEn": "2026-08-07T01:30:00.000Z"
  },
  "message": "Producto actualizado correctamente"
}
```

---

### 7.5 Respuesta sin contenido

Cuando una operación se complete correctamente y no sea necesario devolver información, podrá utilizarse:

`204 No Content`

Esta respuesta no deberá incluir cuerpo.

Ejemplos de operaciones que podrán utilizar `204`:

- cerrar sesión;
- eliminar un elemento del carrito;
- eliminar una dirección temporal;
- retirar un interés de stock;
- desactivar una sesión;
- vaciar un carrito.

---

### 7.6 Respuesta de operaciones de negocio

Las operaciones de negocio podrán devolver el recurso afectado y un resumen del resultado.

Ejemplo de confirmación de checkout:

```json
{
  "data": {
    "pedidoId": "cm123pedido456",
    "numeroPedido": "PS-2026-000001",
    "estado": "pendientePago",
    "metodoPago": "transferencia",
    "tipoEntrega": "domicilio",
    "subtotal": 89.98,
    "costoEnvio": 3.00,
    "total": 92.98,
    "moneda": "USD",
    "creadoEn": "2026-08-07T00:15:00.000Z"
  },
  "message": "Pedido creado correctamente"
}
```

---

### 7.7 Consistencia de propiedades

Las respuestas utilizarán:

- nombres en `camelCase`;
- fechas en ISO 8601;
- identificadores CUID representados como cadenas;
- valores monetarios en dólares estadounidenses;
- valores booleanos mediante `true` o `false`;
- valores ausentes mediante `null` cuando corresponda.

Ejemplo:

```json
{
  "data": {
    "pedidoId": "cm123pedido456",
    "stockDisponible": 8,
    "fechaPagoConfirmado": null,
    "activo": true
  }
}
```

---

### 7.8 Información que no debe exponerse

Las respuestas nunca deberán incluir:

- `passwordHash`;
- contraseñas;
- secretos JWT;
- refresh tokens completos;
- credenciales de base de datos;
- tokens de recuperación;
- datos internos de infraestructura;
- trazas completas de errores;
- información sensible de otros clientes;
- configuraciones privadas del sistema.

---

## 8. Manejo uniforme de errores

La API utilizará una estructura uniforme para representar errores técnicos, errores de validación y conflictos de negocio.

El objetivo es permitir que el frontend identifique correctamente el problema sin depender únicamente del texto mostrado al usuario.

---

### 8.1 Estructura general de error

Ejemplo:

```json
{
  "statusCode": 400,
  "error": "VALIDATION_ERROR",
  "message": "Los datos enviados no son válidos",
  "details": [
    {
      "field": "cantidad",
      "message": "La cantidad debe ser mayor que cero"
    }
  ],
  "path": "/api/v1/carrito/items",
  "timestamp": "2026-08-07T00:15:00.000Z",
  "requestId": "req_123example456"
}
```

Propiedades:

| Propiedad | Descripción |
|---|---|
| `statusCode` | Código HTTP de la respuesta |
| `error` | Código interno legible por el frontend |
| `message` | Descripción general del error |
| `details` | Información adicional opcional; puede ser una lista de validaciones o un objeto de contexto |
| `path` | Ruta donde ocurrió el error |
| `timestamp` | Fecha y hora del error |
| `requestId` | Identificador para trazabilidad y logs |

---

### 8.2 Errores de validación

Los errores producidos por DTOs o validaciones de entrada utilizarán:

`400 Bad Request`

Ejemplo:

```json
{
  "statusCode": 400,
  "error": "VALIDATION_ERROR",
  "message": "Los datos enviados no son válidos",
  "details": [
    {
      "field": "email",
      "message": "El email debe tener un formato válido"
    },
    {
      "field": "password",
      "message": "La contraseña debe contener al menos 8 caracteres"
    }
  ],
  "path": "/api/v1/auth/registro",
  "timestamp": "2026-08-07T00:15:00.000Z",
  "requestId": "req_123example456"
}
```

---

### 8.3 Errores de autenticación

Se utilizará:

`401 Unauthorized`

Cuando:

- las credenciales sean incorrectas;
- no exista access token;
- el token sea inválido;
- el token haya expirado;
- el refresh token no sea válido;
- la sesión haya sido revocada.

Ejemplo:

```json
{
  "statusCode": 401,
  "error": "INVALID_CREDENTIALS",
  "message": "Email o contraseña incorrectos",
  "path": "/api/v1/auth/login",
  "timestamp": "2026-08-07T00:15:00.000Z",
  "requestId": "req_123example456"
}
```

---

### 8.4 Errores de autorización

Se utilizará:

`403 Forbidden`

Cuando el usuario esté autenticado, pero no tenga permisos para ejecutar la operación.

Ejemplo:

```json
{
  "statusCode": 403,
  "error": "FORBIDDEN",
  "message": "No tiene permisos para realizar esta operación",
  "path": "/api/v1/admin/productos",
  "timestamp": "2026-08-07T00:15:00.000Z",
  "requestId": "req_123example456"
}
```

---

### 8.5 Recurso no encontrado

Se utilizará:

`404 Not Found`

Ejemplo:

```json
{
  "statusCode": 404,
  "error": "PRODUCT_NOT_FOUND",
  "message": "El producto solicitado no existe",
  "path": "/api/v1/productos/cm123example456",
  "timestamp": "2026-08-07T00:15:00.000Z",
  "requestId": "req_123example456"
}
```

---

### 8.6 Conflictos

Se utilizará:

`409 Conflict`

Cuando la solicitud entre en conflicto con el estado actual del sistema.

Casos posibles:

- email duplicado;
- interés de stock ya registrado;
- recurso utilizado por otras entidades;
- clave de idempotencia reutilizada;
- sesión conflictiva;
- intento de crear una variante duplicada.

Ejemplo:

```json
{
  "statusCode": 409,
  "error": "EMAIL_ALREADY_EXISTS",
  "message": "Ya existe una cuenta registrada con este email",
  "path": "/api/v1/auth/registro",
  "timestamp": "2026-08-07T00:15:00.000Z",
  "requestId": "req_123example456"
}
```

---

### 8.7 Errores de reglas de negocio

Se utilizará principalmente:

`422 Unprocessable Entity`

Cuando los datos sean válidos sintácticamente, pero no puedan procesarse debido a una regla del negocio.

Ejemplo de stock insuficiente:

```json
{
  "statusCode": 422,
  "error": "INSUFFICIENT_STOCK",
  "message": "La cantidad solicitada supera el stock disponible",
  "details": {
    "varianteId": "cm123variante456",
    "cantidadSolicitada": 3,
    "stockDisponible": 1
  },
  "path": "/api/v1/carrito/items",
  "timestamp": "2026-08-07T00:15:00.000Z",
  "requestId": "req_123example456"
}
```

Ejemplo de transición inválida:

```json
{
  "statusCode": 422,
  "error": "INVALID_ORDER_TRANSITION",
  "message": "El pedido no puede cambiar de entregado a preparado",
  "path": "/api/v1/admin/pedidos/cm123pedido456/estado",
  "timestamp": "2026-08-07T00:15:00.000Z",
  "requestId": "req_123example456"
}
```

---

### 8.8 Límite de solicitudes

Se utilizará:

`429 Too Many Requests`

Ejemplo:

```json
{
  "statusCode": 429,
  "error": "TOO_MANY_REQUESTS",
  "message": "Se realizaron demasiadas solicitudes. Intente nuevamente más tarde",
  "path": "/api/v1/auth/login",
  "timestamp": "2026-08-07T00:15:00.000Z",
  "requestId": "req_123example456"
}
```

---

### 8.9 Error interno

Se utilizará:

`500 Internal Server Error`

La respuesta no deberá exponer detalles técnicos internos.

Ejemplo:

```json
{
  "statusCode": 500,
  "error": "INTERNAL_SERVER_ERROR",
  "message": "Ocurrió un error interno al procesar la solicitud",
  "path": "/api/v1/pedidos",
  "timestamp": "2026-08-07T00:15:00.000Z",
  "requestId": "req_123example456"
}
```

La traza completa deberá registrarse únicamente en los logs internos.

---

### 8.10 Códigos de error previstos

| Código interno | Código HTTP | Descripción |
|---|---:|---|
| `VALIDATION_ERROR` | 400 | Datos de entrada inválidos |
| `INVALID_CREDENTIALS` | 401 | Credenciales incorrectas |
| `INVALID_TOKEN` | 401 | Token inválido |
| `TOKEN_EXPIRED` | 401 | Token expirado |
| `SESSION_REVOKED` | 401 | Sesión revocada |
| `FORBIDDEN` | 403 | Usuario sin permisos |
| `RESOURCE_NOT_FOUND` | 404 | Recurso no encontrado |
| `EMAIL_ALREADY_EXISTS` | 409 | Email duplicado |
| `RESOURCE_IN_USE` | 409 | Recurso relacionado con otros registros |
| `INTEREST_ALREADY_REGISTERED` | 409 | Interés de stock duplicado |
| `IDEMPOTENCY_KEY_CONFLICT` | 409 | Conflicto con clave de idempotencia |
| `INSUFFICIENT_STOCK` | 422 | Stock insuficiente |
| `VARIANT_NOT_AVAILABLE` | 422 | Variante no disponible |
| `INVALID_ORDER_TRANSITION` | 422 | Transición de pedido inválida |
| `PAYMENT_WINDOW_EXPIRED` | 422 | Tiempo de pago expirado |
| `CART_EMPTY` | 422 | Carrito sin productos |
| `TOO_MANY_REQUESTS` | 429 | Exceso de solicitudes |
| `INTERNAL_SERVER_ERROR` | 500 | Error interno |

---

## 9. Paginación, filtros y ordenamiento

Las consultas que puedan devolver grandes cantidades de registros deberán soportar paginación.

Se aplicará especialmente a:

- catálogo de productos;
- pedidos;
- clientes;
- movimientos de inventario;
- intereses de stock;
- reportes;
- registros administrativos.

---

### 9.1 Parámetros de paginación

Se utilizarán los siguientes parámetros:

| Parámetro | Descripción | Valor inicial |
|---|---|---:|
| `pagina` | Número de página solicitada | 1 |
| `limite` | Cantidad de elementos por página | 20 |

Ejemplo:

`GET /api/v1/productos?pagina=1&limite=20`

El valor máximo inicial de `limite` será:

`100`

Los valores inferiores a 1 o superiores al máximo permitido serán rechazados o ajustados según la validación definida.

---

### 9.2 Respuesta paginada

Ejemplo:

```json
{
  "data": [],
  "meta": {
    "pagina": 1,
    "limite": 20,
    "total": 48,
    "totalPaginas": 3,
    "tienePaginaAnterior": false,
    "tienePaginaSiguiente": true
  }
}
```

---

### 9.3 Búsqueda

El parámetro general de búsqueda será:

`buscar`

Ejemplo:

`GET /api/v1/productos?buscar=deportivo`

La búsqueda podrá aplicarse sobre campos como:

- nombre del producto;
- descripción;
- marca;
- categoría;
- código interno cuando el acceso sea administrativo.

---

### 9.4 Filtros del catálogo

Los productos podrán filtrarse mediante parámetros como:

- `marcaId`;
- `categoriaId`;
- `talla`;
- `color`;
- `grupoObjetivo`;
- `precioMin`;
- `precioMax`;
- `disponible`;
- `estado`, únicamente en operaciones administrativas.

Ejemplo:

`GET /api/v1/productos?categoriaId=cm123categoria456&talla=40&color=negro&disponible=true`

En el catálogo público solo se devolverán productos y variantes disponibles para venta según sus estados.

---

### 9.5 Filtros de pedidos

Los pedidos administrativos podrán filtrarse mediante:

- `estado`;
- `metodoPago`;
- `tipoEntrega`;
- `clienteId`;
- `desde`;
- `hasta`;
- `numeroPedido`.

Ejemplo:

`GET /api/v1/admin/pedidos?estado=pendientePago&metodoPago=transferencia&desde=2026-08-01&hasta=2026-08-31`

---

### 9.6 Filtros de inventario

El inventario podrá filtrarse mediante:

- `productoId`;
- `varianteId`;
- `talla`;
- `color`;
- `stockMaximo`;
- `soloStockBajo`;
- `tipoMovimiento`;
- `desde`;
- `hasta`.

Ejemplo:

`GET /api/v1/admin/inventario?soloStockBajo=true`

---

### 9.7 Ordenamiento

Se utilizarán:

- `ordenPor`;
- `direccion`.

Valores permitidos para `direccion`:

- `asc`;
- `desc`.

Ejemplo:

`GET /api/v1/productos?ordenPor=precio&direccion=asc`

Los campos permitidos para ordenar deberán estar definidos explícitamente por cada endpoint.

No se permitirá utilizar cualquier nombre de columna de la base de datos directamente.

---

### 9.8 Combinación de parámetros

La búsqueda, filtros, paginación y ordenamiento podrán combinarse.

Ejemplo:

`GET /api/v1/productos?buscar=botas&talla=40&precioMax=100&ordenPor=precio&direccion=asc&pagina=1&limite=20`

El backend deberá validar todos los parámetros antes de construir la consulta.

---

## 10. Catálogo de endpoints

El catálogo define los endpoints iniciales del sistema y su alcance funcional.

Las rutas administrativas utilizarán el prefijo:

`/api/v1/admin`

---

### 10.1 Salud

Los endpoints de salud ya se encuentran implementados y se mantendrán fuera del prefijo `/api/v1`.

| Método | Ruta | Acceso | Descripción |
|---|---|---|---|
| `GET` | `/health` | Público | Estado general de la API |
| `GET` | `/health/live` | Público | Verifica que el proceso esté vivo |
| `GET` | `/health/ready` | Público | Verifica disponibilidad de la aplicación y base de datos |

Ejemplo de respuesta:

```json
{
  "status": "ok",
  "service": "Paulito Shoes API"
}
```

---

### 10.2 Autenticación

| Método | Ruta | Acceso | Alcance | Descripción |
|---|---|---|---|---|
| `POST` | `/api/v1/auth/registro` | Público | MVP | Registrar un cliente |
| `POST` | `/api/v1/auth/login` | Público | MVP | Iniciar sesión |
| `POST` | `/api/v1/auth/refresh` | Cookie de sesión | MVP | Renovar el access token |
| `POST` | `/api/v1/auth/logout` | Sesión activa | MVP | Cerrar sesión |
| `GET` | `/api/v1/auth/me` | Autenticado | MVP | Obtener usuario autenticado |
| `POST` | `/api/v1/auth/recuperar-password` | Público | MVP | Solicitar recuperación de contraseña |
| `POST` | `/api/v1/auth/restablecer-password` | Token temporal | MVP | Establecer una nueva contraseña |

#### Registro

Solicitud:

```json
{
  "nombreCompleto": "Juan Pérez",
  "email": "juan.perez@example.com",
  "password": "ContrasenaSegura123"
}
```

El registro público creará únicamente clientes.

#### Inicio de sesión

Solicitud:

```json
{
  "email": "juan.perez@example.com",
  "password": "ContrasenaSegura123"
}
```

#### Recuperación de contraseña

Solicitud:

```json
{
  "email": "juan.perez@example.com"
}
```

La respuesta no deberá confirmar si el email existe.

Ejemplo:

```json
{
  "message": "Si existe una cuenta asociada, se enviarán las instrucciones correspondientes"
}
```

La recuperación de contraseña requerirá ampliar el modelo para almacenar tokens temporales o una estrategia equivalente antes de su implementación.

---

### 10.3 Clientes

| Método | Ruta | Acceso | Alcance | Descripción |
|---|---|---|---|---|
| `GET` | `/api/v1/clientes/me` | Cliente | MVP | Consultar perfil propio |
| `PATCH` | `/api/v1/clientes/me` | Cliente | MVP | Actualizar perfil propio |
| `GET` | `/api/v1/clientes/me/intereses-stock` | Cliente | MVP+ | Consultar intereses registrados |

Ejemplo de actualización:

```json
{
  "nombreCompleto": "Juan Carlos Pérez"
}
```

El cliente únicamente podrá consultar o modificar sus propios datos.

Las direcciones de entrega del modelo actual están relacionadas con el carrito activo, por lo que serán gestionadas desde los endpoints de carrito.

---

### 10.4 Catálogo y variantes

#### Endpoints públicos

| Método | Ruta | Acceso | Alcance | Descripción |
|---|---|---|---|---|
| `GET` | `/api/v1/productos` | Público | MVP | Listar productos del catálogo |
| `GET` | `/api/v1/productos/:productoId` | Público | MVP | Consultar detalle de un producto |
| `GET` | `/api/v1/productos/:productoId/variantes` | Público | MVP | Consultar variantes del producto |
| `GET` | `/api/v1/variantes/:varianteId` | Público | MVP | Consultar una variante específica |
| `GET` | `/api/v1/categorias` | Público | MVP | Listar categorías activas |
| `GET` | `/api/v1/marcas` | Público | MVP | Listar marcas activas |

Ejemplo de producto:

```json
{
  "data": {
    "id": "cm123producto456",
    "nombre": "Zapato deportivo",
    "descripcion": "Calzado deportivo para uso diario",
    "grupoObjetivo": "unisex",
    "marca": {
      "id": "cm123marca456",
      "nombre": "Marca ejemplo"
    },
    "categoria": {
      "id": "cm123categoria456",
      "nombre": "Deportivos"
    },
    "variantes": [
      {
        "id": "cm123variante456",
        "talla": 40,
        "color": "negro",
        "precio": 49.99,
        "stockDisponible": 5,
        "disponible": true
      }
    ]
  }
}
```

Los productos en estado `borrador` o `archivado` no aparecerán normalmente en el catálogo público.

Las variantes inactivas o descontinuadas tampoco estarán disponibles para compra.

---

### 10.5 Carrito

Todos los endpoints del carrito requieren un cliente autenticado.

| Método | Ruta | Acceso | Alcance | Descripción |
|---|---|---|---|---|
| `GET` | `/api/v1/carrito` | Cliente | MVP | Consultar carrito activo |
| `POST` | `/api/v1/carrito/items` | Cliente | MVP | Agregar una variante |
| `PATCH` | `/api/v1/carrito/items/:itemId` | Cliente | MVP | Modificar cantidad |
| `DELETE` | `/api/v1/carrito/items/:itemId` | Cliente | MVP | Eliminar un elemento |
| `DELETE` | `/api/v1/carrito` | Cliente | MVP | Vaciar el carrito |
| `GET` | `/api/v1/carrito/direccion-entrega` | Cliente | MVP | Consultar dirección del carrito |
| `PUT` | `/api/v1/carrito/direccion-entrega` | Cliente | MVP | Crear o reemplazar dirección |
| `DELETE` | `/api/v1/carrito/direccion-entrega` | Cliente | MVP | Eliminar dirección temporal |

#### Agregar elemento

Solicitud:

```json
{
  "varianteId": "cm123variante456",
  "cantidad": 2
}
```

#### Modificar cantidad

Solicitud:

```json
{
  "cantidad": 3
}
```

#### Dirección de entrega

Solicitud:

```json
{
  "nombreCompleto": "Juan Pérez",
  "telefono": "0999999999",
  "provincia": "Pichincha",
  "ciudad": "Quito",
  "direccionLinea1": "Av. Principal y Calle Secundaria",
  "direccionLinea2": null,
  "referencia": "Frente al parque",
  "notasEntrega": "Llamar antes de llegar"
}
```

El carrito no reserva ni descuenta stock.

El stock deberá volver a validarse durante el checkout.

---

### 10.6 Checkout

Los endpoints de checkout requieren un cliente autenticado y un carrito activo.

| Método | Ruta | Acceso | Alcance | Descripción |
|---|---|---|---|---|
| `POST` | `/api/v1/checkout/validar` | Cliente | MVP | Validar carrito y datos de compra |
| `POST` | `/api/v1/checkout/confirmar` | Cliente | MVP | Confirmar compra y crear pedido |

#### Validar checkout

Solicitud:

```json
{
  "metodoPago": "transferencia",
  "tipoEntrega": "domicilio"
}
```

Métodos de pago permitidos en el MVP:

- `transferencia`;
- `contraEntrega`.

Tipos de entrega permitidos:

- `domicilio`;
- `retiroEnTienda`.

Respuesta:

```json
{
  "data": {
    "carritoId": "cm123carrito456",
    "subtotal": 89.98,
    "costoEnvio": 3.00,
    "total": 92.98,
    "metodoPago": "transferencia",
    "tipoEntrega": "domicilio",
    "stockValido": true,
    "direccionValida": true
  }
}
```

#### Confirmar checkout

Solicitud:

```json
{
  "metodoPago": "transferencia",
  "tipoEntrega": "domicilio"
}
```

El backend deberá recalcular todos los precios y validar nuevamente el stock antes de crear el pedido.

El frontend no enviará el total como fuente definitiva.

---

### 10.7 Pedidos y devoluciones

#### Endpoints del cliente

| Método | Ruta | Acceso | Alcance | Descripción |
|---|---|---|---|---|
| `GET` | `/api/v1/pedidos` | Cliente | MVP | Consultar historial propio |
| `GET` | `/api/v1/pedidos/:pedidoId` | Cliente propietario | MVP | Consultar detalle |
| `POST` | `/api/v1/pedidos/:pedidoId/comprobante-transferencia` | Cliente propietario | MVP | Registrar comprobante o código |
| `GET` | `/api/v1/pedidos/:pedidoId/comprobante-digital` | Cliente propietario | MVP | Consultar comprobante digital |
| `POST` | `/api/v1/pedidos/:pedidoId/cambios` | Cliente propietario | MVP+ | Solicitar cambio o devolución |
| `GET` | `/api/v1/pedidos/:pedidoId/cambios` | Cliente propietario | MVP+ | Consultar solicitudes |

#### Comprobante de transferencia

Solicitud inicial:

```json
{
  "codigoTransferencia": "TRX-123456"
}
```

El modelo actual contempla `codigoTransferencia`.

Si se requiere almacenar una imagen o archivo del comprobante, deberá ampliarse el modelo y utilizar el servicio de almacenamiento definido para el proyecto.

#### Solicitud de cambio o devolución

Ejemplo:

```json
{
  "motivo": "La talla no corresponde",
  "items": [
    {
      "varianteDevueltaId": "cm123variante456",
      "varianteEntregadaId": "cm789variante012",
      "cantidad": 1
    }
  ]
}
```

Estados previstos:

- `solicitado`;
- `aprobado`;
- `completado`;
- `rechazado`.

Aunque las historias originales los ubicaron dentro del MVP, el modelo de datos y el plan vigente los clasifican como MVP+. Se conservarán en el contrato para trazabilidad, pero su implementación se realizará después del flujo principal de compra.

---

### 10.8 Inventario

Los endpoints de inventario estarán restringidos al administrador y vendedor según la operación.

| Método | Ruta | Acceso | Alcance | Descripción |
|---|---|---|---|---|
| `GET` | `/api/v1/admin/inventario` | Admin/Vendedor | MVP | Consultar inventario |
| `GET` | `/api/v1/admin/inventario/stock-bajo` | Admin/Vendedor | MVP | Consultar variantes con stock bajo |
| `GET` | `/api/v1/admin/inventario/reservas` | Admin/Vendedor | MVP | Consultar reservas |
| `GET` | `/api/v1/admin/inventario/movimientos` | Admin/Vendedor | MVP | Consultar movimientos |
| `POST` | `/api/v1/admin/inventario/ajustes` | Admin | MVP | Registrar ajuste manual |

#### Ajuste de inventario

Solicitud:

```json
{
  "varianteId": "cm123variante456",
  "cantidad": 2,
  "nota": "Corrección por conteo físico"
}
```

El stock nunca deberá actualizarse directamente sin crear un `MovimientoInventario`.

En los ajustes manuales, una cantidad positiva representará un incremento y una cantidad negativa representará una disminución. El resultado nunca podrá dejar el stock disponible por debajo de cero.

Tipos de movimiento oficiales:

- `reserva`;
- `liberacionReserva`;
- `salidaVenta`;
- `ingresoCambio`;
- `salidaCambio`;
- `ajuste`.

---

### 10.9 Intereses de stock

| Método | Ruta | Acceso | Alcance | Descripción |
|---|---|---|---|---|
| `POST` | `/api/v1/variantes/:varianteId/intereses-stock` | Cliente | MVP+ | Registrar interés |
| `DELETE` | `/api/v1/variantes/:varianteId/intereses-stock` | Cliente | MVP+ | Retirar interés |
| `GET` | `/api/v1/clientes/me/intereses-stock` | Cliente | MVP+ | Consultar intereses propios |
| `GET` | `/api/v1/admin/intereses-stock` | Admin/Vendedor | MVP+ | Consultar registros |
| `GET` | `/api/v1/admin/intereses-stock/resumen` | Admin | MVP+ | Consultar demanda acumulada |

El interés será único por cliente y variante.

No podrá registrarse más de una vez para la misma combinación.

El interés no representa:

- una reserva;
- una compra;
- un descuento de inventario;
- una obligación de reposición.

---

### 10.10 Administración

#### Gestión de catálogo

| Método | Ruta | Acceso | Alcance | Descripción |
|---|---|---|---|---|
| `POST` | `/api/v1/admin/productos` | Admin | MVP | Crear producto |
| `PATCH` | `/api/v1/admin/productos/:productoId` | Admin | MVP | Editar producto |
| `DELETE` | `/api/v1/admin/productos/:productoId` | Admin | MVP | Desactivar producto |
| `POST` | `/api/v1/admin/productos/:productoId/variantes` | Admin | MVP | Crear variante |
| `PATCH` | `/api/v1/admin/variantes/:varianteId` | Admin | MVP | Editar variante |
| `DELETE` | `/api/v1/admin/variantes/:varianteId` | Admin | MVP | Desactivar variante |
| `POST` | `/api/v1/admin/categorias` | Admin | MVP | Crear categoría |
| `PATCH` | `/api/v1/admin/categorias/:categoriaId` | Admin | MVP | Editar categoría |
| `POST` | `/api/v1/admin/marcas` | Admin | MVP | Crear marca |
| `PATCH` | `/api/v1/admin/marcas/:marcaId` | Admin | MVP | Editar marca |

#### Gestión de pedidos

| Método | Ruta | Acceso | Alcance | Descripción |
|---|---|---|---|---|
| `GET` | `/api/v1/admin/pedidos` | Admin/Vendedor | MVP | Listar pedidos |
| `GET` | `/api/v1/admin/pedidos/:pedidoId` | Admin/Vendedor | MVP | Consultar detalle |
| `PATCH` | `/api/v1/admin/pedidos/:pedidoId/estado` | Admin/Vendedor | MVP | Actualizar estado |
| `POST` | `/api/v1/admin/pedidos/:pedidoId/confirmar-pago` | Admin/Vendedor | MVP | Confirmar transferencia |
| `POST` | `/api/v1/admin/pedidos/:pedidoId/cancelar` | Admin/Vendedor | MVP | Cancelar pedido |
| `POST` | `/api/v1/admin/pedidos/:pedidoId/liberar-reserva` | Admin | MVP | Liberar reserva |
| `POST` | `/api/v1/admin/pedidos/:pedidoId/marcar-no-entregado` | Admin/Vendedor | MVP | Marcar contraentrega fallida |

Las transiciones serán validadas mediante la máquina de estados definida en el dominio.

#### Gestión de cambios y devoluciones

| Método | Ruta | Acceso | Alcance | Descripción |
|---|---|---|---|---|
| `GET` | `/api/v1/admin/cambios` | Admin/Vendedor | MVP+ | Listar solicitudes |
| `GET` | `/api/v1/admin/cambios/:cambioId` | Admin/Vendedor | MVP+ | Consultar detalle |
| `PATCH` | `/api/v1/admin/cambios/:cambioId/estado` | Admin | MVP+ | Aprobar o rechazar |
| `POST` | `/api/v1/admin/cambios/:cambioId/completar` | Admin/Vendedor | MVP+ | Completar cambio |

#### Reportes

| Método | Ruta | Acceso | Alcance | Descripción |
|---|---|---|---|---|
| `GET` | `/api/v1/admin/reportes/ventas` | Admin | MVP | Reporte de ventas |
| `GET` | `/api/v1/admin/reportes/productos-mas-vendidos` | Admin | MVP | Productos más vendidos |
| `GET` | `/api/v1/admin/reportes/stock-bajo` | Admin | MVP | Reporte de stock bajo |

#### Usuarios y roles

| Método | Ruta | Acceso | Alcance | Descripción |
|---|---|---|---|---|
| `GET` | `/api/v1/admin/usuarios` | Admin | Planificado | Listar usuarios internos |
| `POST` | `/api/v1/admin/usuarios` | Admin | Planificado | Crear vendedor o administrador |
| `PATCH` | `/api/v1/admin/usuarios/:usuarioId/rol` | Admin | Planificado | Cambiar rol |
| `PATCH` | `/api/v1/admin/usuarios/:usuarioId/estado` | Admin | Planificado | Activar, bloquear o desactivar |

Estos endpoints requieren ampliar el modelo actual para representar usuarios internos, roles y sesiones revocables antes de su implementación.

---

## 11. Matriz de acceso por roles

| Funcionalidad | Público | Cliente | Vendedor | Admin |
|---|:---:|:---:|:---:|:---:|
| Consultar catálogo | Sí | Sí | Sí | Sí |
| Consultar productos y variantes | Sí | Sí | Sí | Sí |
| Registrarse como cliente | Sí | No aplica | No | No |
| Iniciar sesión | Sí | Sí | Sí | Sí |
| Gestionar perfil propio | No | Sí | Sí | Sí |
| Gestionar carrito | No | Sí | No | No |
| Registrar dirección de entrega | No | Sí | No | No |
| Confirmar checkout | No | Sí | No | No |
| Consultar pedidos propios | No | Sí | No | No |
| Consultar todos los pedidos | No | No | Sí | Sí |
| Actualizar estados de pedido | No | No | Limitado | Sí |
| Confirmar pago por transferencia | No | No | Sí | Sí |
| Marcar pedido como preparado | No | No | Sí | Sí |
| Marcar pedido como enviado | No | No | Sí | Sí |
| Marcar pedido como entregado | No | No | Sí | Sí |
| Marcar pedido como no entregado | No | No | Sí | Sí |
| Liberar reserva manualmente | No | No | No | Sí |
| Consultar inventario | No | No | Sí | Sí |
| Registrar ajuste manual | No | No | No | Sí |
| Gestionar productos | No | No | No | Sí |
| Gestionar variantes | No | No | No | Sí |
| Gestionar categorías y marcas | No | No | No | Sí |
| Registrar interés de stock | No | Sí | No | No |
| Consultar intereses generales | No | No | Sí | Sí |
| Aprobar cambios o devoluciones | No | No | No | Sí |
| Completar cambios aprobados | No | No | Sí | Sí |
| Consultar reportes | No | No | Limitado | Sí |
| Gestionar usuarios y roles | No | No | No | Sí |

Además del rol, el backend deberá comprobar la propiedad del recurso.

Un cliente únicamente podrá consultar:

- su perfil;
- su carrito;
- sus pedidos;
- sus cambios;
- sus intereses de stock.

---

## 12. Reglas de negocio relevantes

### 12.1 Cliente autenticado

El cliente deberá estar autenticado para:

- gestionar su carrito;
- registrar dirección de entrega;
- confirmar el checkout;
- consultar pedidos;
- registrar comprobantes;
- solicitar cambios;
- registrar interés de stock.

---

### 12.2 Carrito

- El carrito no reserva stock.
- El carrito no descuenta inventario.
- Los precios almacenados en el carrito son referencias temporales.
- El backend deberá volver a validar precio y stock en checkout.
- No se podrán agregar cantidades menores o iguales a cero.
- No se podrá agregar una variante inactiva o descontinuada.
- No se podrá agregar una variante con stock cero.
- El cliente solo podrá modificar su carrito activo.

---

### 12.3 Inventario

- El inventario nunca puede ser negativo.
- El stock solo cambia mediante `MovimientoInventario`.
- Ningún controlador deberá modificar directamente `stockDisponible`.
- Cada movimiento deberá conservar trazabilidad.
- Las reservas, liberaciones, ventas y cambios generarán movimientos.
- Los ajustes manuales deberán incluir una nota.
- Los movimientos históricos no deberán eliminarse físicamente.

---

### 12.4 Transferencia bancaria

- El pedido inicia en estado `pendientePago`.
- La transferencia no reserva stock.
- La transferencia no descuenta stock al crear el pedido.
- El cliente dispone de un máximo de 24 horas para completar el proceso.
- El pago debe ser confirmado manualmente por un administrador o vendedor.
- Al confirmar el pago, el sistema vuelve a validar stock.
- Si existe stock, se registra la salida correspondiente.
- Si el pago no se confirma dentro del plazo, el pedido pasa a `canceladoAutomatico`.
- Un pedido cancelado automáticamente no modifica inventario.

---

### 12.5 Contraentrega

- La contraentrega estará disponible según la ubicación y reglas del negocio.
- El pedido inicia en estado `reservado`.
- La reserva descuenta inmediatamente `stockDisponible`.
- La entrega no vuelve a descontar stock.
- Si el pedido se marca como `noEntregado`, se libera la reserva.
- La liberación devuelve el stock a disponibilidad.
- La liberación genera un movimiento de inventario.
- La entrega exitosa únicamente cambia el estado del pedido.

Regla oficial:

> La reserva ya descuenta `stockDisponible`; la entrega no modifica stock, solo el estado.

---

### 12.6 Estados del pedido

Estados oficiales:

- `pendientePago`;
- `reservado`;
- `pagadoConfirmado`;
- `preparado`;
- `enviado`;
- `entregado`;
- `cancelado`;
- `noEntregado`;
- `canceladoAutomatico`.

Las transiciones deberán ser controladas por una máquina de estados.

No se permitirán cambios arbitrarios.

Ejemplo:

- un pedido `entregado` no puede volver a `preparado`;
- un pedido `cancelado` no puede marcarse como enviado;
- un pedido `pendientePago` requiere confirmación antes de continuar;
- un pedido `noEntregado` debe liberar su reserva cuando corresponda.

Cada transición deberá registrarse en `PedidoEstadoHistorial`.

---

### 12.7 Estados del catálogo

Estados del producto:

- `borrador`;
- `activo`;
- `archivado`.

Estados de variante:

- `activo`;
- `inactivo`;
- `descontinuado`.

Solo los productos y variantes disponibles según las reglas del catálogo podrán mostrarse para compra.

---

### 12.8 Intereses de stock

- Solo se registra interés por una variante específica.
- El interés será único por cliente y variante.
- El interés no reserva stock.
- El interés no crea un pedido.
- El interés no obliga al negocio a reponer el producto.
- Los registros podrán utilizarse para analizar demanda.
- Cuando el stock llegue a cero, la variante seguirá visible como no disponible cuando corresponda.
- El cliente podrá consultar otras tallas disponibles.

---

### 12.9 Precios y totales

- El frontend no determina el precio definitivo.
- El frontend no determina el total definitivo.
- El backend consulta los precios actuales.
- El backend calcula subtotal, costo de envío y total.
- Los importes se expresan en USD.
- Los pedidos guardan snapshots de precios.
- Los cambios posteriores de precio no alteran pedidos históricos.

---

### 12.10 Snapshot del pedido

El pedido deberá conservar una copia de:

- nombre del producto;
- talla;
- color;
- código interno;
- precio unitario;
- subtotal de línea;
- datos de entrega.

Esto evita que cambios posteriores en catálogo o dirección alteren la información histórica.

---

### 12.11 Cambios y devoluciones

Estados:

- `solicitado`;
- `aprobado`;
- `completado`;
- `rechazado`.

Reglas:

- únicamente un administrador puede aprobar o rechazar;
- el vendedor podrá completar operaciones autorizadas;
- el reingreso o salida de stock generará movimientos;
- las diferencias económicas deberán registrarse;
- los pedidos y movimientos originales se conservarán;
- una devolución no deberá borrar el pedido original.

---

### 12.12 Seguridad

- Las contraseñas se almacenan mediante `bcrypt`.
- El access token se devuelve en JSON.
- El refresh token se envía mediante cookie `httpOnly`.
- El registro público crea únicamente clientes.
- Los clientes acceden únicamente a sus recursos.
- Los endpoints administrativos requieren autorización.
- Las cuentas desactivadas no pueden renovar tokens.
- Los intentos repetidos de login serán limitados.
- Las respuestas no exponen datos sensibles.

---

### 12.13 Identificadores

Los modelos actuales utilizan identificadores CUID mediante Prisma.

La API los representará como cadenas.

El cliente no deberá asumir que:

- son números;
- son secuenciales;
- revelan la cantidad de registros;
- pueden generarse manualmente.

---

### 12.14 Eliminación y trazabilidad

- Los pedidos no se eliminan físicamente.
- Los movimientos de inventario no se eliminan físicamente.
- Los historiales de estado no se eliminan físicamente.
- Los productos y variantes se desactivan o archivan.
- Los recursos temporales sí podrán eliminarse físicamente.
- La información comercial debe conservarse para reportes y auditoría.

---

## 13. Trazabilidad

La trazabilidad relaciona las historias de usuario, reglas de negocio, módulos y endpoints definidos.

### 13.1 Historias del cliente

| Historias | Funcionalidad | Endpoints principales |
|---|---|---|
| `HU-CL-01` a `HU-CL-05` | Catálogo, búsqueda, filtros, detalle y variantes | `GET /productos`, `GET /productos/:productoId`, `GET /productos/:productoId/variantes` |
| `HU-CL-06` a `HU-CL-10` | Gestión del carrito | `GET /carrito`, `POST /carrito/items`, `PATCH /carrito/items/:itemId`, `DELETE /carrito/items/:itemId` |
| `HU-CL-11` | Registro | `POST /auth/registro` |
| `HU-CL-12` | Inicio de sesión | `POST /auth/login` |
| `HU-CL-13` | Recuperación de contraseña | `POST /auth/recuperar-password`, `POST /auth/restablecer-password` |
| `HU-CL-14` | Datos de envío | `PUT /carrito/direccion-entrega` |
| `HU-CL-15` | Método de entrega | `POST /checkout/validar`, `POST /checkout/confirmar` |
| `HU-CL-16` | Resumen del pedido | `POST /checkout/validar` |
| `HU-CL-17` | Método de pago | `POST /checkout/validar`, `POST /checkout/confirmar` |
| `HU-CL-18` | Confirmar pedido | `POST /checkout/confirmar` |
| `HU-CL-19` | Comprobante de transferencia | `POST /pedidos/:pedidoId/comprobante-transferencia` |
| `HU-CL-20` y `HU-CL-21` | Estado del pedido y pago | `GET /pedidos/:pedidoId` |
| `HU-CL-22` | Historial de pedidos | `GET /pedidos` |
| `HU-CL-23` | Detalle de pedido | `GET /pedidos/:pedidoId` |
| `HU-CL-24` | Comprobante digital | `GET /pedidos/:pedidoId/comprobante-digital` |

---

### 13.2 Historias de administrador y vendedor

| Historias | Funcionalidad | Endpoints principales |
|---|---|---|
| `HU-AV-01` y `HU-AV-02` | Login y permisos | `/auth/login`, guards y matriz de roles |
| `HU-AV-03` a `HU-AV-06` | Gestión de catálogo y variantes | `/admin/productos`, `/admin/variantes` |
| `HU-AV-07` | Precio por variante | `/admin/variantes/:varianteId` |
| `HU-AV-08` y `HU-AV-09` | Stock y ajustes | `/admin/inventario`, `/admin/inventario/ajustes` |
| `HU-AV-10` | Stock bajo | `/admin/inventario/stock-bajo` |
| `HU-AV-11` | Productos reservados | `/admin/inventario/reservas` |
| `HU-AV-12` | Liberar reserva | `/admin/pedidos/:pedidoId/liberar-reserva` |
| `HU-AV-13` y `HU-AV-14` | Lista y detalle de pedidos | `/admin/pedidos`, `/admin/pedidos/:pedidoId` |
| `HU-AV-15` a `HU-AV-21` | Estados, entrega y cancelaciones | `/admin/pedidos/:pedidoId/estado` y operaciones especiales |
| `HU-AV-22` a `HU-AV-24` | Cambios y devoluciones | `/admin/cambios` |
| `HU-AV-25` | Consulta de clientes | `/admin/clientes` — Post-MVP |
| `HU-AV-26` | Reporte de ventas | `/admin/reportes/ventas` |
| `HU-AV-27` | Productos más vendidos | `/admin/reportes/productos-mas-vendidos` |
| `HU-AV-28` | Confirmar transferencia | `/admin/pedidos/:pedidoId/confirmar-pago` |
| `HU-AV-29` | Pedido no entregado | `/admin/pedidos/:pedidoId/marcar-no-entregado` |

---

### 13.3 Relación con módulos arquitectónicos

| Módulo | Responsabilidad principal |
|---|---|
| `Auth` | Registro, login, tokens, sesiones y roles |
| `Clientes` | Perfil y recursos propios |
| `Catálogo` | Productos, variantes, marcas y categorías |
| `Carrito` | Carrito activo y dirección temporal |
| `Checkout` | Validación y confirmación de compra |
| `Pedidos` | Creación, consulta, estados y cambios |
| `Inventario` | Reservas, liberaciones y movimientos |
| `InteresesStock` | Interés por variantes agotadas |
| `Admin` | Operaciones internas y reportes |
| `Salud` | Disponibilidad del servicio |

---

### 13.4 Brechas detectadas antes de implementación

| Brecha | Estado actual | Acción requerida |
|---|---|---|
| Roles internos | Prisma solo contiene `Cliente` | Crear modelo de usuario interno o modelo común de usuario |
| Sesiones revocables | No existe modelo de sesión | Diseñar y migrar sesiones o refresh tokens |
| Recuperación de contraseña | No existe token temporal | Añadir mecanismo de recuperación |
| Archivo de comprobante | Solo existe `codigoTransferencia` | Ampliar modelo si se almacenarán archivos |
| Gestión de usuarios | No existe modelo para admin/vendedor | Completar modelo antes de implementar endpoints |
| Libreta de direcciones | Dirección actual pertenece al carrito | Mantener dirección por carrito en MVP o rediseñar |
| Swagger/OpenAPI | Archivo inicial creado | Completar paths, schemas y seguridad |

Estas brechas no impiden diseñar el contrato, pero deberán resolverse antes de implementar los módulos afectados.

---

## 14. Especificación OpenAPI

La especificación técnica inicial será almacenada en:

```text
docs/05-diseno-api/openapi/paulito-shoes-api-v1.yaml
```

---

### 14.1 Versión utilizada

Se utilizará:

`OpenAPI 3.1.0`

Cabecera:

```yaml
openapi: 3.1.0
```

---

### 14.2 Servidor base

Debido a que los endpoints de salud se encuentran fuera de `/api/v1`, el servidor de desarrollo deberá declararse desde la raíz:

```yaml
servers:
  - url: http://localhost:3000
    description: Entorno local de desarrollo
```

Las rutas comerciales se documentarán incluyendo el prefijo completo:

```yaml
paths:
  /api/v1/productos:
    get:
      summary: Listar productos
```

Los endpoints técnicos se documentarán como:

```yaml
paths:
  /health:
    get:
      summary: Consultar estado general
```

---

### 14.3 Etiquetas

La especificación utilizará etiquetas para agrupar endpoints:

- Salud;
- Autenticación;
- Clientes;
- Catálogo;
- Carrito;
- Checkout;
- Pedidos;
- Inventario;
- Intereses de stock;
- Administración;
- Reportes.

---

### 14.4 Esquemas reutilizables

Los contratos compartidos se definirán dentro de:

```yaml
components:
  schemas:
```

Esquemas iniciales previstos:

- `Cliente`;
- `UsuarioAutenticado`;
- `Producto`;
- `VarianteProducto`;
- `Marca`;
- `Categoria`;
- `Carrito`;
- `CarritoItem`;
- `DireccionEntrega`;
- `ProcesoCompra`;
- `Pedido`;
- `PedidoItem`;
- `MovimientoInventario`;
- `InteresStock`;
- `CambioPedido`;
- `RespuestaError`;
- `MetaPaginacion`.

---

### 14.5 Esquema de seguridad

El access token se documentará mediante:

```yaml
components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
```

Los endpoints protegidos utilizarán:

```yaml
security:
  - bearerAuth: []
```

El refresh token será enviado mediante cookie y podrá documentarse con un esquema adicional:

```yaml
components:
  securitySchemes:
    refreshCookie:
      type: apiKey
      in: cookie
      name: refreshToken
```

---

### 14.6 Respuestas comunes

Se crearán componentes reutilizables para:

- `BadRequest`;
- `Unauthorized`;
- `Forbidden`;
- `NotFound`;
- `Conflict`;
- `UnprocessableEntity`;
- `TooManyRequests`;
- `InternalServerError`.

Ejemplo:

```yaml
components:
  responses:
    Unauthorized:
      description: Usuario no autenticado o token inválido
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/RespuestaError'
```

---

### 14.7 Parámetros comunes

Se definirán parámetros reutilizables para:

- `pagina`;
- `limite`;
- `buscar`;
- `ordenPor`;
- `direccion`;
- `desde`;
- `hasta`.

Ejemplo:

```yaml
components:
  parameters:
    Pagina:
      name: pagina
      in: query
      schema:
        type: integer
        minimum: 1
        default: 1
```

---

### 14.8 Estado de la especificación

La especificación OpenAPI se construirá progresivamente en este orden:

1. información general;
2. servidores;
3. etiquetas;
4. esquemas comunes;
5. seguridad;
6. endpoints de salud;
7. endpoints de autenticación;
8. catálogo;
9. carrito;
10. checkout;
11. pedidos;
12. inventario;
13. administración;
14. respuestas comunes;
15. validación final.

La especificación deberá mantenerse sincronizada con el documento Markdown y con la implementación real.

Cuando exista una diferencia entre el código y la documentación, deberá corregirse el contrato o la implementación antes de considerar completada la funcionalidad.

## 15. Decisiones pendientes y brechas de implementación

Durante el diseño de la API se identificaron decisiones que ya fueron resueltas y brechas que deberán atenderse antes de implementar determinados módulos.

### 15.1 Decisiones resueltas

- La API utilizará el prefijo `/api/v1`.
- Las rutas del dominio se escribirán principalmente en español.
- Los términos técnicos de autenticación podrán conservarse en inglés.
- Las colecciones utilizarán sustantivos en plural.
- Las propiedades JSON utilizarán `camelCase`.
- Las fechas se representarán mediante ISO 8601 y UTC.
- Los identificadores se expondrán como cadenas CUID.
- Las respuestas exitosas utilizarán la propiedad `data`.
- Las colecciones paginadas incluirán la propiedad `meta`.
- Los errores utilizarán una estructura uniforme.
- La paginación utilizará los parámetros `pagina` y `limite`.
- El access token se devolverá en JSON.
- El refresh token se enviará mediante cookie `httpOnly`.
- El registro público creará únicamente clientes.
- El inventario solo podrá modificarse mediante movimientos.
- Los endpoints administrativos utilizarán el prefijo `/api/v1/admin`.
- Los métodos de pago del MVP serán transferencia y contraentrega.
- Los endpoints de salud permanecerán fuera de `/api/v1`.

### 15.2 Brechas antes de implementación

- El modelo Prisma actual deberá ampliarse para representar usuarios internos con roles `admin` y `vendedor`.
- Se deberá crear una estrategia persistente para sesiones y refresh tokens revocables.
- Se deberá definir el almacenamiento de tokens temporales para recuperación de contraseña.
- Se deberá ampliar el modelo si se almacenarán archivos de comprobantes de transferencia.
- Se deberá decidir si las direcciones seguirán asociadas únicamente al carrito o evolucionarán hacia una libreta de direcciones.
- Se deberá implementar una máquina de estados para controlar las transiciones de pedidos.
- Se deberán definir los permisos exactos del vendedor mediante guards y reglas de aplicación.
- Se deberá implementar idempotencia en las operaciones críticas de checkout y pagos.
- Se deberá completar y validar la especificación OpenAPI.
- Se deberán mantener sincronizados Prisma, OpenAPI, controladores y documentación.

Estas brechas no invalidan el contrato diseñado. Representan tareas técnicas necesarias antes de implementar los módulos correspondientes.

---

## 16. Lista de progreso

- [x] Preparar estructura documental.
- [x] Crear documento principal.
- [x] Crear archivo base de OpenAPI.
- [x] Definir convenciones REST.
- [x] Diseñar autenticación y autorización.
- [x] Definir respuestas exitosas.
- [x] Definir manejo uniforme de errores.
- [x] Definir paginación, filtros y ordenamiento.
- [x] Diseñar endpoints del cliente.
- [x] Diseñar endpoints administrativos.
- [x] Crear matriz de acceso por roles.
- [x] Documentar reglas de negocio relevantes.
- [x] Crear trazabilidad con historias de usuario.
- [x] Identificar brechas antes de implementación.
- [ ] Traducir el contrato inicial a OpenAPI.
- [ ] Validar sintaxis del archivo OpenAPI.
- [ ] Realizar revisión final de consistencia.
- [ ] Registrar commits de cierre.
