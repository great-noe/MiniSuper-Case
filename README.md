# Documento de Proyecto - Base de Datos II

## Universidad Privada Domingo Savio
### Sub-Sede La Paz
### Facultad de Ingeniería - Carrera de Ingeniería de Sistemas

---

## DATOS DEL PROYECTO

| Campo | Información |
|-------|-------------|
| **Módulo** | Base de Datos II |
| **Docente** | Ing. Limber Maldonado Castillo |
| **Período** | Mayo de 2026 |
| **Estudiantes** | Noel David Limachi Abelo<br>Zubieta Mendoza Owen Jonathan |
| **Tecnologías** | PostgreSQL 12+, Python 3.9+ (Flask) |

---

## 📋 ESTRUCTURA DEL DOCUMENTO DE PROYECTO

### 1. PORTADA

<div align="center">

# UNIVERSIDAD PRIVADA DOMINGO SAVIO  
## SUB-SEDE LA PAZ  

<br>

## FACULTAD DE INGENIERÍA  
### CARRERA DE INGENIERÍA DE SISTEMAS  

<br>

### BASE DE DATOS II  

<br>
<img width="470" height="412" alt="image" src="assets/imagenes/upds_logo.png" />

---

## **Sistema de Gestión de Ventas (MiniSuper POS)**  
### Control de transacciones, inventario y facturación  
### Caso: Minimarket  

---

</div>

<br>

**ESTUDIANTES:**  
- Noel David Limachi Abelo  
- Zubieta Mendoza Owen Jonathan  

<br>

**DOCENTE:**  
- Ing. Limber Maldonado Castillo  

<br>

<div align="center">

**La Paz - Bolivia**  
**Mayo de 2026**

</div>

---

### 2. ÍNDICE GENERAL

## TABLA DE CONTENIDO

1. [Introducción](#1-introducción)  
   - [Contexto General](#11-contexto-general)  
   - [Problemática](#12-problemática)  
   - [Antecedentes](#13-antecedentes)  
   - [Justificación](#14-justificación)  
   - [Alcance y Limitaciones](#15-alcance-y-limitaciones)  

2. [Objetivos](#2-objetivos)  
   - [Objetivo General](#21-objetivo-general)  
   - [Objetivos Específicos](#22-objetivos-específicos)  

3. [Marco Teórico](#3-marco-teórico)  
   - [PostgreSQL](#31-postgresql)  
   - [Python y Flask](#32-python-y-flask)  
   - [Desarrollo Frontend](#33-desarrollo-frontend)  

4. [Análisis del Sistema](#4-análisis-del-sistema)  
   - [Requerimientos Funcionales](#41-requerimientos-funcionales)  
   - [Requerimientos No Funcionales](#42-requerimientos-no-funcionales)  
   - [Actores del Sistema](#43-actores-del-sistema)  
   - [Reglas de Negocio](#44-reglas-de-negocio)  

5. [Diseño del Sistema](#5-diseño-del-sistema)  
   - [Arquitectura del Sistema](#51-arquitectura-del-sistema)  
   - [Stack Tecnológico](#52-stack-tecnológico)  
   - [Modelo de Base de Datos](#53-modelo-de-base-de-datos)  

6. [Implementación](#6-implementación)  
   - [Requisitos de Instalación](#61-requisitos-de-instalación)  
   - [Estructura del Proyecto](#62-estructura-del-proyecto)  
   - [Configuración de Base de Datos](#63-configuración-de-base-de-datos)  
   - [Endpoints Principales](#64-endpoints-principales)  

7. [Pruebas](#7-pruebas)  
   - [Testing con Postman](#71-testing-con-postman)  

8. [Conclusiones y Recomendaciones](#8-conclusiones-y-recomendaciones)  
   - [Conclusiones](#81-conclusiones)  
   - [Recomendaciones](#82-recomendaciones)  

9. [Bibliografía](#9-bibliografía)  

10. [Anexos](#10-anexos)  
   - [Esquemas y Diagramas](#101-esquemas-y-diagramas)  

---
## 1. INTRODUCCIÓN

El presente documento describe el diseño e implementación de un sistema de gestión de ventas para comercios de pequeña escala (minimarket). El sistema implementa una base de datos relacional en PostgreSQL que permite registrar transacciones de venta, mantener inventario, gestionar clientes y generar reportes operativos.

### 1.1. Contexto General
Los pequeños comercios, como los minimarkets, requieren soluciones tecnológicas para administrar sus ventas diarias de manera eficiente y reducir errores en sus transacciones. Un sistema de punto de venta (POS) es esencial para la gestión del inventario y la agilidad en la facturación y el seguimiento de los clientes.

### 1.2. Problemática
El control manual o a través de herramientas no especializadas en las ventas genera pérdida de información, descontrol en el inventario, tiempos de atención lentos y dificultar a la hora de tener un reporte de análisis de ingresos. Los minimarkets necesitan sistemas unificados que garanticen la integridad de la información y transacciones rápidas.

### 1.3. Antecedentes
El proyecto toma inspiración de sistemas de gestión comerciales estándar, específicamente del repositorio base django_point_of_sale. El objetivo central fue adaptar esas funcionalidades comunes (gestión de clientes, productos y ventas) a un modelo académico riguroso que aplique las buenas prácticas de normalización, el manejo eficiente del SQL y la construcción de un API backend ligero.

### 1.4. Justificación

#### 1.4.1. Justificación Técnica
El tema de un sistema POS es pertinente porque incorpora relaciones complejas (uno a muchos, muchos a muchos) que demuestran competencias de modelado de bases de datos. Requiere de normalización cuidadosa para evitar redundancia de la información y permite aplicar restricciones, triggers y vistas en el motor de base de datos de PostgreSQL para asegurar la integridad de datos a bajo nivel.

#### 1.4.2. Justificación Práctica
El desarrollo de esta solución no solo cumple con los objetivos académicos de aprendizaje, sino que representa un caso de uso real, frecuente en el entorno comercial, proveyendo a los comercios de pequeña escala de una herramienta robusta.

### 1.5. Alcance y Limitaciones

#### Alcance del Proyecto
El sistema controlará:
- Gestión de categorías de producto y catálogo de productos (alta, baja, modificación, consulta).
- Gestión de clientes.
- Registro de ventas con múltiples ítems, incluyendo cálculo automático de totales e impuestos.
- Control de inventario.
- Consultas de análisis básico por fecha, cliente y producto a través de una API REST.

#### Limitaciones
- Múltiples sucursales.
- Compras a proveedores.
- Devoluciones y notas de crédito.
- Facturación electrónica y auditoría completa.

---

## 2. OBJETIVOS

### 2.1. Objetivo General
Diseñar e implementar una base de datos relacional funcional en PostgreSQL para un sistema de punto de venta (POS) de un minimarket, acompañado de una API REST, aplicando conceptos de modelado entidad-relación, normalización e integridad referencial.

### 2.2. Objetivos Específicos
- Diseñar un modelo entidad-relación normalizado hasta tercera forma normal (3FN).
- Implementar la estructura lógica mediante DDL en PostgreSQL y automatizar operaciones mediante triggers.
- Establecer integridad referencial y validación de datos mediante constraints.
- Proporcionar una interfaz API REST en Python y Flask para el acceso y manipulación de los datos.

---

## 3. MARCO TEÓRICO

### 3.1. PostgreSQL
PostgreSQL es un potente sistema de base de datos relacional de código abierto que goza de una sólida reputación por su confiabilidad y robustez. Permite el manejo de transacciones complejas, triggers y procedimientos almacenados que resultan clave para la lógica de integridad y automatización en un sistema de ventas.

### 3.2. Python y Flask
Python es un lenguaje de programación de alto nivel y propósito general. Flask es un micro-framework web de Python que se caracteriza por ser ligero y modular, permitiendo un rápido desarrollo de APIs REST de manera flexible, ideal para interconectar de forma directa nuestra base de datos con futuras interfaces cliente.

### 3.3. Desarrollo Frontend
Aunque el foco de la capa de datos es relacional, el proyecto provee interfaces a ser consumidas por un frontend elaborado con HTML, CSS y JavaScript modernos, que facilitará la experiencia visual e interacción del usuario final.

---

## 4. ANÁLISIS DEL SISTEMA

### 4.1. Requerimientos Funcionales

| ID     | Requerimiento                              | Descripción |
|--------|--------------------------------------------|-------------|
| **RF1** | Gestión de Clientes                     | Permitir crear, actualizar y consultar clientes en la base de datos. |
| **RF2** | Gestión de Productos y Categorías       | Permitir crear, actualizar y consultar productos y sus respectivas categorías. |
| **RF3** | Registro de Ventas                      | Registrar ventas con uno o más ítems y mantener historiales. |
| **RF4** | Cálculo Automático                      | Calcular automáticamente subtotales, impuestos y totales. |
| **RF5** | Historial de Operaciones                | Consultar el historial de ventas por cliente y período, además de mantener registro de cambios de precios y costos. |

### 4.2. Requerimientos No Funcionales

| ID      | Requerimiento                          | Descripción |
|---------|----------------------------------------|-------------|
| **RNF1** | Motor de Base de Datos             | Uso de PostgreSQL 12 o superior. |
| **RNF2** | Normalización de Datos             | Modelo normalizado hasta 3FN para evitar anomalías y redundancias. |
| **RNF3** | Integridad y Restricciones         | Integridad referencial (foreign keys) y validación de datos (constraints). |
| **RNF4** | Automatización                     | Uso de triggers en base de datos. |
| **RNF5** | Arquitectura                       | Exposición de funcionalidades mediante API REST. |

### 4.3. Actores del Sistema
| Actor | Descripción |
|-------|-------------|
| **Administrador** | Administra roles, usuarios, categorías, catálogo, clientes y métricas totales del negocio. |
| **Vendedor / Cajero** | Encargado del registro de las transacciones de ventas y consultas de inventario. |
| **Gerente** | Consulta de reportes y análisis general del minimarket. |

### 4.4. Reglas de Negocio
1. Toda venta requiere al menos un detalle de ítem.
2. Cada ítem debe estar vinculado a un producto existente.
3. El total de venta es la suma de ítems más impuesto.
4. Los productos inactivos no pueden participar en nuevas ventas.
5. La eliminación de datos es lógica (marcado como inactivo), no física.
6. Los precios se registran con precisión de dos decimales en Bolivianos (Bs).
7. El costo de un producto debe ser menor que su precio de venta.

---

## 5. DISEÑO DEL SISTEMA

### 5.1. Arquitectura del Sistema
El sistema se divide en capas bajo un enfoque monolítico con una API backend y base de datos relacional. 
- La capa de persistencia se encarga de la estructura DDL y datos en PostgreSQL.
- La API desarrollada en Python con Flask expone endpoints CRUD mediante los cuales los datos son insertados y consultados por la vista.

### 5.2. Stack Tecnológico
**Base de Datos:**
- PostgreSQL 12+

**Backend:**
- Python 3.9+
- Flask

**Frontend (Siguiente Fase):**
- HTML, CSS y JavaScript

### 5.3. Modelo de Base de Datos
El sistema se articula en un modelo relacional de 7 tablas interconectadas:

| Entidad | Descripción | Relaciones Principales |
|---------|-------------|------------------------|
| **roles** | Roles de acceso | |
| **usuarios** | Cuentas del sistema | 1 a N con ventas |
| **categorias** | Categorías de productos | 1 a N con productos |
| **productos** | Catálogo con precios | 1 a N con detalle_ventas |
| **clientes** | Base de clientes | 1 a N con ventas |
| **ventas** | Cabecera de transacciones | 1 a N con detalle_ventas |
| **detalle_ventas** | Ítems de la transacción | |

La normalización aplicada al diseño guarda el precio de venta en detalle_ventas, garantizando trazabilidad ante futuros cambios de precio en el catálogo.

---

## 6. IMPLEMENTACIÓN

### 6.1. Requisitos de Instalación
- Python 3.9 o superior
- PostgreSQL 12 o superior
- Git
- Postman (opcional para pruebas de API)

### 6.2. Estructura del Proyecto
```text
backend/
├── sql/
│   ├── schema.sql           # DDL - Creación de tablas, índices, triggers
│   ├── seed_30_datos.sql    # DML - Datos iniciales para poblado
│   └── README.md            # Documentación SQL
│
├── aplicacion.py            # API Flask - Punto de entrada
├── requirements.txt         # Dependencias Python
├── .env                      # Variables de entorno
├── .env.example             # Plantilla de variables de entorno
├── .gitignore               # Archivos a ignorar en Git
└── test_db.py               # Script de prueba de conexión
```

### 6.3. Configuración de Base de Datos
Para crear y poblar la base de datos de manera local:

```bash
# Crear base de datos
createdb minisuper -U postgres -h localhost

# Ejecutar el schema
psql -U postgres -d minisuper -f backend/sql/schema.sql

# Poblar datos iniciales
psql -U postgres -d minisuper -f backend/sql/seed_30_datos.sql
```

Para la ejecución del proyecto, definir un archivo `.env` basado en `.env.example` dentro del directorio `backend`.

### 6.4. Endpoints Principales
- `GET /api/categorias`: Obtiene listado de categorías.
- `GET /api/productos`: Lista los productos activos.
- `GET /api/clientes`: Muestra información de los clientes registrados.
- `GET /api/ventas`: Entrega información de las ventas y su detalle.
- `PUT /api/productos/<id>`: Actualiza atributos (como el precio) de un producto.

---

## 7. PRUEBAS

### 7.1. Testing con Postman
Se ha configurado una colección `Postman_Collection_MiniSuper.json` para agilizar las pruebas y validaciones sobre la API. Permitiendo comprobar respuestas correctas en los siguientes casos:
- Respuestas exitosas del servidor para métodos de lectura (GET).
- Comprobación de formateo correcto de respuestas JSON y números con dos decimales en strings.
- Comprobación de validación de reglas de negocio al intentar cambiar el `precio_venta` (PUT).

---

## 8. CONCLUSIONES Y RECOMENDACIONES

### 8.1. Conclusiones
El sistema MiniSuper POS implementa los conceptos fundamentales de diseño de bases de datos relacionales en PostgreSQL. La estructura normalizada en tercera forma normal, el uso de integridad referencial y la automatización mediante triggers demuestran una correcta aplicación de principios teóricos en un caso de uso práctico funcional y escalable.

### 8.2. Recomendaciones
- Ampliar el manejo de autenticación e incorporar JSON Web Tokens (JWT) en el backend para resguardar todos los endpoints.
- Desarrollar una interfaz frontend consumiendo la API REST del proyecto.
- Ejecutar respaldos automatizados continuos de la base de datos debido a la sensibilidad y valor contable que representan las transacciones y cierres de caja en un minimarket.

---

## 9. BIBLIOGRAFÍA

- betofleitass. (s.f.). *django_point_of_sale*. GitHub. https://github.com/betofleitass/django_point_of_sale
- PostgreSQL Global Development Group. (2024). *PostgreSQL Documentation*. https://www.postgresql.org/docs/
- Sommerville, I. (2016). *Software Engineering* (10th ed.). Pearson Education.
- Neon PostgreSQL Tutorial. (s.f.). *PostgreSQL Tutorial*. https://neon.com/postgresql/tutorial
- Psycopg2 - Python Package Index. (s.f.). *psycopg2*. https://pypi.org/project/psycopg2/

---

## 10. ANEXOS

### 10.1. Esquemas y Diagramas

#### Diagrama Entidad-Relación
![Diagrama E-R](assets/imagenes/Diagrama%20E-R.png)

#### Diagrama Entidad Relación Mejorado
![Diagrama Entidad Relacion Mejorado (EER)](assets/imagenes/Diagrama%20Entidad%20Relacion%20Mejorado%20%28EER%29.png)

#### Esquema de Base de Datos
![Esquema](assets/imagenes/Esquema.jpeg)

---

**Autores:** Noel David Limachi Abelo, Zubieta Mendoza Owen Jonathan  
**Asignatura:** Base de Datos II  
