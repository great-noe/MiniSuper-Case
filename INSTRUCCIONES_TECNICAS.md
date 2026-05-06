# 📋 INSTRUCCIONES TÉCNICAS - MiniSuper POS

## 1. Configuración Inicial del Proyecto

### 1.1 Prerequisitos
- Python 3.9 o superior
- PostgreSQL 12 o superior
- Git
- Postman (para testing de API)

### 1.2 Instalación de Dependencias

```bash
# Navegar a la carpeta backend
cd backend

# Activar entorno virtual (Windows)
.\.venv\Scripts\activate

# O (Linux/Mac)
source .venv/bin/activate

# Instalar dependencias
pip install -r requirements.txt
```

### 1.3 Configuración de Base de Datos

```bash
# Crear la base de datos
createdb minisuper -U postgres -h localhost

# Desde pgAdmin o CLI, ejecutar el schema
# Abrir el archivo: backend/sql/schema.sql
# Y ejecutarlo en pgAdmin o desde terminal:

psql -U postgres -d minisuper -f backend/sql/schema.sql

# Poblar datos iniciales
psql -U postgres -d minisuper -f backend/sql/seed_30_datos.sql
```

### 1.4 Configurar Variables de Entorno

Crear archivo `.env` en `backend/` basado en `.env.example`:

```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=minisuper
DB_USER=postgres
DB_PASSWORD=tu_contraseña_aqui
FLASK_ENV=development
FLASK_DEBUG=False
SECRET_KEY=tu_clave_secreta_aqui
```

---

## 2. Estructura de Carpetas

```
backend/
├── sql/
│   ├── schema.sql           # DDL - Creación de tablas, índices, triggers
│   ├── seed_30_datos.sql    # DML - Datos iniciales para poblado
│   └── README.md            # Documentación SQL
│
├── aplicacion.py            # API Flask - Punto de entrada
├── requirements.txt         # Dependencias Python
├── .env                      # Variables de entorno (NO versionado)
├── .env.example             # Plantilla de variables de entorno
├── .gitignore               # Archivos a ignorar en Git
├── README.md                # Documentación backend
└── test_db.py               # Script de prueba de conexión
```

---

## 3. Estructura de Base de Datos

### 3.1 Tablas Principales

| Tabla | Descripción | Registros |
|-------|-------------|-----------|
| `roles` | Roles de usuario (admin, vendedor, gerente) | 3 |
| `usuarios` | Usuarios del sistema | 3 |
| `categorias` | Categorías de productos | 10 |
| `productos` | Catálogo de productos con precios | 10 |
| `clientes` | Base de clientes | 10 |
| `ventas` | Cabecera de transacciones de venta | 10 |
| `detalle_ventas` | Desglose de ítems por venta | 20 |

### 3.2 Tipos de Datos Clave

```sql
-- Identificadores
id_* : INTEGER SERIAL (auto-incremento)

-- Moneda (Bolivianos)
precio_costo : numeric(10,2)      -- Costo de compra
precio_venta : numeric(10,2)      -- Precio de venta
total : numeric(10,2)             -- Total de venta
subtotal : numeric(10,2)          -- Subtotal sin impuesto

-- Documento de identidad
ci_nit : VARCHAR(20) UNIQUE       -- Cédula de Identidad o NIT

-- Estados
estado : VARCHAR(20) CHECK        -- 'activo' o 'inactivo'
metodo_pago : VARCHAR(50)         -- 'efectivo', 'tarjeta', 'transferencia', etc.
```

### 3.3 Constrains Principales

```sql
-- Validación de precios
CHECK (precio_costo > 0)
CHECK (precio_venta > precio_costo)

-- Validación de stock
CHECK (stock_actual >= 0)
CHECK (stock_minimo >= 0)

-- Unicidad
UNIQUE (cedula_nit)               -- Un cliente por CI
UNIQUE (sku)                      -- Un código por producto

-- Integridad referencial
FOREIGN KEY (id_categoria) REFERENCES categorias
FOREIGN KEY (id_cliente) REFERENCES clientes
FOREIGN KEY (id_producto) REFERENCES productos
```

---

## 4. Endpoints API

### 4.1 Base URL
```
http://localhost:5000/api
```

### 4.2 Endpoints Disponibles

#### GET - Lectura de datos

```
GET /api/categorias
  Descripción: Obtiene todas las categorías
  Respuesta: { "success": true, "data": [...], "count": N }

GET /api/productos
  Descripción: Obtiene todos los productos activos (hasta 10)
  Respuesta: { "success": true, "data": [...], "count": N }
  Formato: { id_producto, nombre, precio_venta, stock_actual, categoria_nombre }

GET /api/clientes
  Descripción: Obtiene todos los clientes
  Respuesta: { "success": true, "data": [...], "count": N }

GET /api/ventas
  Descripción: Obtiene todas las ventas con detalles
  Respuesta: { "success": true, "data": [...], "count": N }
```

#### PUT - Actualizar datos

```
PUT /api/productos/<id>
  Descripción: Actualizar precio de venta de un producto
  Body JSON:
    {
      "precio_venta": 19.50
    }
  Respuesta: { "success": true, "data": { ... } }
  
  Validación:
    - precio_venta debe ser mayor que precio_costo
    - precio_venta debe ser numeric(10,2)
    - Solo se pueden actualizar productos activos
```

---

## 5. Formato de Respuestas API

### 5.1 Respuesta Exitosa

```json
{
  "success": true,
  "data": [
    {
      "id_producto": 31,
      "nombre": "Arroz Premium 1kg",
      "precio_venta": "11.94",
      "stock_actual": 100,
      "categoria_nombre": "Abarrotes"
    }
  ],
  "count": 1
}
```

### 5.2 Respuesta de Error

```json
{
  "success": false,
  "error": "Descripción del error",
  "code": "ERROR_CODE"
}
```

### 5.3 Formato de Precios

- **En Base de Datos:** `numeric(10,2)` (valores reales: 11.94, 8.92)
- **En API JSON:** STRING con 2 decimales (texto: "11.94")
- **En JavaScript:** `parseFloat("11.94")` = 11.94 (reconvertir a número si es necesario)

**Nota:** Los precios se devuelven como strings en JSON para garantizar siempre 2 decimales visibles.

---

## 6. Testing con Postman

### 6.1 Configuración

1. Abrir Postman
2. Importar collection: `Postman_Collection_MiniSuper.json`
3. Crear environment con:
   ```
   base_url: http://localhost:5000/api
   ```

### 6.2 Requests de Prueba

```
### GET productos
GET {{base_url}}/productos

### GET categorias
GET {{base_url}}/categorias

### GET clientes
GET {{base_url}}/clientes

### PUT actualizar precio (ejemplo)
PUT {{base_url}}/productos/31
Content-Type: application/json

{
  "precio_venta": 19.50
}
```

---

## 7. Ejecutar la API

### 7.1 Modo Desarrollo

```bash
# Desde carpeta backend (con .venv activado)
python aplicacion.py
```

**Output esperado:**
```
============================================================
🚀 MiniSuper API - Conexión Real a PostgreSQL
============================================================
Database: minisuper
Host: localhost:5432
User: postgres
============================================================
 * Running on http://127.0.0.1:5000
```

### 7.2 Verificar Conexión

```bash
# Desde otra terminal, probar endpoint
curl http://localhost:5000/api/productos

# O en Postman:
GET http://localhost:5000/api/productos
```

---

## 8. Comandos Útiles

### 8.1 PostgreSQL

```bash
# Conectar a la BD
psql -U postgres -d minisuper

# Ver todas las tablas
\dt

# Ver estructura de tabla
\d productos

# Ver datos
SELECT * FROM productos LIMIT 5;

# Crear respaldo
pg_dump -U postgres -d minisuper > backup_minisuper.sql

# Restaurar respaldo
psql -U postgres -d minisuper < backup_minisuper.sql
```

### 8.2 Git

```bash
# Ver estado
git status

# Agregar cambios
git add .

# Commit
git commit -m "feat: descripción del cambio"

# Push
git push origin main

# Ver historial
git log --oneline
```

### 8.3 Python

```bash
# Listar paquetes instalados
pip list

# Actualizar paquete
pip install --upgrade nombre_paquete

# Exportar dependencias
pip freeze > requirements.txt

# Crear entorno virtual
python -m venv .venv
```

---

## 9. Solución de Problemas

### 9.1 Error: "relation 'productos' does not exist"

**Causa:** El schema.sql no fue ejecutado
**Solución:**
```bash
psql -U postgres -d minisuper -f backend/sql/schema.sql
```

### 9.2 Error: "FATAL: password authentication failed"

**Causa:** Credenciales incorrectas en .env
**Solución:**
1. Verificar contraseña de PostgreSQL
2. Actualizar en `.env`
3. Reiniciar API

### 9.3 Error: "Connection refused" en aplicacion.py

**Causa:** PostgreSQL no está corriendo
**Solución:**
```bash
# Windows: Iniciar servicio PostgreSQL
# Hacer clic en Services → PostgreSQL → Start

# Linux:
sudo systemctl start postgresql

# Mac:
brew services start postgresql
```

### 9.4 Precios mostrando 1 decimal en vez de 2

**Causa:** JSON serialization en Python
**Solución:** Ya está implementada en `aplicacion.py` - Los precios se formatean como strings

---

## 10. Seguridad

### 10.1 Variables Sensibles

**Nunca versionear en Git:**
- `.env` (credenciales)
- `.venv/` (entorno virtual)
- `__pycache__/`
- `*.pyc`

**Verificar .gitignore:**
```
.env
.env.local
.venv/
*.pyc
__pycache__/
*.db
```

### 10.2 Contraseña Base de Datos

Cambiar la contraseña default de PostgreSQL:
```bash
psql -U postgres
ALTER USER postgres WITH PASSWORD 'nueva_contraseña_segura';
```

---

## 11. Próximos Pasos

1. **Endpoints POST:** Crear nuevos productos, clientes, ventas
2. **Endpoints DELETE:** Implementar eliminación lógica (marcar como inactivo)
3. **Autenticación JWT:** Proteger endpoints con token
4. **Validación:** Agregar schemas de validación
5. **Frontend:** Conectar interfaz HTML/CSS/JS con API

---

## 12. Referencias

- **PostgreSQL Docs:** https://www.postgresql.org/docs/
- **Flask Docs:** https://flask.palletsprojects.com/
- **Postman Docs:** https://learning.postman.com/
- **SQL Best Practices:** https://use-the-index-luke.com/

---

**Última actualización:** Fase 2 completada
**Versión:** 2.0
**Estado:** API real funcionando con PostgreSQL
