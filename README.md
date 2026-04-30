# Propuesta académica de proyecto
## Base de Datos II: Sistema de ventas (POS minimarket)

---

## Índice
1. Introducción
2. Objetivo del proyecto
3. Justificación académica y técnica
4. Análisis del repositorio de referencia
5. Delimitación del alcance del proyecto
6. Requerimientos del sistema
7. Reglas de negocio
8. Propuesta de modelo de datos
9. Referencias
10. Conclusión
11. Anexos

---

## 1. Introducción
El presente documento desarrolla una propuesta formal para la asignatura Base de Datos II, orientada al diseño de un sistema de ventas para minimarket. La finalidad principal es estructurar una base de datos relacional que permita representar con precisión los procesos básicos de una operación comercial de mostrador. La propuesta se construye con base en evidencia técnica obtenida de un proyecto de referencia en GitHub, el cual sirve como punto de partida para definir componentes funcionales, entidades de datos y límites de implementación (betofleitass, s. f.).

Desde una perspectiva académica, el proyecto permite aplicar de manera integrada los contenidos centrales del curso: levantamiento de requerimientos, definición de reglas de negocio, modelado entidad-relación, normalización, traducción al modelo relacional y elaboración de consultas SQL para análisis operativo. En consecuencia, se plantea un alcance controlado que garantice profundidad conceptual y viabilidad de entrega.

---

## 2. Objetivo del proyecto
Diseñar e implementar una base de datos relacional para un sistema de ventas de pequeña escala, capaz de registrar clientes, productos, categorías, transacciones de venta y detalle de venta, manteniendo consistencia e integridad de la información.

### Objetivos específicos:
1. Identificar y documentar requerimientos funcionales y no funcionales del sistema.
2. Definir un conjunto claro de reglas de negocio que guíen la estructura de datos.
3. Elaborar un modelo conceptual y relacional normalizado hasta tercera forma normal.
4. Implementar la estructura lógica en PostgreSQL mediante sentencias DDL.
5. Construir consultas SQL que validen operaciones y generen información útil para toma de decisiones básicas.

---

## 3. Justificación académica y técnica
El tema POS minimarket se considera pertinente por tres razones. Primero, representa un caso real de alta frecuencia en el entorno local y, por ello, facilita la comprensión de procesos de negocio concretos. Segundo, incorpora relaciones de uno a muchos y dependencias funcionales suficientes para demostrar competencias de modelado, normalización y consultas multitabla. Tercero, su complejidad es intermedia: no es trivial, pero tampoco excede la capacidad de implementación dentro del plazo académico.

En términos metodológicos, el proyecto favorece la trazabilidad entre problema, diseño de datos y validación por consultas. Esto permite que la solución no se limite a una estructura de tablas, sino que evidencie coherencia entre requerimientos, integridad referencial y resultados esperados del sistema.

---

## 4. Análisis del repositorio de referencia
**Repositorio analizado:**
https://github.com/betofleitass/django_point_of_sale

El repositorio presenta una arquitectura modular que resulta útil como base conceptual para el proyecto. Se identifican, de forma principal, los siguientes componentes:

1. **Clientes (Customer):** almacenamiento de datos personales y de contacto.
2. **Productos y categorías (Product, Category):** clasificación comercial y precio.
3. **Ventas y detalle (Sale, SaleDetail):** registro de cabecera de transacción y desglose por ítems.
4. **Autenticación de usuarios:** control de acceso para la operación del sistema.

El valor académico del repositorio radica en que ya organiza los procesos nucleares de una venta, permitiendo adaptar su lógica a un diseño de base de datos delimitado, sin necesidad de replicar módulos no esenciales para esta fase.

---

## 5. Delimitación del alcance del proyecto
La delimitación responde al criterio de lograr una implementación sólida en un plazo corto, priorizando calidad de modelado sobre amplitud funcional.

### 5.1 Alcance incluido
1. Gestión de categorías de producto.
2. Gestión de productos con estado activo/inactivo.
3. Gestión de clientes.
4. Registro de ventas y detalle de ventas con múltiples ítems.
5. Cálculo de subtotal, impuesto, total, pago y cambio.
6. Consultas de análisis básico (ventas por fecha, clientes con mayor frecuencia de compra y productos más vendidos).

### 5.2 Alcance excluido
1. Manejo de múltiples sucursales y transferencias de inventario.
2. Módulo de compras a proveedores.
3. Devoluciones, anulaciones y notas de crédito.
4. Facturación electrónica e integraciones tributarias.
5. Despliegue en producción y arquitectura de alta disponibilidad.
6. Control avanzado de seguridad y auditoría completa.

Esta delimitación evita la sobrecarga funcional y mantiene el proyecto enfocado en los aprendizajes evaluables en Base de Datos II.

---

## 6. Requerimientos del sistema

### 6.1 Requerimientos funcionales
1. El sistema debe permitir registrar, editar y consultar clientes.
2. El sistema debe permitir registrar categorías y productos.
3. El sistema debe permitir generar una venta con uno o varios productos.
4. El sistema debe calcular automáticamente los montos de la transacción.
5. El sistema debe permitir consultar historial de ventas por cliente y por período.

### 6.2 Requerimientos no funcionales
1. La base de datos se implementará en PostgreSQL.
2. Se aplicarán claves primarias, foráneas y restricciones de integridad.
3. El modelo se normalizará hasta tercera forma normal (3FN).
4. La nomenclatura de objetos de base de datos será consistente y mantenible.
5. Las consultas de validación deberán ser reproducibles en pgAdmin.

---

## 7. Reglas de negocio
1. Toda venta debe tener al menos un detalle asociado.
2. Cada detalle de venta debe estar vinculado a un producto existente.
3. El total de una venta será la suma de subtotales de detalle más impuesto.
4. El monto pagado debe ser mayor o igual al total para calcular cambio.
5. Los productos inactivos no pueden participar en nuevas ventas.
6. La eliminación de categorías o productos con transacciones históricas no se realizará de forma física, sino lógica.

Estas reglas son fundamentales para conservar coherencia histórica y evitar inconsistencias en reportes.

---

## 8. Propuesta de modelo de datos

### 8.1 Entidades principales
1. usuario
2. cliente
3. categoria
4. producto
5. venta
6. detalle_venta

### 8.2 Relaciones principales
1. categoria (1) a (N) producto
2. cliente (1) a (N) venta
3. usuario (1) a (N) venta
4. venta (1) a (N) detalle_venta
5. producto (1) a (N) detalle_venta

### 8.3 Criterio de normalización
La estructura propuesta separa catálogos, transacciones y detalle transaccional para evitar redundancia. El precio de venta por ítem se conserva en `detalle_venta` para mantener trazabilidad histórica ante cambios de precio en `producto`. Este criterio asegura consistencia analítica y respalda consultas comparativas por período.

---

## 9. Referencias
betofleitass. (s. f.). *django_point_of_sale* [Código fuente]. GitHub.
https://github.com/betofleitass/django_point_of_sale

---

## 10. Conclusión
La propuesta de sistema de ventas para minimarket es académicamente pertinente, técnicamente viable y metodológicamente coherente con los resultados de aprendizaje de Base de Datos II. El proyecto delimita su alcance para priorizar la calidad del diseño relacional, la integridad de la información y la capacidad de análisis mediante SQL. En síntesis, el documento establece una base sólida para avanzar hacia la construcción del diagrama entidad-relación, la implementación DDL en PostgreSQL y la validación funcional mediante consultas.

---

## 11. Anexos

### 11.1 Diagrama E-R
![Diagrama E-R](assets/imagenes/Diagrama%20E-R.png)

### 11.2 Diagrama Entidad Relacion Mejorado (EER)
![Diagrama Entidad Relacion Mejorado (EER)](assets/imagenes/Diagrama%20Entidad%20Relacion%20Mejorado%20%28EER%29.png)

### 11.3 Esquema
![Esquema](assets/imagenes/Esquema.jpeg)
