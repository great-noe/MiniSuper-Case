# MiniSuper-Case Backend API

## 📋 Descripción

Backend API para Sistema POS (Point of Sale) de Minimarket construido con **Python + Flask** y **PostgreSQL**.

Implementa **Arquitectura Limpia** (Clean Architecture) con capas:
- **Domain**: Entidades de negocio
- **Application**: Lógica de casos de uso
- **Infrastructure**: Implementación técnica (BD, configuración)
- **Presentation**: API REST

---

## 🛠️ Tecnología

| Componente | Tecnología |
|-----------|-----------|
| Framework | Flask 2.3+ |
| Base de Datos | PostgreSQL 12+ |
| ORM | SQLAlchemy |
| Autenticación | JWT (Flask-JWT-Extended) |
| Seguridad | bcrypt |
| Validación | Marshmallow |

---

## 📁 Estructura del Proyecto

```
backend/
├── sql/                        # SQL Schema y migraciones
│   ├── schema.sql             # DDL (crear tablas)
│   ├── migrations/            # Versionado de cambios
│   └── seeds/                 # Datos iniciales
│
├── app/
│   ├── domain/                # Modelos de dominio
│   │   ├── models.py
│   │   └── entities.py
│   │
│   ├── application/           # Lógica de aplicación
│   │   ├── services/          # Servicios (casos de uso)
│   │   ├── dto/               # Data Transfer Objects
│   │   └── exceptions.py
│   │
│   ├── infrastructure/        # Implementación técnica
│   │   ├── database/          # ORM, conexiones
│   │   ├── config/            # Configuración
│   │   └── external/          # APIs externas
│   │
│   └── presentation/          # API REST
│       ├── routes/            # Endpoints
│       └── middleware/        # Middleware
│
├── requirements.txt           # Dependencias Python
├── main.py                    # Punto de entrada
├── .env.example              # Variables de entorno
└── README.md                 # Este archivo
```

---

## 🚀 Instalación

### 1. Clonar repositorio
```bash
git clone https://github.com/great-noe/MiniSuper-Case.git
cd MiniSuper-Backend/backend
```

### 2. Crear entorno virtual
```bash
python -m venv venv
source venv/bin/activate    # En Linux/Mac
# o
venv\Scripts\activate       # En Windows
```

### 3. Instalar dependencias
```bash
pip install -r requirements.txt
```

### 4. Configurar variables de entorno
```bash
cp .env.example .env
# Editar .env con tu configuración de BD
```

### 5. Crear base de datos PostgreSQL
```bash
# Conectarse a PostgreSQL
psql -U postgres

# Crear BD
CREATE DATABASE minisuper_db;

# Aplicar schema
psql -U postgres -d minisuper_db -f sql/schema.sql
```

### 6. Ejecutar servidor
```bash
python main.py
# El API estará en http://localhost:5000
```

---

## 🔐 Autenticación

La API usa **JWT (JSON Web Tokens)** para autenticación.

### Login
```bash
POST /api/auth/login
Content-Type: application/json

{
  "usuario": "admin",
  "contraseña": "123456"
}

# Response:
{
  "access_token": "eyJhbGc...",
  "usuario": "admin",
  "rol": "admin"
}
```

### Usar token en requests
```bash
GET /api/productos
Authorization: Bearer eyJhbGc...
```

---

## 📚 Endpoints API

### Autenticación
- `POST /api/auth/login` - Iniciar sesión
- `POST /api/auth/logout` - Cerrar sesión

### Productos
- `GET /api/productos` - Listar productos
- `POST /api/productos` - Crear producto
- `PUT /api/productos/<id>` - Actualizar producto
- `DELETE /api/productos/<id>` - Eliminar producto

### Clientes
- `GET /api/clientes` - Listar clientes
- `POST /api/clientes` - Crear cliente
- `PUT /api/clientes/<id>` - Actualizar cliente

### Ventas
- `GET /api/ventas` - Listar ventas
- `POST /api/ventas` - Crear venta
- `GET /api/ventas/<id>` - Detalles de venta

---

## 🗄️ Base de Datos

### Tablas principales
- **usuarios** - Usuarios del sistema (login)
- **roles** - Roles de acceso (admin, vendedor)
- **clientes** - Clientes del minimarket
- **categorias** - Categorías de productos
- **productos** - Inventario
- **ventas** - Cabecera de transacciones
- **detalle_ventas** - Items de cada venta

### Vistas
- `v_ventas_detalladas` - Ventas con cliente y vendedor
- `v_productos_stock_critico` - Productos bajo stock
- `v_productos_desempeno` - Análisis de ventas por producto

---

## 📝 Notas de Desarrollo

- **Mañana (día 2)**: Poblar BD con datos iniciales (seeds.sql)
- **Miércoles (día 3)**: Completar endpoints CRUD
- **Jueves (día 4)**: Integración con frontend

---

## 🔗 Referencias

- Documentación Flask: https://flask.palletsprojects.com/
- SQLAlchemy: https://www.sqlalchemy.org/
- JWT: https://flask-jwt-extended.readthedocs.io/
- Clean Architecture: https://blog.cleancoder.com/

---

**Última actualización**: 3 mayo 2026
