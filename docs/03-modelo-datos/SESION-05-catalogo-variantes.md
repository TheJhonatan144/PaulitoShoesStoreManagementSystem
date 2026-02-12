# Fase 3 - Modelo de Datos
## Sesión 5 - Catálogo y Variantes (Modelo Conceptual MVP)

Fecha: 2026-02-12  
Tipo: Modelo Conceptual (sin Prisma / sin SQL)

---

# 1. Contexto real del negocio

Paulito Shoes Store trabaja principalmente con calzado nacional.    
Los productos no poseen códigos de fábrica confiables.

La mercadería se compra por series de tallas:

- Serie pequeña: 21–26
- Serie mediana: 27–32
- Serie grande: 37–42

Cada serie tiene un precio diferente.
Todas las tallas dentro de una misma serie comparten el mismo precio.

El color se ingresa manualmente como texto libre al momento de registrar la mercadería.

---

# 2. Entidades MVP — Catálogo

---

## 2.1 Producto (Modelo base)

### Propósito
Representa el modelo general del zapato.
Agrupa variantes por talla y color.

### Atributos MVP

- id (identificador interno del sistema)
- nombre (nombre del modelo)
- descripcion (descripción general del modelo)
- marcaId (referencia a la marca)
- categoriaId (referencia a la categoría principal)
- grupoObjetivo (niño, niña, hombre, mujer, unisex)
- estado (borrador, activo, archivado)
- notaPrecioBase (nota opcional si el precio depende de series)
- fechaCreacion
- fechaActualizacion

### Reglas de negocio

- No contiene stock.
- No contiene talla.
- No contiene color.
- Es una entidad organizadora del catálogo.
- Puede existir sin variantes mientras esté en estado borrador.

---

## 2.2 VarianteProducto (Talla x Color)

### Propósito
Representa la unidad real vendible y controlada en inventario.

Cada combinación de:
Producto + Color + Talla
es una variante distinta.

### Atributos MVP

- id
- productoId (relación con Producto)
- talla (numérica: 21, 22, 23… 42)
- color (texto libre ingresado manualmente)
- tipoSerie (pequena, mediana, grande)
- precio (precio específico según la serie)
- stockDisponible (cantidad disponible)
- codigoInterno (SKU interno generado por el sistema)
- estado (activo, inactivo, descontinuado)
- notaVariante (opcional)
- fechaCreacion
- fechaActualizacion

### Reglas de negocio

- El stock vive aquí.
- El precio vive aquí (porque depende de la serie).
- Una variante es única por combinación:
  (productoId + talla + color)
- Si stockDisponible = 0, no se puede comprar.

---

# 3. Generación de Código Interno (MVP)

Debido a que los productos no tienen código de fábrica,
el sistema generará un código interno estable.

Formato recomendado:

[MARCA]-[MODELO]-[COLOR]-[TALLA]

Ejemplo:
PATOLINE-ESCOLAR-NEGRO-21

Reglas:

- Se genera al crear la variante.
- No cambia aunque cambie el nombre visible.
- Debe ser único en todo el sistema.

---

# 4. Decisiones Arquitectónicas Tomadas

✔ El stock no vive en Producto.  
✔ El precio depende de la serie, por eso vive en VarianteProducto.  
✔ El color es texto libre para facilitar la operación real del negocio.  
✔ Se crea código interno obligatorio.  
✔ Se permite más de una unidad por variante (no es único por par).  
✔ Si stockDisponible = 0 en una VarianteProducto, NO se permite comprar.  
✔ El catálogo debe mostrar la variante como “Sin stock” y sugerir otras tallas disponibles del mismo Producto.  
✔ El interés “Me interesa” se registra como único por cliente usando identificador de sesión (anonimo) o clienteId (si está autenticado).

---

# 5. Relaciones Conceptuales

Producto (1) —— (N) VarianteProducto  

Marca (1) —— (N) Producto  

Categoria (1) —— (N) Producto  

VarianteProducto (1) —— (N) InteresStock  

Cliente (0..1) —— (N) InteresStock  

Una VarianteProducto pertenece obligatoriamente a un Producto.

---

# 6. Validación MVP

- [ ] Se puede identificar un modelo claramente.
- [ ] Se puede vender por talla y color.
- [ ] Se puede manejar precios por serie.
- [ ] Se puede controlar stock real.
- [ ] Se puede generar código interno estable.
- [ ] Se bloquea compra cuando stockDisponible = 0.
- [ ] Se registra demanda real mediante interés único.

---

# 7. MVP+ — Registro de Interés de Reposición (“Me interesa”)

## 7.1 Objetivo

Cuando una VarianteProducto esté sin stock (stockDisponible = 0),
el cliente puede marcar interés en comprarla.

Esta señal se usa para medir demanda real y decidir reposición con proveedores.

---

## 7.2 Entidad: InteresStock

### Propósito

Registrar el interés ÚNICO de un cliente (anónimo o autenticado) en una VarianteProducto sin stock.

### Atributos (conceptual)

- id
- varianteProductoId
- identificadorSesion (para clientes anónimos)
- clienteId (opcional, si está autenticado)
- fechaCreacion

### Reglas

- Solo se permite crear si stockDisponible = 0.
- Debe ser único por combinación:
  (varianteProductoId + identificadorSesion)
- Si el cliente está autenticado, se asegura unicidad por:
  (varianteProductoId + clienteId)
- No requiere correo ni teléfono.
- No afecta el stock.
- Sirve únicamente como métrica de demanda.
