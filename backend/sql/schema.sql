-- ==========================================
-- SCHEMA: MiniSuper-Case POS System
-- Base de Datos para Sistema de Ventas
-- Adaptado con buenas practicas inspiradas en dvdrental
-- DB: PostgreSQL 12+
-- ==========================================

BEGIN;

-- ==========================================
-- 1. TABLAS DE AUTENTICACION Y AUTORIZACION
-- ==========================================

CREATE TABLE IF NOT EXISTS public.roles
(
    id_rol serial NOT NULL,
    nombre character varying(50) NOT NULL,
    descripcion text,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT roles_pkey PRIMARY KEY (id_rol),
    CONSTRAINT roles_nombre_key UNIQUE (nombre)
);

CREATE TABLE IF NOT EXISTS public.usuarios
(
    id_usuario serial NOT NULL,
    usuario character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    "contraseña" character varying(255) NOT NULL,
    nombre_completo character varying(150) NOT NULL,
    id_rol integer NOT NULL,
    estado character varying(20) DEFAULT 'activo'::character varying,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_ultima_sesion timestamp without time zone,
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT usuarios_pkey PRIMARY KEY (id_usuario),
    CONSTRAINT usuarios_email_key UNIQUE (email),
    CONSTRAINT usuarios_usuario_key UNIQUE (usuario),
    CONSTRAINT ck_usuarios_estado CHECK (estado IN ('activo', 'inactivo'))
);

-- ==========================================
-- 2. TABLAS MAESTRAS
-- ==========================================

CREATE TABLE IF NOT EXISTS public.categorias
(
    id_categoria serial NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    estado character varying(20) DEFAULT 'activo'::character varying,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT categorias_pkey PRIMARY KEY (id_categoria),
    CONSTRAINT categorias_nombre_key UNIQUE (nombre),
    CONSTRAINT ck_categorias_estado CHECK (estado IN ('activo', 'inactivo'))
);

CREATE TABLE IF NOT EXISTS public.productos
(
    id_producto serial NOT NULL,
    nombre character varying(150) NOT NULL,
    descripcion text,
    sku character varying(50),
    precio_costo numeric(10, 2) NOT NULL,
    precio_venta numeric(10, 2) NOT NULL,
    stock_actual integer DEFAULT 0,
    stock_minimo integer DEFAULT 5,
    id_categoria integer NOT NULL,
    estado character varying(20) DEFAULT 'activo'::character varying,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT productos_pkey PRIMARY KEY (id_producto),
    CONSTRAINT productos_sku_key UNIQUE (sku),
    CONSTRAINT ck_productos_estado CHECK (estado IN ('activo', 'inactivo')),
    CONSTRAINT ck_precio_costo_positivo CHECK (precio_costo > 0),
    CONSTRAINT ck_precio_valido CHECK (precio_venta > precio_costo),
    CONSTRAINT ck_stock_actual_no_negativo CHECK (stock_actual >= 0),
    CONSTRAINT ck_stock_minimo_no_negativo CHECK (stock_minimo >= 0)
);

CREATE TABLE IF NOT EXISTS public.clientes
(
    id_cliente serial NOT NULL,
    nombre character varying(150) NOT NULL,
    apellido character varying(150),
    email character varying(100),
    telefono character varying(20),
    direccion text,
    ciudad character varying(100),
    cedula_ruc character varying(20),
    estado character varying(20) DEFAULT 'activo'::character varying,
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_ultima_compra timestamp without time zone,
    total_compras numeric(12, 2) DEFAULT 0.00,
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT clientes_pkey PRIMARY KEY (id_cliente),
    CONSTRAINT clientes_cedula_ruc_key UNIQUE (cedula_ruc),
    CONSTRAINT ck_clientes_estado CHECK (estado IN ('activo', 'inactivo')),
    CONSTRAINT ck_clientes_total_compras CHECK (total_compras >= 0)
);

-- ==========================================
-- 3. TABLAS DE TRANSACCIONES
-- ==========================================

CREATE TABLE IF NOT EXISTS public.ventas
(
    id_venta serial NOT NULL,
    numero_factura character varying(50) NOT NULL,
    id_cliente integer NOT NULL,
    id_usuario integer NOT NULL,
    fecha_venta timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    subtotal numeric(12, 2) NOT NULL DEFAULT 0.00,
    impuesto_porcentaje numeric(5, 2) DEFAULT 12.00,
    impuesto_monto numeric(12, 2) NOT NULL DEFAULT 0.00,
    total numeric(12, 2) NOT NULL,
    monto_pagado numeric(12, 2) NOT NULL,
    cambio numeric(12, 2) DEFAULT 0.00,
    metodo_pago character varying(50) DEFAULT 'efectivo'::character varying,
    estado character varying(20) DEFAULT 'completada'::character varying,
    notas text,
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ventas_pkey PRIMARY KEY (id_venta),
    CONSTRAINT ventas_numero_factura_key UNIQUE (numero_factura),
    CONSTRAINT ck_ventas_subtotal CHECK (subtotal >= 0),
    CONSTRAINT ck_ventas_impuesto_porcentaje CHECK (impuesto_porcentaje >= 0 AND impuesto_porcentaje <= 100),
    CONSTRAINT ck_ventas_impuesto_monto CHECK (impuesto_monto >= 0),
    CONSTRAINT ck_venta_total CHECK (total > 0),
    CONSTRAINT ck_venta_pago CHECK (monto_pagado >= total),
    CONSTRAINT ck_ventas_cambio CHECK (cambio >= 0),
    CONSTRAINT ck_ventas_metodo_pago CHECK (metodo_pago IN ('efectivo', 'tarjeta', 'transferencia')),
    CONSTRAINT ck_ventas_estado CHECK (estado IN ('completada', 'anulada', 'pendiente')),
    CONSTRAINT ck_ventas_total_consistente CHECK (ROUND(subtotal + impuesto_monto, 2) = total),
    CONSTRAINT ck_ventas_cambio_consistente CHECK (ROUND(monto_pagado - total, 2) = cambio)
);

CREATE TABLE IF NOT EXISTS public.detalle_ventas
(
    id_detalle serial NOT NULL,
    id_venta integer NOT NULL,
    id_producto integer NOT NULL,
    cantidad integer NOT NULL,
    precio_unitario numeric(10, 2) NOT NULL,
    descuento_porcentaje numeric(5, 2) DEFAULT 0.00,
    descuento_monto numeric(10, 2) DEFAULT 0.00,
    subtotal_item numeric(12, 2) NOT NULL,
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT detalle_ventas_pkey PRIMARY KEY (id_detalle),
    CONSTRAINT uq_detalle_venta_producto UNIQUE (id_venta, id_producto),
    CONSTRAINT ck_cantidad_positiva CHECK (cantidad > 0),
    CONSTRAINT ck_precio_positivo CHECK (precio_unitario > 0),
    CONSTRAINT ck_descuento_porcentaje_valido CHECK (descuento_porcentaje >= 0 AND descuento_porcentaje <= 100),
    CONSTRAINT ck_descuento_monto_no_negativo CHECK (descuento_monto >= 0),
    CONSTRAINT ck_subtotal_item_no_negativo CHECK (subtotal_item >= 0),
    CONSTRAINT ck_descuento_monto_valido CHECK (descuento_monto <= ROUND(cantidad * precio_unitario, 2)),
    CONSTRAINT ck_subtotal_item_consistente CHECK (
        ROUND((cantidad * precio_unitario) - descuento_monto, 2) = subtotal_item
    )
);

-- ==========================================
-- 4. LLAVES FORANEAS
-- ==========================================

ALTER TABLE IF EXISTS public.usuarios
    DROP CONSTRAINT IF EXISTS fk_usuarios_rol;
ALTER TABLE IF EXISTS public.usuarios
    ADD CONSTRAINT fk_usuarios_rol FOREIGN KEY (id_rol)
    REFERENCES public.roles (id_rol) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE RESTRICT;

ALTER TABLE IF EXISTS public.productos
    DROP CONSTRAINT IF EXISTS fk_productos_categoria;
ALTER TABLE IF EXISTS public.productos
    ADD CONSTRAINT fk_productos_categoria FOREIGN KEY (id_categoria)
    REFERENCES public.categorias (id_categoria) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE RESTRICT;

ALTER TABLE IF EXISTS public.ventas
    DROP CONSTRAINT IF EXISTS fk_ventas_cliente;
ALTER TABLE IF EXISTS public.ventas
    ADD CONSTRAINT fk_ventas_cliente FOREIGN KEY (id_cliente)
    REFERENCES public.clientes (id_cliente) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE RESTRICT;

ALTER TABLE IF EXISTS public.ventas
    DROP CONSTRAINT IF EXISTS fk_ventas_usuario;
ALTER TABLE IF EXISTS public.ventas
    ADD CONSTRAINT fk_ventas_usuario FOREIGN KEY (id_usuario)
    REFERENCES public.usuarios (id_usuario) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE RESTRICT;

ALTER TABLE IF EXISTS public.detalle_ventas
    DROP CONSTRAINT IF EXISTS fk_detalle_venta;
ALTER TABLE IF EXISTS public.detalle_ventas
    ADD CONSTRAINT fk_detalle_venta FOREIGN KEY (id_venta)
    REFERENCES public.ventas (id_venta) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;

ALTER TABLE IF EXISTS public.detalle_ventas
    DROP CONSTRAINT IF EXISTS fk_detalle_producto;
ALTER TABLE IF EXISTS public.detalle_ventas
    ADD CONSTRAINT fk_detalle_producto FOREIGN KEY (id_producto)
    REFERENCES public.productos (id_producto) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE RESTRICT;

-- ==========================================
-- 5. INDICES
-- ==========================================

CREATE INDEX IF NOT EXISTS idx_usuarios_rol
    ON public.usuarios(id_rol);

CREATE INDEX IF NOT EXISTS idx_usuarios_estado
    ON public.usuarios(estado);

CREATE INDEX IF NOT EXISTS idx_productos_categoria
    ON public.productos(id_categoria);

CREATE INDEX IF NOT EXISTS idx_productos_estado
    ON public.productos(estado);

CREATE INDEX IF NOT EXISTS idx_productos_nombre
    ON public.productos(nombre);

CREATE INDEX IF NOT EXISTS idx_clientes_estado
    ON public.clientes(estado);

CREATE INDEX IF NOT EXISTS idx_clientes_nombre_apellido
    ON public.clientes(nombre, apellido);

CREATE INDEX IF NOT EXISTS idx_ventas_cliente
    ON public.ventas(id_cliente);

CREATE INDEX IF NOT EXISTS idx_ventas_usuario
    ON public.ventas(id_usuario);

CREATE INDEX IF NOT EXISTS idx_ventas_fecha
    ON public.ventas(fecha_venta);

CREATE INDEX IF NOT EXISTS idx_ventas_estado
    ON public.ventas(estado);

CREATE INDEX IF NOT EXISTS idx_ventas_cliente_fecha
    ON public.ventas(id_cliente, fecha_venta);

CREATE INDEX IF NOT EXISTS idx_detalle_venta
    ON public.detalle_ventas(id_venta);

CREATE INDEX IF NOT EXISTS idx_detalle_producto
    ON public.detalle_ventas(id_producto);

-- ==========================================
-- 6. VISTAS
-- ==========================================

CREATE OR REPLACE VIEW public.v_ventas_detalladas AS
SELECT
    v.id_venta,
    v.numero_factura,
    v.fecha_venta,
    CONCAT(c.nombre, ' ', COALESCE(c.apellido, '')) AS cliente,
    u.nombre_completo AS vendedor,
    v.subtotal,
    v.impuesto_monto,
    v.total,
    v.metodo_pago,
    v.estado,
    COUNT(dv.id_detalle) AS cantidad_items
FROM public.ventas v
JOIN public.clientes c
    ON v.id_cliente = c.id_cliente
JOIN public.usuarios u
    ON v.id_usuario = u.id_usuario
LEFT JOIN public.detalle_ventas dv
    ON v.id_venta = dv.id_venta
GROUP BY
    v.id_venta,
    v.numero_factura,
    v.fecha_venta,
    c.nombre,
    c.apellido,
    u.nombre_completo,
    v.subtotal,
    v.impuesto_monto,
    v.total,
    v.metodo_pago,
    v.estado;

CREATE OR REPLACE VIEW public.v_productos_stock_critico AS
SELECT
    p.id_producto,
    p.nombre,
    p.stock_actual,
    p.stock_minimo,
    (p.stock_minimo - p.stock_actual) AS deficit,
    p.estado
FROM public.productos p
WHERE p.estado = 'activo'
  AND p.stock_actual <= p.stock_minimo
ORDER BY deficit DESC, p.nombre;

CREATE OR REPLACE VIEW public.v_productos_desempeno AS
SELECT
    p.id_producto,
    p.nombre,
    COUNT(DISTINCT dv.id_venta) AS numero_ventas,
    COALESCE(SUM(dv.cantidad), 0) AS cantidad_vendida,
    COALESCE(SUM(dv.subtotal_item), 0.00) AS ingresos_totales,
    AVG(dv.precio_unitario) AS precio_promedio,
    p.estado
FROM public.productos p
LEFT JOIN public.detalle_ventas dv
    ON p.id_producto = dv.id_producto
WHERE p.estado = 'activo'
GROUP BY p.id_producto, p.nombre, p.estado
ORDER BY ingresos_totales DESC, p.nombre;

-- ==========================================
-- 7. FUNCIONES Y TRIGGERS
-- ==========================================

CREATE OR REPLACE FUNCTION public.set_fecha_actualizacion()
RETURNS trigger AS $$
BEGIN
    NEW.fecha_actualizacion = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.actualizar_total_cliente()
RETURNS trigger AS $$
DECLARE
    v_cliente_nuevo integer;
    v_cliente_anterior integer;
BEGIN
    v_cliente_nuevo := CASE WHEN TG_OP IN ('INSERT', 'UPDATE') THEN NEW.id_cliente ELSE NULL END;
    v_cliente_anterior := CASE WHEN TG_OP IN ('UPDATE', 'DELETE') THEN OLD.id_cliente ELSE NULL END;

    IF v_cliente_nuevo IS NOT NULL THEN
        UPDATE public.clientes
        SET total_compras = COALESCE((
                SELECT ROUND(SUM(v.total), 2)
                FROM public.ventas v
                WHERE v.id_cliente = v_cliente_nuevo
                  AND v.estado = 'completada'
            ), 0.00),
            fecha_ultima_compra = (
                SELECT MAX(v.fecha_venta)
                FROM public.ventas v
                WHERE v.id_cliente = v_cliente_nuevo
                  AND v.estado = 'completada'
            )
        WHERE id_cliente = v_cliente_nuevo;
    END IF;

    IF v_cliente_anterior IS NOT NULL AND v_cliente_anterior <> v_cliente_nuevo THEN
        UPDATE public.clientes
        SET total_compras = COALESCE((
                SELECT ROUND(SUM(v.total), 2)
                FROM public.ventas v
                WHERE v.id_cliente = v_cliente_anterior
                  AND v.estado = 'completada'
            ), 0.00),
            fecha_ultima_compra = (
                SELECT MAX(v.fecha_venta)
                FROM public.ventas v
                WHERE v.id_cliente = v_cliente_anterior
                  AND v.estado = 'completada'
            )
        WHERE id_cliente = v_cliente_anterior;
    END IF;

    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.actualizar_stock_producto()
RETURNS trigger AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE public.productos
        SET stock_actual = stock_actual - NEW.cantidad
        WHERE id_producto = NEW.id_producto;
        RETURN NEW;
    END IF;

    IF TG_OP = 'DELETE' THEN
        UPDATE public.productos
        SET stock_actual = stock_actual + OLD.cantidad
        WHERE id_producto = OLD.id_producto;
        RETURN OLD;
    END IF;

    IF OLD.id_producto <> NEW.id_producto THEN
        UPDATE public.productos
        SET stock_actual = stock_actual + OLD.cantidad
        WHERE id_producto = OLD.id_producto;

        UPDATE public.productos
        SET stock_actual = stock_actual - NEW.cantidad
        WHERE id_producto = NEW.id_producto;
    ELSE
        UPDATE public.productos
        SET stock_actual = stock_actual + OLD.cantidad - NEW.cantidad
        WHERE id_producto = NEW.id_producto;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tr_roles_set_fecha_actualizacion ON public.roles;
CREATE TRIGGER tr_roles_set_fecha_actualizacion
BEFORE UPDATE ON public.roles
FOR EACH ROW
EXECUTE FUNCTION public.set_fecha_actualizacion();

DROP TRIGGER IF EXISTS tr_usuarios_set_fecha_actualizacion ON public.usuarios;
CREATE TRIGGER tr_usuarios_set_fecha_actualizacion
BEFORE UPDATE ON public.usuarios
FOR EACH ROW
EXECUTE FUNCTION public.set_fecha_actualizacion();

DROP TRIGGER IF EXISTS tr_categorias_set_fecha_actualizacion ON public.categorias;
CREATE TRIGGER tr_categorias_set_fecha_actualizacion
BEFORE UPDATE ON public.categorias
FOR EACH ROW
EXECUTE FUNCTION public.set_fecha_actualizacion();

DROP TRIGGER IF EXISTS tr_productos_set_fecha_actualizacion ON public.productos;
CREATE TRIGGER tr_productos_set_fecha_actualizacion
BEFORE UPDATE ON public.productos
FOR EACH ROW
EXECUTE FUNCTION public.set_fecha_actualizacion();

DROP TRIGGER IF EXISTS tr_clientes_set_fecha_actualizacion ON public.clientes;
CREATE TRIGGER tr_clientes_set_fecha_actualizacion
BEFORE UPDATE ON public.clientes
FOR EACH ROW
EXECUTE FUNCTION public.set_fecha_actualizacion();

DROP TRIGGER IF EXISTS tr_ventas_set_fecha_actualizacion ON public.ventas;
CREATE TRIGGER tr_ventas_set_fecha_actualizacion
BEFORE UPDATE ON public.ventas
FOR EACH ROW
EXECUTE FUNCTION public.set_fecha_actualizacion();

DROP TRIGGER IF EXISTS tr_detalle_ventas_set_fecha_actualizacion ON public.detalle_ventas;
CREATE TRIGGER tr_detalle_ventas_set_fecha_actualizacion
BEFORE UPDATE ON public.detalle_ventas
FOR EACH ROW
EXECUTE FUNCTION public.set_fecha_actualizacion();

DROP TRIGGER IF EXISTS tr_actualizar_total_cliente ON public.ventas;
CREATE TRIGGER tr_actualizar_total_cliente
AFTER INSERT OR UPDATE OR DELETE ON public.ventas
FOR EACH ROW
EXECUTE FUNCTION public.actualizar_total_cliente();

DROP TRIGGER IF EXISTS tr_actualizar_stock ON public.detalle_ventas;
CREATE TRIGGER tr_actualizar_stock
AFTER INSERT OR UPDATE OR DELETE ON public.detalle_ventas
FOR EACH ROW
EXECUTE FUNCTION public.actualizar_stock_producto();

COMMIT;

-- ==========================================
-- FIN DEL SCHEMA
-- ==========================================
