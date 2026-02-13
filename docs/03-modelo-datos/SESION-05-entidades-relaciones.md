# Fase 3 — Modelo de datos
## Sesión 5 — Identificación de entidades y relaciones

**Fecha:** 2026-02-12  
**Alcance:** Modelo conceptual (NO Prisma/SQL)

---

## 0. Reglas de la sesión
- No Prisma schema ni migraciones
- No endpoints ni pantallas
- Prioridad: MVP; marcar Post-MVP
- Orden por módulos

---

## 1. Mapa de módulos → entidades (MVP / Post-MVP)
### 1.1 Catálogo y variantes
Ver detalle completo en:
[SESION-05-catalogo-variantes.md](./SESION-05-catalogo-variantes.md)
### 1.2 Carrito y checkout
Ver detalle completo en:
[SESION-05-carrito-checkout.md](./SESION-05-carrito-checkout.md)
### 1.3 Pedidos
Ver detalle completo en:
[SESION-05-pedidos.md](./SESION-05-pedidos.md)
### 1.4 Usuarios y roles
### 1.5 Inventario y compras
### 1.6 Soporte
### 1.7 Marketing y contenido
### 1.8 Reportes

---

## 2. Entidades y atributos (conceptual)
> Por cada entidad: propósito + atributos mínimos (MVP) + atributos post-MVP (si aplica)

### [Entidad]
- Propósito:
- Atributos MVP:
- Atributos Post-MVP:

---

## 3. Relaciones y cardinalidades (conceptual)
> Escribir relaciones tipo: A (1) —— (N) B + regla de negocio.

- Relación:
  - Cardinalidad:
  - Regla / restricción:
  - Notas MVP / Post-MVP:

---

## 4. Trazabilidad: Historias de usuario → entidades
> Tabla simple

| Historia | Módulo | Entidades impactadas |
|---|---|---|

---

## 5. Checklist de validación
- [ ] Cobertura MVP por módulos
- [ ] Cobertura de historias críticas
- [ ] Relaciones definidas (1-1, 1-N, N-N)
- [ ] Entidades con “owner” claro (quién las crea/gestiona)
- [ ] Campos mínimos definidos sin sobrecarga
