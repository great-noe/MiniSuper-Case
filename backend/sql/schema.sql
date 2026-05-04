-- ==========================================
-- SCHEMA: MiniSuper-Case POS System
-- Base de Datos para Sistema de Ventas
-- Arquitectura: Limpia
-- DB: PostgreSQL 12+
-- ==========================================

-- ==========================================
-- 1. TABLAS DE AUTENTICACION Y AUTORIZACIÓN
-- ==========================================

-- Tabla: Roles
CREATE TABLE IF NOT EXISTS roles (
    id_rol SERIAL PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL,
    descripcion TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: Usuarios (Login)
CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario SERIAL PRIMARY KEY,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    contraseña VARCHAR(255) NOT NULL, -- Hash bcrypt
    nombre_completo VARCHAR(150) NOT NULL,
    id_rol INTEGER NOT NULL,
    estado VARCHAR(20) DEFAULT 'activo', -- activo, inactivo
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_ultima_sesion TIMESTAMP,
    CONSTRAINT fk_usuarios_rol FOREIGN KEY (id_rol) REFERENCES roles(id_rol) ON DELETE RESTRICT
);

-- ==========================================
-- 2. TABLAS DE MAESTROS (Catálogos)
-- ==========================================

-- Tabla: Categorías
CREATE TABLE IF NOT EXISTS categorias (
    id_categoria SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    descripcion TEXT,
    estado VARCHAR(20) DEFAULT 'activo', -- activo, inactivo
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: Productos
CREATE TABLE IF NOT EXISTS productos (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    sku VARCHAR(50) UNIQUE,
    precio_costo NUMERIC(10, 2) NOT NULL,
    precio_venta NUMERIC(10, 2) NOT NULL,
    stock_actual INTEGER DEFAULT 0,
    stock_minimo INTEGER DEFAULT 5,
    id_categoria INTEGER NOT NULL,
    estado VARCHAR(20) DEFAULT 'activo', -- activo, inactivo
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_productos_categoria FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria) ON DELETE RESTRICT,
    CONSTRAINT ck_precio_valido CHECK (precio_venta > precio_costo)
);

-- Tabla: Clientes
CREATE TABLE IF NOT EXISTS clientes (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    apellido VARCHAR(150),
    email VARCHAR(100),
    telefono VARCHAR(20),
    direccion TEXT,
    ciudad VARCHAR(100),
    cedula_ruc VARCHAR(20) UNIQUE,
    estado VARCHAR(20) DEFAULT 'activo', -- activo, inactivo
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_ultima_compra TIMESTAMP,
    total_compras NUMERIC(12, 2) DEFAULT 0.00
);

-- ==========================================
-- 3. TABLAS DE TRANSACCIONES (Ventas)
-- ==========================================

-- Tabla: Ventas (Cabecera de transacción)
CREATE TABLE IF NOT EXISTS ventas (
    id_venta SERIAL PRIMARY KEY,
    numero_factura VARCHAR(50) UNIQUE NOT NULL,
    id_cliente INTEGER NOT NULL,
    id_usuario INTEGER NOT NULL,
    fecha_venta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    subtotal NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    impuesto_porcentaje NUMERIC(5, 2) DEFAULT 12.00, -- IVA estándar
    impuesto_monto NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    total NUMERIC(12, 2) NOT NULL,
    monto_pagado NUMERIC(12, 2) NOT NULL,
    cambio NUMERIC(12, 2) DEFAULT 0.00,
    metodo_pago VARCHAR(50) DEFAULT 'efectivo', -- efectivo, tarjeta, transferencia
    estado VARCHAR(20) DEFAULT 'completada', -- completada, anulada, pendiente
    notas TEXT,
    CONSTRAINT fk_ventas_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE RESTRICT,
    CONSTRAINT fk_ventas_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE RESTRICT,
    CONSTRAINT ck_venta_total CHECK (total > 0),
    CONSTRAINT ck_venta_pago CHECK (monto_pagado >= total)
);

-- Tabla: Detalle de Ventas (Items de cada venta)
CREATE TABLE IF NOT EXISTS detalle_ventas (
    id_detalle SERIAL PRIMARY KEY,
    id_venta INTEGER NOT NULL,
    id_producto INTEGER NOT NULL,
    cantidad INTEGER NOT NULL,
    precio_unitario NUMERIC(10, 2) NOT NULL,
    descuento_porcentaje NUMERIC(5, 2) DEFAULT 0.00,
    descuento_monto NUMERIC(10, 2) DEFAULT 0.00,
    subtotal_item NUMERIC(12, 2) NOT NULL,
    CONSTRAINT fk_detalle_venta FOREIGN KEY (id_venta) REFERENCES ventas(id_venta) ON DELETE CASCADE,
    CONSTRAINT fk_detalle_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE RESTRICT,
    CONSTRAINT ck_cantidad_positiva CHECK (cantidad > 0),
    CONSTRAINT ck_precio_positivo CHECK (precio_unitario > 0)
);

-- ==========================================
-- 4. ÍNDICES PARA OPTIMIZACIÓN
-- ==========================================

CREATE INDEX idx_usuarios_rol ON usuarios(id_rol);
CREATE INDEX idx_usuarios_estado ON usuarios(estado);
CREATE INDEX idx_productos_categoria ON productos(id_categoria);
CREATE INDEX idx_productos_estado ON productos(estado);
CREATE INDEX idx_clientes_estado ON clientes(estado);
CREATE INDEX idx_ventas_cliente ON ventas(id_cliente);
CREATE INDEX idx_ventas_usuario ON ventas(id_usuario);
CREATE INDEX idx_ventas_fecha ON ventas(fecha_venta);
CREATE INDEX idx_ventas_estado ON ventas(estado);
CREATE INDEX idx_detalle_venta ON detalle_ventas(id_venta);
CREATE INDEX idx_detalle_producto ON detalle_ventas(id_producto);

-- ==========================================
-- 5. VISTAS ANALÍTICAS
-- ==========================================

-- Vista: Ventas con Detalles Completos
CREATE OR REPLACE VIEW v_ventas_detalladas AS
SELECT 
    v.id_venta,
    v.numero_factura,
    v.fecha_venta,
    CONCAT(c.nombre, ' ', COALESCE(c.apellido, '')) AS cliente,
    CONCAT(u.nombre_completo) AS vendedor,
    v.subtotal,
    v.impuesto_monto,
    v.total,
    v.metodo_pago,
    v.estado,
    COUNT(dv.id_detalle) AS cantidad_items
FROM ventas v
JOIN clientes c ON v.id_cliente = c.id_cliente
JOIN usuarios u ON v.id_usuario = u.id_usuario
LEFT JOIN detalle_ventas dv ON v.id_venta = dv.id_venta
GROUP BY v.id_venta, v.numero_factura, v.fecha_venta, c.nombre, c.apellido, u.nombre_completo, v.subtotal, v.impuesto_monto, v.total, v.metodo_pago, v.estado;

-- Vista: Productos con Stock Crítico
CREATE OR REPLACE VIEW v_productos_stock_critico AS
SELECT 
    id_producto,
    nombre,
    stock_actual,
    stock_minimo,
    (stock_minimo - stock_actual) AS deficit,
    estado
FROM productos
WHERE estado = 'activo' AND stock_actual <= stock_minimo
ORDER BY deficit DESC;

-- Vista: Desempeño de Productos
CREATE OR REPLACE VIEW v_productos_desempeno AS
SELECT 
    p.id_producto,
    p.nombre,
    COUNT(DISTINCT dv.id_venta) AS numero_ventas,
    SUM(dv.cantidad) AS cantidad_vendida,
    SUM(dv.subtotal_item) AS ingresos_totales,
    AVG(dv.precio_unitario) AS precio_promedio,
    p.estado
FROM productos p
LEFT JOIN detalle_ventas dv ON p.id_producto = dv.id_producto
WHERE p.estado = 'activo'
GROUP BY p.id_producto, p.nombre, p.estado
ORDER BY ingresos_totales DESC;

-- ==========================================
-- 6. FUNCIONES ÚTILES
-- ==========================================

-- Función: Actualizar total de compras del cliente
CREATE OR REPLACE FUNCTION actualizar_total_cliente()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE clientes 
    SET total_compras = (
        SELECT COALESCE(SUM(total), 0) 
        FROM ventas 
        WHERE id_cliente = NEW.id_cliente AND estado = 'completada'
    ),
    fecha_ultima_compra = NEW.fecha_venta
    WHERE id_cliente = NEW.id_cliente;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger: Ejecutar actualización de total cliente
CREATE TRIGGER tr_actualizar_total_cliente
AFTER INSERT ON ventas
FOR EACH ROW
EXECUTE FUNCTION actualizar_total_cliente();

-- Función: Actualizar stock después de venta
CREATE OR REPLACE FUNCTION actualizar_stock_producto()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE productos 
    SET stock_actual = stock_actual - NEW.cantidad
    WHERE id_producto = NEW.id_producto;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger: Ejecutar actualización de stock
CREATE TRIGGER tr_actualizar_stock
AFTER INSERT ON detalle_ventas
FOR EACH ROW
EXECUTE FUNCTION actualizar_stock_producto();

-- ==========================================
-- FIN DEL SCHEMA
-- ==========================================
