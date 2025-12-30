# Visión y Alcance  
## Paulito Shoes Store

---

## 1. Introducción

Este documento describe la visión y el alcance del sistema **Paulito Shoes Store**, un e-commerce desarrollado para un local real de venta de calzado.

El objetivo de este documento es definir claramente el contexto del negocio, los objetivos del sistema y los límites de lo que el sistema hará y no hará, sirviendo como base para las siguientes fases del desarrollo del proyecto.

---

## 2. Contexto del negocio

**Paulito Shoes Store** es un negocio tradicional de venta de calzado ubicado en la ciudad de Quito, Ecuador. Su sede principal se encuentra en el Valle de los Chillos, sector Puente 3 de la Autopista General Rumiñahui, en la planta baja de un local comercial.

El negocio es administrado por la señora **Isabel Sandoval**, quien cuenta con más de 20 años de experiencia en la venta de calzado. A lo largo de este tiempo, el negocio ha logrado consolidar una base de clientes fieles gracias a la calidad de los productos ofrecidos.

El local comercializa una amplia variedad de calzado, incluyendo modelos escolares, deportivos, formales, casuales, botas de montaña y sandalias. Su catálogo está orientado a clientes de todas las edades, desde niños hasta adultos mayores. Durante la época de pandemia, el negocio tuvo experiencia en ventas a través de redes sociales, principalmente Facebook, lo que permitió mantener la actividad comercial. Sin embargo, en la actualidad, el volumen de ventas ha disminuido.

### Forma de venta actual

Actualmente, la mayoría de las ventas provienen de clientes antiguos y se realizan de manera presencial. El registro de ventas se lleva a cabo de forma manual mediante facturas y notas de venta físicas. El negocio cuenta con presencia en redes sociales como TikTok, Instagram y Facebook, aunque estas no se gestionan de forma estructurada ni constante.

También se realizan ventas en línea a través de Facebook Marketplace. Los métodos de pago aceptados incluyen efectivo, transferencias bancarias y pagos con tarjeta. Los envíos dentro de la ciudad de Quito se realizan mediante un familiar del negocio, mientras que los envíos a otras provincias se gestionan a través de empresas de mensajería como Servientrega, previo depósito bancario. El costo del envío es asumido por el cliente. Actualmente, no se realizan ventas internacionales.

### Administración del negocio

La administración general del negocio está a cargo de la señora Isabel Sandoval, quien se encarga de la selección de proveedores, control de calidad del calzado, organización de horarios de atención del local, manejo de ingresos y pagos al personal.

### Clientes del negocio

El principal grupo de clientes está conformado por familias con niños, debido a la variedad de calzado infantil disponible. Como segundo grupo, se atiende a adultos interesados en botas de montaña y calzado casual o formal, tanto para hombres como para mujeres. Existe además un segmento menor de jóvenes y deportistas que buscan zapatillas para actividades deportivas.

La mayoría de los compradores se encuentran en el área metropolitana de Quito. Las ventas a nivel nacional se realizan de forma ocasional a través de plataformas como Facebook Marketplace.

---

## 3. Problema actual

El negocio presenta una serie de dificultades operativas debido a la ausencia de un sistema digital centralizado. Actualmente, no existe un control automatizado del inventario, por lo que los productos nuevos que ingresan al local no se registran en ningún sistema informático ni base de datos. Toda la información se maneja de forma manual en cuadernos, lo que dificulta conocer rápidamente qué productos están disponibles y cuáles no.

El registro de ventas también se realiza de manera manual, anotando información como modelo, color, talla, precio y fecha. Este proceso resulta lento y poco eficiente cuando se requiere analizar qué productos se han vendido, identificar inconsistencias en caja o realizar inventarios periódicos. En casos donde el dinero en caja no cuadra, es necesario revisar manualmente todos los registros y consultar al personal de ventas, lo que incrementa el tiempo de resolución y la posibilidad de errores.

Además, no se cuenta con información consolidada que permita identificar los productos más vendidos, las temporadas de mayor demanda o los modelos con baja rotación. Esta falta de datos dificulta la toma de decisiones oportunas, genera pérdidas de ventas potenciales y limita la optimización de recursos del negocio.

---

## 4. Objetivos del sistema

### Objetivo general

Desarrollar un sistema de comercio electrónico que permita digitalizar y optimizar la gestión y venta de calzado del negocio **Paulito Shoes Store**.

### Objetivos específicos

- Facilitar la venta de productos a través de una plataforma en línea.
- Permitir la gestión centralizada de productos e inventario.
- Mejorar la experiencia del cliente mediante un proceso de compra estructurado.
- Apoyar la toma de decisiones mediante el registro y análisis de ventas.
- Diseñar un sistema escalable que permita la incorporación de nuevas funcionalidades en el futuro.
- Garantizar que el sistema sea accesible desde distintos dispositivos (multiplataforma).
- Contribuir al crecimiento y organización del negocio familiar.

---

## 5. Alcance del sistema

### 5.1 Qué SÍ hace el sistema

- Permite a los clientes visualizar los productos disponibles.
- Permite a los clientes realizar compras en línea.
- Permite al administrador gestionar productos, precios y stock.
- Registra los pedidos realizados por los clientes.
- Proporciona un canal digital de atención al cliente (por ejemplo, chat o formulario de contacto).
- Genera comprobantes digitales de compra para el cliente.

### 5.2 Qué NO hace el sistema

- No gestiona logística de envíos externos.
- No integra pasarelas de pago internacionales en la primera versión del sistema.
- No reemplaza completamente la atención presencial del negocio.
