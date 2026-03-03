-- CreateEnum
CREATE TYPE "EstadoProducto" AS ENUM ('borrador', 'activo', 'archivado');

-- CreateEnum
CREATE TYPE "EstadoVarianteProducto" AS ENUM ('activo', 'inactivo', 'descontinuado');

-- CreateEnum
CREATE TYPE "MetodoPago" AS ENUM ('transferencia', 'contraEntrega');

-- CreateEnum
CREATE TYPE "TipoEntrega" AS ENUM ('domicilio', 'retiroEnTienda');

-- CreateEnum
CREATE TYPE "EstadoPedido" AS ENUM ('pendientePago', 'reservado', 'pagadoConfirmado', 'preparado', 'enviado', 'entregado', 'cancelado', 'noEntregado', 'canceladoAutomatico');

-- CreateEnum
CREATE TYPE "TipoMovimientoInventario" AS ENUM ('reserva', 'liberacionReserva', 'salidaVenta', 'ingresoCambio', 'salidaCambio', 'ajuste');

-- CreateEnum
CREATE TYPE "ReferenciaMovimientoInventario" AS ENUM ('pedido', 'cambio', 'ajusteManual');

-- CreateEnum
CREATE TYPE "EstadoCambioPedido" AS ENUM ('solicitado', 'aprobado', 'completado', 'rechazado');

-- CreateEnum
CREATE TYPE "EstadoCuponCliente" AS ENUM ('activo', 'utilizado', 'vencido');

-- CreateEnum
CREATE TYPE "ActorTipoEstadoPedido" AS ENUM ('admin', 'vendedor', 'sistema');

-- CreateEnum
CREATE TYPE "EstadoCarrito" AS ENUM ('activo', 'convertido', 'abandonado');

-- CreateEnum
CREATE TYPE "EstadoProcesoCompra" AS ENUM ('iniciado', 'datosCompletados', 'confirmado', 'cancelado');

-- CreateTable
CREATE TABLE "Cliente" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "nombreCompleto" TEXT,
    "fechaCreacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fechaActualizacion" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Cliente_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Marca" (
    "id" TEXT NOT NULL,
    "nombre" TEXT NOT NULL,
    "estado" TEXT NOT NULL DEFAULT 'activa',
    "fechaCreacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fechaActualizacion" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Marca_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Categoria" (
    "id" TEXT NOT NULL,
    "nombre" TEXT NOT NULL,
    "descripcion" TEXT,
    "estado" TEXT NOT NULL DEFAULT 'activa',
    "fechaCreacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fechaActualizacion" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Categoria_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Producto" (
    "id" TEXT NOT NULL,
    "nombre" TEXT NOT NULL,
    "descripcion" TEXT NOT NULL,
    "marcaId" TEXT NOT NULL,
    "categoriaId" TEXT NOT NULL,
    "grupoObjetivo" TEXT NOT NULL,
    "estado" "EstadoProducto" NOT NULL DEFAULT 'borrador',
    "notaPrecioBase" TEXT,
    "fechaCreacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fechaActualizacion" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Producto_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VarianteProducto" (
    "id" TEXT NOT NULL,
    "productoId" TEXT NOT NULL,
    "talla" INTEGER NOT NULL,
    "color" TEXT NOT NULL,
    "tipoSerie" TEXT NOT NULL,
    "precio" DECIMAL(10,2) NOT NULL,
    "stockDisponible" INTEGER NOT NULL,
    "codigoInterno" TEXT NOT NULL,
    "estado" "EstadoVarianteProducto" NOT NULL DEFAULT 'activo',
    "notaVariante" TEXT,
    "fechaCreacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fechaActualizacion" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "VarianteProducto_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InteresStock" (
    "id" TEXT NOT NULL,
    "varianteProductoId" TEXT NOT NULL,
    "clienteId" TEXT NOT NULL,
    "fechaCreacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "InteresStock_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Carrito" (
    "id" TEXT NOT NULL,
    "clienteId" TEXT NOT NULL,
    "estado" "EstadoCarrito" NOT NULL DEFAULT 'activo',
    "fechaCreacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fechaActualizacion" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Carrito_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CarritoItem" (
    "id" TEXT NOT NULL,
    "carritoId" TEXT NOT NULL,
    "varianteProductoId" TEXT NOT NULL,
    "cantidad" INTEGER NOT NULL,
    "precioUnitarioRegistrado" DECIMAL(10,2) NOT NULL,
    "fechaCreacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fechaActualizacion" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CarritoItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DireccionEntrega" (
    "id" TEXT NOT NULL,
    "carritoId" TEXT NOT NULL,
    "clienteId" TEXT NOT NULL,
    "nombreCompleto" TEXT NOT NULL,
    "telefono" TEXT NOT NULL,
    "provincia" TEXT NOT NULL,
    "ciudad" TEXT NOT NULL,
    "direccionLinea1" TEXT NOT NULL,
    "direccionLinea2" TEXT,
    "referencia" TEXT,
    "notasEntrega" TEXT,
    "fechaCreacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fechaActualizacion" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DireccionEntrega_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProcesoCompra" (
    "id" TEXT NOT NULL,
    "carritoId" TEXT NOT NULL,
    "estado" "EstadoProcesoCompra" NOT NULL DEFAULT 'iniciado',
    "subtotal" DECIMAL(10,2) NOT NULL,
    "costoEnvio" DECIMAL(10,2) NOT NULL,
    "total" DECIMAL(10,2) NOT NULL,
    "metodoPago" "MetodoPago" NOT NULL,
    "tipoEntrega" "TipoEntrega" NOT NULL,
    "codigoTransferencia" TEXT,
    "fechaCreacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fechaActualizacion" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ProcesoCompra_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Pedido" (
    "id" TEXT NOT NULL,
    "numeroPedido" TEXT NOT NULL,
    "clienteId" TEXT NOT NULL,
    "procesoCompraId" TEXT NOT NULL,
    "estado" "EstadoPedido" NOT NULL,
    "subtotal" DECIMAL(10,2) NOT NULL,
    "costoEnvio" DECIMAL(10,2) NOT NULL,
    "total" DECIMAL(10,2) NOT NULL,
    "metodoPago" "MetodoPago" NOT NULL,
    "tipoEntrega" "TipoEntrega" NOT NULL,
    "nombreCompletoEntrega" TEXT,
    "telefonoEntrega" TEXT,
    "provinciaEntrega" TEXT,
    "ciudadEntrega" TEXT,
    "direccionLinea1Entrega" TEXT,
    "direccionLinea2Entrega" TEXT,
    "referenciaEntrega" TEXT,
    "codigoTransferencia" TEXT,
    "fechaReserva" TIMESTAMP(3),
    "fechaPagoConfirmado" TIMESTAMP(3),
    "fechaEntregado" TIMESTAMP(3),
    "fechaCreacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fechaActualizacion" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Pedido_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PedidoItem" (
    "id" TEXT NOT NULL,
    "pedidoId" TEXT NOT NULL,
    "varianteProductoId" TEXT NOT NULL,
    "nombreProductoRegistrado" TEXT NOT NULL,
    "tallaRegistrada" INTEGER NOT NULL,
    "colorRegistrado" TEXT NOT NULL,
    "codigoInternoRegistrado" TEXT NOT NULL,
    "cantidad" INTEGER NOT NULL,
    "precioUnitarioRegistrado" DECIMAL(10,2) NOT NULL,
    "subtotalLinea" DECIMAL(10,2) NOT NULL,

    CONSTRAINT "PedidoItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MovimientoInventario" (
    "id" TEXT NOT NULL,
    "varianteProductoId" TEXT NOT NULL,
    "tipo" "TipoMovimientoInventario" NOT NULL,
    "cantidad" INTEGER NOT NULL,
    "referenciaTipo" "ReferenciaMovimientoInventario" NOT NULL,
    "pedidoId" TEXT,
    "cambioPedidoId" TEXT,
    "nota" TEXT,
    "fechaCreacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "MovimientoInventario_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PedidoEstadoHistorial" (
    "id" TEXT NOT NULL,
    "pedidoId" TEXT NOT NULL,
    "estadoAnterior" "EstadoPedido",
    "estadoNuevo" "EstadoPedido" NOT NULL,
    "actorTipo" "ActorTipoEstadoPedido" NOT NULL,
    "actorId" TEXT,
    "nota" TEXT,
    "fechaCreacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PedidoEstadoHistorial_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CambioPedido" (
    "id" TEXT NOT NULL,
    "pedidoId" TEXT NOT NULL,
    "estado" "EstadoCambioPedido" NOT NULL DEFAULT 'solicitado',
    "motivo" TEXT,
    "fechaSolicitud" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fechaCompletado" TIMESTAMP(3),

    CONSTRAINT "CambioPedido_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CambioPedidoItem" (
    "id" TEXT NOT NULL,
    "cambioPedidoId" TEXT NOT NULL,
    "varianteDevueltaId" TEXT NOT NULL,
    "varianteEntregadaId" TEXT NOT NULL,
    "cantidad" INTEGER NOT NULL,
    "diferenciaTotal" DECIMAL(10,2),
    "metodoAjuste" TEXT,
    "nota" TEXT,

    CONSTRAINT "CambioPedidoItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CuponCliente" (
    "id" TEXT NOT NULL,
    "clienteId" TEXT NOT NULL,
    "pedidoOrigenId" TEXT,
    "montoDisponible" DECIMAL(10,2) NOT NULL,
    "estado" "EstadoCuponCliente" NOT NULL DEFAULT 'activo',
    "fechaCreacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fechaVencimiento" TIMESTAMP(3),

    CONSTRAINT "CuponCliente_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FacturaElectronica" (
    "id" TEXT NOT NULL,
    "pedidoId" TEXT NOT NULL,
    "tipoComprobante" TEXT NOT NULL,
    "identificacionComprador" TEXT NOT NULL,
    "emailEnvio" TEXT NOT NULL,
    "claveAccesoSRI" TEXT,
    "estado" TEXT NOT NULL,
    "fechaEmision" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fechaAutorizacion" TIMESTAMP(3),

    CONSTRAINT "FacturaElectronica_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Cliente_email_key" ON "Cliente"("email");

-- CreateIndex
CREATE INDEX "Cliente_email_idx" ON "Cliente"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Marca_nombre_key" ON "Marca"("nombre");

-- CreateIndex
CREATE UNIQUE INDEX "Categoria_nombre_key" ON "Categoria"("nombre");

-- CreateIndex
CREATE INDEX "Producto_marcaId_idx" ON "Producto"("marcaId");

-- CreateIndex
CREATE INDEX "Producto_categoriaId_idx" ON "Producto"("categoriaId");

-- CreateIndex
CREATE UNIQUE INDEX "VarianteProducto_codigoInterno_key" ON "VarianteProducto"("codigoInterno");

-- CreateIndex
CREATE INDEX "VarianteProducto_productoId_idx" ON "VarianteProducto"("productoId");

-- CreateIndex
CREATE INDEX "VarianteProducto_stockDisponible_idx" ON "VarianteProducto"("stockDisponible");

-- CreateIndex
CREATE UNIQUE INDEX "VarianteProducto_productoId_talla_color_key" ON "VarianteProducto"("productoId", "talla", "color");

-- CreateIndex
CREATE INDEX "InteresStock_clienteId_idx" ON "InteresStock"("clienteId");

-- CreateIndex
CREATE UNIQUE INDEX "InteresStock_varianteProductoId_clienteId_key" ON "InteresStock"("varianteProductoId", "clienteId");

-- CreateIndex
CREATE INDEX "Carrito_clienteId_idx" ON "Carrito"("clienteId");

-- CreateIndex
CREATE INDEX "CarritoItem_carritoId_idx" ON "CarritoItem"("carritoId");

-- CreateIndex
CREATE INDEX "CarritoItem_varianteProductoId_idx" ON "CarritoItem"("varianteProductoId");

-- CreateIndex
CREATE UNIQUE INDEX "DireccionEntrega_carritoId_key" ON "DireccionEntrega"("carritoId");

-- CreateIndex
CREATE INDEX "DireccionEntrega_clienteId_idx" ON "DireccionEntrega"("clienteId");

-- CreateIndex
CREATE UNIQUE INDEX "ProcesoCompra_carritoId_key" ON "ProcesoCompra"("carritoId");

-- CreateIndex
CREATE INDEX "ProcesoCompra_metodoPago_idx" ON "ProcesoCompra"("metodoPago");

-- CreateIndex
CREATE INDEX "ProcesoCompra_tipoEntrega_idx" ON "ProcesoCompra"("tipoEntrega");

-- CreateIndex
CREATE UNIQUE INDEX "Pedido_numeroPedido_key" ON "Pedido"("numeroPedido");

-- CreateIndex
CREATE UNIQUE INDEX "Pedido_procesoCompraId_key" ON "Pedido"("procesoCompraId");

-- CreateIndex
CREATE INDEX "Pedido_clienteId_idx" ON "Pedido"("clienteId");

-- CreateIndex
CREATE INDEX "Pedido_estado_idx" ON "Pedido"("estado");

-- CreateIndex
CREATE INDEX "Pedido_metodoPago_idx" ON "Pedido"("metodoPago");

-- CreateIndex
CREATE INDEX "Pedido_tipoEntrega_idx" ON "Pedido"("tipoEntrega");

-- CreateIndex
CREATE INDEX "PedidoItem_pedidoId_idx" ON "PedidoItem"("pedidoId");

-- CreateIndex
CREATE INDEX "PedidoItem_varianteProductoId_idx" ON "PedidoItem"("varianteProductoId");

-- CreateIndex
CREATE INDEX "MovimientoInventario_varianteProductoId_idx" ON "MovimientoInventario"("varianteProductoId");

-- CreateIndex
CREATE INDEX "MovimientoInventario_referenciaTipo_idx" ON "MovimientoInventario"("referenciaTipo");

-- CreateIndex
CREATE INDEX "MovimientoInventario_pedidoId_idx" ON "MovimientoInventario"("pedidoId");

-- CreateIndex
CREATE INDEX "MovimientoInventario_cambioPedidoId_idx" ON "MovimientoInventario"("cambioPedidoId");

-- CreateIndex
CREATE INDEX "PedidoEstadoHistorial_pedidoId_idx" ON "PedidoEstadoHistorial"("pedidoId");

-- CreateIndex
CREATE INDEX "PedidoEstadoHistorial_actorTipo_idx" ON "PedidoEstadoHistorial"("actorTipo");

-- CreateIndex
CREATE INDEX "CambioPedido_pedidoId_idx" ON "CambioPedido"("pedidoId");

-- CreateIndex
CREATE INDEX "CambioPedidoItem_cambioPedidoId_idx" ON "CambioPedidoItem"("cambioPedidoId");

-- CreateIndex
CREATE INDEX "CuponCliente_clienteId_idx" ON "CuponCliente"("clienteId");

-- CreateIndex
CREATE INDEX "CuponCliente_pedidoOrigenId_idx" ON "CuponCliente"("pedidoOrigenId");

-- CreateIndex
CREATE UNIQUE INDEX "FacturaElectronica_pedidoId_key" ON "FacturaElectronica"("pedidoId");

-- AddForeignKey
ALTER TABLE "Producto" ADD CONSTRAINT "Producto_marcaId_fkey" FOREIGN KEY ("marcaId") REFERENCES "Marca"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Producto" ADD CONSTRAINT "Producto_categoriaId_fkey" FOREIGN KEY ("categoriaId") REFERENCES "Categoria"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VarianteProducto" ADD CONSTRAINT "VarianteProducto_productoId_fkey" FOREIGN KEY ("productoId") REFERENCES "Producto"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InteresStock" ADD CONSTRAINT "InteresStock_varianteProductoId_fkey" FOREIGN KEY ("varianteProductoId") REFERENCES "VarianteProducto"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InteresStock" ADD CONSTRAINT "InteresStock_clienteId_fkey" FOREIGN KEY ("clienteId") REFERENCES "Cliente"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Carrito" ADD CONSTRAINT "Carrito_clienteId_fkey" FOREIGN KEY ("clienteId") REFERENCES "Cliente"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CarritoItem" ADD CONSTRAINT "CarritoItem_carritoId_fkey" FOREIGN KEY ("carritoId") REFERENCES "Carrito"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CarritoItem" ADD CONSTRAINT "CarritoItem_varianteProductoId_fkey" FOREIGN KEY ("varianteProductoId") REFERENCES "VarianteProducto"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DireccionEntrega" ADD CONSTRAINT "DireccionEntrega_carritoId_fkey" FOREIGN KEY ("carritoId") REFERENCES "Carrito"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DireccionEntrega" ADD CONSTRAINT "DireccionEntrega_clienteId_fkey" FOREIGN KEY ("clienteId") REFERENCES "Cliente"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProcesoCompra" ADD CONSTRAINT "ProcesoCompra_carritoId_fkey" FOREIGN KEY ("carritoId") REFERENCES "Carrito"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Pedido" ADD CONSTRAINT "Pedido_clienteId_fkey" FOREIGN KEY ("clienteId") REFERENCES "Cliente"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Pedido" ADD CONSTRAINT "Pedido_procesoCompraId_fkey" FOREIGN KEY ("procesoCompraId") REFERENCES "ProcesoCompra"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PedidoItem" ADD CONSTRAINT "PedidoItem_pedidoId_fkey" FOREIGN KEY ("pedidoId") REFERENCES "Pedido"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PedidoItem" ADD CONSTRAINT "PedidoItem_varianteProductoId_fkey" FOREIGN KEY ("varianteProductoId") REFERENCES "VarianteProducto"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MovimientoInventario" ADD CONSTRAINT "MovimientoInventario_varianteProductoId_fkey" FOREIGN KEY ("varianteProductoId") REFERENCES "VarianteProducto"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MovimientoInventario" ADD CONSTRAINT "MovimientoInventario_pedidoId_fkey" FOREIGN KEY ("pedidoId") REFERENCES "Pedido"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MovimientoInventario" ADD CONSTRAINT "MovimientoInventario_cambioPedidoId_fkey" FOREIGN KEY ("cambioPedidoId") REFERENCES "CambioPedido"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PedidoEstadoHistorial" ADD CONSTRAINT "PedidoEstadoHistorial_pedidoId_fkey" FOREIGN KEY ("pedidoId") REFERENCES "Pedido"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CambioPedido" ADD CONSTRAINT "CambioPedido_pedidoId_fkey" FOREIGN KEY ("pedidoId") REFERENCES "Pedido"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CambioPedidoItem" ADD CONSTRAINT "CambioPedidoItem_cambioPedidoId_fkey" FOREIGN KEY ("cambioPedidoId") REFERENCES "CambioPedido"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CuponCliente" ADD CONSTRAINT "CuponCliente_clienteId_fkey" FOREIGN KEY ("clienteId") REFERENCES "Cliente"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CuponCliente" ADD CONSTRAINT "CuponCliente_pedidoOrigenId_fkey" FOREIGN KEY ("pedidoOrigenId") REFERENCES "Pedido"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FacturaElectronica" ADD CONSTRAINT "FacturaElectronica_pedidoId_fkey" FOREIGN KEY ("pedidoId") REFERENCES "Pedido"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
