# Sistema de Gestión de Ventas - MiniSuper POS
## Base de Datos II: Proyecto Académico

---

## Contenido

1. Introducción
2. Objetivo del proyecto
3. Justificación académica y técnica
4. Análisis del repositorio de referencia
5. Delimitación del alcance
6. Requerimientos del sistema
7. Reglas de negocio
8. Modelo de datos
9. Cronograma de implementación
10. Arquitectura técnica
11. Referencias
12. Conclusión
13. Anexos

---

## 1. Introducción

El presente documento describe el diseño e implementación de un sistema de gestión de ventas para comercios de pequeña escala (minimarket). El sistema implementa una base de datos relacional en PostgreSQL que permite registrar transacciones de venta, mantener inventario, gestionar clientes y generar reportes operativos.

El proyecto responde a los objetivos de aprendizaje del curso Base de Datos II, aplicando conceptos de modelado entidad-relación, normalización, integridad referencial y consultas SQL.

---

## 2. Objetivo del proyecto

Diseñar e implementar una base de datos relacional funcional para un sistema de punto de venta (POS) que permita:

- Registrar y gestionar clientes
- Administrar inventario de productos y categorías
- Procesar transacciones de venta con múltiples ítems
- Calcular montos y generar facturas
- Consultar historial de operaciones

### Objetivos específicos

1. Diseñar un modelo entidad-relación normalizado hasta tercera forma normal (3FN)
2. Implementar la estructura lógica mediante DDL en PostgreSQL
3. Establecer integridad referencial y validación de datos mediante constraints
4. Automatizar operaciones mediante triggers
5. Proporcionar una interfaz API REST para acceso a datos
6. Documentar el sistema y permitir su extensión

---

## 3. Justificación académica y técnica

El tema de un sistema POS para minimarket es pertinente porque:

1. Representa un caso de uso real frecuente en el entorno comercial local
2. Incorpora relaciones complejas (uno a muchos, muchos a muchos) que demuestran competencias de modelado
3. Requiere normalización cuidadosa para evitar redundancia
4. Permite implementación en plazo académico sin excedera complejidad excesiva

Desde la perspectiva técnica, el proyecto integra:

- Modelado conceptual y relacional
- Definición de restricciones de integridad
- Automatización mediante triggers y vistas
- Consultas SQL para análisis
- Arquitectura de capas (API REST)

---

## 4. Análisis del repositorio de referencia

Se analizó el repositorio: https://github.com/betofleitass/django_point_of_sale

Componentes identificados:

1. **Gestión de clientes**: Registro de datos personales y de contacto
2. **Gestión de productos**: Catálogo con categorías y precios
3. **Gestión de ventas**: Registro de transacciones con desglose de ítems
4. **Control de acceso**: Autenticación de usuarios por rol

El repositorio sirvió como referencia conceptual para definir las entidades y relaciones del modelo.

---

## 5. Delimitación del alcance

### Incluido

1. Gestión de categorías de producto
2. Gestión de productos (alta, baja, modificación, consulta)
3. Gestión de clientes
4. Registro de ventas con múltiples ítems
5. Cálculo automático de totales e impuestos
6. Control de inventario
7. Consultas de análisis básico por fecha, cliente y producto

### Excluido

1. Múltiples sucursales
2. Compras a proveedores
3. Devoluciones y notas de crédito
4. Facturación electrónica
5. Despliegue en alta disponibilidad
6. Auditoría completa

---

## 6. Requerimientos del sistema

### Requerimientos funcionales

1. El sistema debe permitir crear, actualizar y consultar clientes
2. El sistema debe permitir crear, actualizar y consultar productos y categorías
3. El sistema debe permitir registrar ventas con uno o más ítems
4. El sistema debe calcular automáticamente subtotales, impuestos y totales
5. El sistema debe permitir consultar historial de ventas por cliente y período
6. El sistema debe mantener registro de cambios en precios y costos

### Requerimientos no funcionales

1. Base de datos: PostgreSQL 12 o superior
2. Modelo normalizado hasta 3FN
3. Integridad referencial mediante foreign keys
4. Validación de datos mediante constraints
5. Automatización mediante triggers
6. Consultas reproducibles y documentadas
7. API REST para acceso programático

---

## 7. Reglas de negocio

1. Toda venta requiere al menos un detalle de ítem
2. Cada ítem debe estar vinculado a un producto existente
3. El total de venta es la suma de ítems más impuesto
4. Los productos inactivos no pueden participar en nuevas ventas
5. La eliminación de datos es lógica (marcado como inactivo), no física
6. Los precios se registran con precisión de dos decimales
7. Los montos se expresan en Bolivianos (Bs)
8. El costo de un producto debe ser menor que su precio de venta

---

## 8. Modelo de datos

### Entidades principales

| Entidad | Descripción |
|---------|------------|
| roles | Roles de acceso (admin, vendedor, gerente) |
| usuarios | Cuentas de usuario del sistema |
| categorias | Categorías de productos |
| productos | Catálogo de productos con precios |
| clientes | Base de clientes |
| ventas | Cabecera de transacciones |
| detalle_ventas | Ítems de cada transacción |

### Relaciones principales

- categorias (1) a muchos (N) productos
- clientes (1) a N ventas
- usuarios (1) a N ventas
- ventas (1) a N detalle_ventas
- productos (1) a N detalle_ventas

### Criterio de normalización

La estructura implementa tercera forma normal (3FN) para eliminar redundancia. El precio de venta se almacena en detalle_ventas para mantener trazabilidad histórica ante cambios de precio.

---

## 9. Cronograma de implementación

### Fase 1: Backend SQL y estructura

Completado. Incluye:

- Schema SQL con 7 tablas
- Índices para optimización
- Vistas analíticas
- Triggers automáticos
- Estructura de carpetas

### Fase 2: Población de datos y API REST

Completado. Incluye:

- Base de datos poblada
- 10 productos, 10 clientes, 10 categorías
- API conectada a PostgreSQL
- Endpoints GET y PUT funcionales
- Formato de precios consistente (2 decimales)

### Fase 3: Endpoints CRUD completo

Pendiente. Incluirá:

- Endpoints POST (crear registros)
- Endpoints DELETE (eliminación lógica)
- Validación avanzada
- Manejo de errores

### Fase 4: Frontend e integración

Pendiente. Incluirá:

- Interfaz HTML/CSS/JavaScript
- Integración con API
- Módulo de ventas
- Reportes básicos
- Deployment en producción

---

## 10. Arquitectura técnica

### Stack tecnológico

| Componente | Tecnología | Versión |
|-----------|-----------|---------|
| Base de datos | PostgreSQL | 12+ |
| Backend | Python + Flask | 3.9+ / 2.3+ |
| ORM | SQLAlchemy | 3.0+ |
| Frontend | HTML/CSS/JavaScript | ES6+ |

### Estructura de carpetas

```
backend/
├── sql/
│   ├── schema.sql           # DDL - Tablas, índices, triggers
│   └── seed_30_datos.sql    # DML - Datos iniciales
│
├── aplicacion.py            # API Flask
├── requirements.txt         # Dependencias
├── .env                      # Variables de entorno
├── .env.example             # Plantilla de variables
├── .gitignore               # Control de versionado
└── README.md                # Documentación backend
```

### Especificación de base de datos

- Tablas: 7 (roles, usuarios, categorias, productos, clientes, ventas, detalle_ventas)
- Índices: 10 (optimización de búsquedas frecuentes)
- Vistas: 3 (análisis de ventas, stock crítico, desempeño)
- Triggers: 2 (actualización automática de fechas)

### Tipos de datos

```sql
-- Identificadores
id_* : INTEGER SERIAL

-- Moneda (Bolivianos)
precio_costo : numeric(10,2)
precio_venta : numeric(10,2)
total : numeric(10,2)

-- Documento
ci_nit : VARCHAR(20) UNIQUE

-- Estados
estado : VARCHAR(20) CHECK ('activo' o 'inactivo')
```

---

## 11. Referencias

betofleitass. (s.f.). django_point_of_sale. GitHub. https://github.com/betofleitass/django_point_of_sale

PostgreSQL Global Development Group. (2024). PostgreSQL Documentation. https://www.postgresql.org/docs/

Sommerville, I. (2016). Software Engineering (10th ed.). Pearson Education.

---

## 12. Conclusión

El sistema MiniSuper POS implementa los conceptos fundamentales de diseño de bases de datos relacionales. La estructura normalizada, el uso de integridad referencial y la automatización mediante triggers demuestran aplicación de principios académicos en un contexto funcional.

El proyecto está actualmente en fase 2 de implementación, con la base de datos operacional y la API REST en funcionamiento. Las fases subsecuentes se enfocarán en completar la funcionalidad CRUD y desarrollar la interfaz de usuario.

---

## 13. Anexos

### 13.1 Diagrama Entidad-Relación

![Diagrama E-R](assets/imagenes/Diagrama%20E-R.png)

### 13.2 Diagrama Entidad Relación Mejorado

![Diagrama Entidad Relacion Mejorado (EER)](assets/imagenes/Diagrama%20Entidad%20Relacion%20Mejorado%20%28EER%29.png)

### 13.3 Esquema de Base de Datos

![Esquema](assets/imagenes/Esquema.jpeg)

---

**Autores:** great-noe, elunboundfiremail
**Fecha:** 2026
**Asignatura:** Base de Datos II
