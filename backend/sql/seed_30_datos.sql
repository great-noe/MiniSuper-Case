-- ==========================================
-- SEED: datos de ejemplo para MiniSuper
-- Compatible con el esquema generado en pgAdmin
-- Nota: la tabla roles se carga con 2 registros
--       por requerimiento: Administrador y Vendedor.
--       El resto de tablas se carga con 30 registros.
-- ==========================================

BEGIN;

-- ==========================================
-- 1. ROLES
-- ==========================================
INSERT INTO public.roles (nombre, descripcion, fecha_creacion, fecha_actualizacion)
VALUES
    ('Administrador', 'Acceso completo al sistema', TIMESTAMP '2026-01-01 08:00:00', TIMESTAMP '2026-01-01 08:00:00'),
    ('Vendedor', 'Gestion de ventas y atencion al cliente', TIMESTAMP '2026-01-01 08:10:00', TIMESTAMP '2026-01-01 08:10:00')
ON CONFLICT (nombre) DO NOTHING;

-- ==========================================
-- 2. USUARIOS
-- ==========================================
WITH datos_usuarios (
    usuario,
    email,
    nombre_completo,
    rol_nombre,
    fecha_creacion,
    fecha_ultima_sesion
) AS (
    VALUES
        ('cmendoza', 'carlos.mendoza@minisuper.test', 'Carlos Mendoza', 'Administrador', TIMESTAMP '2026-01-03 08:00:00', TIMESTAMP '2026-05-01 08:15:00'),
        ('aflores', 'ana.flores@minisuper.test', 'Ana Flores', 'Administrador', TIMESTAMP '2026-01-03 08:10:00', TIMESTAMP '2026-05-01 08:20:00'),
        ('jrojas', 'jorge.rojas@minisuper.test', 'Jorge Rojas', 'Administrador', TIMESTAMP '2026-01-03 08:20:00', TIMESTAMP '2026-05-01 08:25:00'),
        ('mquispe', 'maria.quispe@minisuper.test', 'Maria Quispe', 'Administrador', TIMESTAMP '2026-01-03 08:30:00', TIMESTAMP '2026-05-01 08:30:00'),
        ('lgarcia', 'laura.garcia@minisuper.test', 'Laura Garcia', 'Administrador', TIMESTAMP '2026-01-03 08:40:00', TIMESTAMP '2026-05-01 08:35:00'),
        ('pperez', 'paola.perez@minisuper.test', 'Paola Perez', 'Vendedor', TIMESTAMP '2026-01-03 08:50:00', TIMESTAMP '2026-05-01 08:40:00'),
        ('rdiaz', 'raul.diaz@minisuper.test', 'Raul Diaz', 'Vendedor', TIMESTAMP '2026-01-03 09:00:00', TIMESTAMP '2026-05-01 08:45:00'),
        ('slopez', 'sofia.lopez@minisuper.test', 'Sofia Lopez', 'Vendedor', TIMESTAMP '2026-01-03 09:10:00', TIMESTAMP '2026-05-01 08:50:00'),
        ('aherrera', 'andres.herrera@minisuper.test', 'Andres Herrera', 'Vendedor', TIMESTAMP '2026-01-03 09:20:00', TIMESTAMP '2026-05-01 08:55:00'),
        ('dtorrez', 'daniela.torrez@minisuper.test', 'Daniela Torrez', 'Vendedor', TIMESTAMP '2026-01-03 09:30:00', TIMESTAMP '2026-05-01 09:00:00'),
        ('fvargas', 'fernando.vargas@minisuper.test', 'Fernando Vargas', 'Vendedor', TIMESTAMP '2026-01-03 09:40:00', TIMESTAMP '2026-05-01 09:05:00'),
        ('ncampos', 'natalia.campos@minisuper.test', 'Natalia Campos', 'Vendedor', TIMESTAMP '2026-01-03 09:50:00', TIMESTAMP '2026-05-01 09:10:00'),
        ('ecastro', 'elias.castro@minisuper.test', 'Elias Castro', 'Vendedor', TIMESTAMP '2026-01-03 10:00:00', TIMESTAMP '2026-05-01 09:15:00'),
        ('vortiz', 'valeria.ortiz@minisuper.test', 'Valeria Ortiz', 'Vendedor', TIMESTAMP '2026-01-03 10:10:00', TIMESTAMP '2026-05-01 09:20:00'),
        ('ghuanca', 'gabriel.huanca@minisuper.test', 'Gabriel Huanca', 'Vendedor', TIMESTAMP '2026-01-03 10:20:00', TIMESTAMP '2026-05-01 09:25:00'),
        ('rcondori', 'rosa.condori@minisuper.test', 'Rosa Condori', 'Vendedor', TIMESTAMP '2026-01-03 10:30:00', TIMESTAMP '2026-05-01 09:30:00'),
        ('jmamani', 'juan.mamani@minisuper.test', 'Juan Mamani', 'Vendedor', TIMESTAMP '2026-01-03 10:40:00', TIMESTAMP '2026-05-01 09:35:00'),
        ('kgutierrez', 'karla.gutierrez@minisuper.test', 'Karla Gutierrez', 'Vendedor', TIMESTAMP '2026-01-03 10:50:00', TIMESTAMP '2026-05-01 09:40:00'),
        ('ocallisaya', 'oscar.callisaya@minisuper.test', 'Oscar Callisaya', 'Vendedor', TIMESTAMP '2026-01-03 11:00:00', TIMESTAMP '2026-05-01 09:45:00'),
        ('ybustillos', 'yasmin.bustillos@minisuper.test', 'Yasmin Bustillos', 'Vendedor', TIMESTAMP '2026-01-03 11:10:00', TIMESTAMP '2026-05-01 09:50:00'),
        ('hsalazar', 'hector.salazar@minisuper.test', 'Hector Salazar', 'Vendedor', TIMESTAMP '2026-01-03 11:20:00', TIMESTAMP '2026-05-01 09:55:00'),
        ('caguilar', 'camila.aguilar@minisuper.test', 'Camila Aguilar', 'Vendedor', TIMESTAMP '2026-01-03 11:30:00', TIMESTAMP '2026-05-01 10:00:00'),
        ('apadilla', 'alberto.padilla@minisuper.test', 'Alberto Padilla', 'Vendedor', TIMESTAMP '2026-01-03 11:40:00', TIMESTAMP '2026-05-01 10:05:00'),
        ('lrivera', 'lucia.rivera@minisuper.test', 'Lucia Rivera', 'Vendedor', TIMESTAMP '2026-01-03 11:50:00', TIMESTAMP '2026-05-01 10:10:00'),
        ('bmiranda', 'bruno.miranda@minisuper.test', 'Bruno Miranda', 'Vendedor', TIMESTAMP '2026-01-03 12:00:00', TIMESTAMP '2026-05-01 10:15:00'),
        ('msuarez', 'melissa.suarez@minisuper.test', 'Melissa Suarez', 'Vendedor', TIMESTAMP '2026-01-03 12:10:00', TIMESTAMP '2026-05-01 10:20:00'),
        ('pnavarro', 'pablo.navarro@minisuper.test', 'Pablo Navarro', 'Vendedor', TIMESTAMP '2026-01-03 12:20:00', TIMESTAMP '2026-05-01 10:25:00'),
        ('itarela', 'irene.tarela@minisuper.test', 'Irene Tarela', 'Vendedor', TIMESTAMP '2026-01-03 12:30:00', TIMESTAMP '2026-05-01 10:30:00'),
        ('dvelasco', 'diego.velasco@minisuper.test', 'Diego Velasco', 'Vendedor', TIMESTAMP '2026-01-03 12:40:00', TIMESTAMP '2026-05-01 10:35:00'),
        ('smedina', 'susana.medina@minisuper.test', 'Susana Medina', 'Vendedor', TIMESTAMP '2026-01-03 12:50:00', TIMESTAMP '2026-05-01 10:40:00')
)
INSERT INTO public.usuarios (
    usuario,
    email,
    "contraseña",
    nombre_completo,
    id_rol,
    estado,
    fecha_creacion,
    fecha_ultima_sesion,
    fecha_actualizacion
)
SELECT
    du.usuario,
    du.email,
    '$2b$10$abcdefghijklmnopqrstuvABCDEFGHIJKLMN0123456789abcd',
    du.nombre_completo,
    r.id_rol,
    'activo',
    du.fecha_creacion,
    du.fecha_ultima_sesion,
    du.fecha_ultima_sesion
FROM datos_usuarios du
JOIN public.roles r
    ON r.nombre = du.rol_nombre
ON CONFLICT (usuario) DO NOTHING;

-- ==========================================
-- 3. CATEGORIAS
-- ==========================================
INSERT INTO public.categorias (nombre, descripcion, estado, fecha_creacion, fecha_actualizacion)
VALUES
    ('Abarrotes', 'Productos basicos de despensa', 'activo', TIMESTAMP '2026-01-05 08:00:00', TIMESTAMP '2026-01-05 08:00:00'),
    ('Bebidas', 'Gaseosas, jugos y aguas', 'activo', TIMESTAMP '2026-01-05 08:10:00', TIMESTAMP '2026-01-05 08:10:00'),
    ('Lacteos', 'Leche, yogurt y derivados', 'activo', TIMESTAMP '2026-01-05 08:20:00', TIMESTAMP '2026-01-05 08:20:00'),
    ('Panaderia', 'Pan y productos horneados', 'activo', TIMESTAMP '2026-01-05 08:30:00', TIMESTAMP '2026-01-05 08:30:00'),
    ('Snacks', 'Papas fritas y bocaditos', 'activo', TIMESTAMP '2026-01-05 08:40:00', TIMESTAMP '2026-01-05 08:40:00'),
    ('Limpieza', 'Limpieza del hogar', 'activo', TIMESTAMP '2026-01-05 08:50:00', TIMESTAMP '2026-01-05 08:50:00'),
    ('Higiene Personal', 'Cuidado personal diario', 'activo', TIMESTAMP '2026-01-05 09:00:00', TIMESTAMP '2026-01-05 09:00:00'),
    ('Frutas', 'Frutas frescas', 'activo', TIMESTAMP '2026-01-05 09:10:00', TIMESTAMP '2026-01-05 09:10:00'),
    ('Verduras', 'Verduras frescas', 'activo', TIMESTAMP '2026-01-05 09:20:00', TIMESTAMP '2026-01-05 09:20:00'),
    ('Congelados', 'Productos refrigerados y congelados', 'activo', TIMESTAMP '2026-01-05 09:30:00', TIMESTAMP '2026-01-05 09:30:00'),
    ('Enlatados', 'Conservas y alimentos listos', 'activo', TIMESTAMP '2026-01-05 09:40:00', TIMESTAMP '2026-01-05 09:40:00'),
    ('Embutidos', 'Fiambres y derivados', 'activo', TIMESTAMP '2026-01-05 09:50:00', TIMESTAMP '2026-01-05 09:50:00'),
    ('Desayunos', 'Cafe, te y acompañamientos', 'activo', TIMESTAMP '2026-01-05 10:00:00', TIMESTAMP '2026-01-05 10:00:00'),
    ('Galletas', 'Galletas dulces y saladas', 'activo', TIMESTAMP '2026-01-05 10:10:00', TIMESTAMP '2026-01-05 10:10:00'),
    ('Dulces', 'Chocolates y caramelos', 'activo', TIMESTAMP '2026-01-05 10:20:00', TIMESTAMP '2026-01-05 10:20:00'),
    ('Mascotas', 'Alimento para mascotas', 'activo', TIMESTAMP '2026-01-05 10:30:00', TIMESTAMP '2026-01-05 10:30:00'),
    ('Bebes', 'Productos para bebe', 'activo', TIMESTAMP '2026-01-05 10:40:00', TIMESTAMP '2026-01-05 10:40:00'),
    ('Utiles Hogar', 'Accesorios para casa', 'activo', TIMESTAMP '2026-01-05 10:50:00', TIMESTAMP '2026-01-05 10:50:00'),
    ('Cuidado Ropa', 'Detergentes y suavizantes', 'activo', TIMESTAMP '2026-01-05 11:00:00', TIMESTAMP '2026-01-05 11:00:00'),
    ('Papeleria', 'Articulos escolares y oficina', 'activo', TIMESTAMP '2026-01-05 11:10:00', TIMESTAMP '2026-01-05 11:10:00'),
    ('Condimentos', 'Especias y sazonadores', 'activo', TIMESTAMP '2026-01-05 11:20:00', TIMESTAMP '2026-01-05 11:20:00'),
    ('Pastas', 'Fideos y derivados', 'activo', TIMESTAMP '2026-01-05 11:30:00', TIMESTAMP '2026-01-05 11:30:00'),
    ('Granos', 'Lenteja, poroto y similares', 'activo', TIMESTAMP '2026-01-05 11:40:00', TIMESTAMP '2026-01-05 11:40:00'),
    ('Aceites', 'Aceites comestibles', 'activo', TIMESTAMP '2026-01-05 11:50:00', TIMESTAMP '2026-01-05 11:50:00'),
    ('Reposteria', 'Ingredientes para postres', 'activo', TIMESTAMP '2026-01-05 12:00:00', TIMESTAMP '2026-01-05 12:00:00'),
    ('Cereales', 'Cereales para desayuno', 'activo', TIMESTAMP '2026-01-05 12:10:00', TIMESTAMP '2026-01-05 12:10:00'),
    ('Helados', 'Helados individuales y familiares', 'activo', TIMESTAMP '2026-01-05 12:20:00', TIMESTAMP '2026-01-05 12:20:00'),
    ('Farmacia Basica', 'Productos de cuidado basico', 'activo', TIMESTAMP '2026-01-05 12:30:00', TIMESTAMP '2026-01-05 12:30:00'),
    ('Desechables', 'Vasos, platos y bolsas', 'activo', TIMESTAMP '2026-01-05 12:40:00', TIMESTAMP '2026-01-05 12:40:00'),
    ('Tecnologia Basica', 'Accesorios de uso cotidiano', 'activo', TIMESTAMP '2026-01-05 12:50:00', TIMESTAMP '2026-01-05 12:50:00')
ON CONFLICT (nombre) DO NOTHING;

-- ==========================================
-- 4. PRODUCTOS
-- ==========================================
WITH datos_productos (
    nombre,
    descripcion,
    sku,
    precio_costo,
    precio_venta,
    stock_actual,
    stock_minimo,
    categoria_nombre,
    fecha_creacion,
    fecha_actualizacion
) AS (
    VALUES
        ('Arroz Premium 1kg', 'Arroz de grano largo de alta rotacion', 'SKU-0001', 8.30, 11.90, 95, 12, 'Abarrotes', TIMESTAMP '2026-01-10 08:00:00', TIMESTAMP '2026-04-20 09:00:00'),
        ('Gaseosa Cola 2L', 'Bebida gaseosa familiar', 'SKU-0002', 6.10, 8.90, 70, 10, 'Bebidas', TIMESTAMP '2026-01-10 08:10:00', TIMESTAMP '2026-04-20 09:10:00'),
        ('Leche Entera 1L', 'Leche pasteurizada larga vida', 'SKU-0003', 4.80, 7.20, 85, 12, 'Lacteos', TIMESTAMP '2026-01-10 08:20:00', TIMESTAMP '2026-04-20 09:20:00'),
        ('Pan Molde Integral', 'Pan integral rebanado', 'SKU-0004', 5.50, 8.10, 40, 8, 'Panaderia', TIMESTAMP '2026-01-10 08:30:00', TIMESTAMP '2026-04-20 09:30:00'),
        ('Papas Fritas Clasicas 150g', 'Snack salado familiar', 'SKU-0005', 7.40, 10.80, 55, 10, 'Snacks', TIMESTAMP '2026-01-10 08:40:00', TIMESTAMP '2026-04-20 09:40:00'),
        ('Lavandina 2L', 'Desinfectante para pisos y superficies', 'SKU-0006', 9.10, 13.70, 38, 6, 'Limpieza', TIMESTAMP '2026-01-10 08:50:00', TIMESTAMP '2026-04-20 09:50:00'),
        ('Shampoo Familiar 750ml', 'Shampoo para uso diario', 'SKU-0007', 14.20, 20.90, 30, 5, 'Higiene Personal', TIMESTAMP '2026-01-10 09:00:00', TIMESTAMP '2026-04-20 10:00:00'),
        ('Manzana Roja 1kg', 'Manzana fresca seleccionada', 'SKU-0008', 9.00, 13.20, 60, 10, 'Frutas', TIMESTAMP '2026-01-10 09:10:00', TIMESTAMP '2026-04-20 10:10:00'),
        ('Tomate 1kg', 'Tomate fresco para cocina diaria', 'SKU-0009', 6.70, 9.80, 58, 9, 'Verduras', TIMESTAMP '2026-01-10 09:20:00', TIMESTAMP '2026-04-20 10:20:00'),
        ('Nuggets de Pollo 500g', 'Empanizado congelado listo para freir', 'SKU-0010', 16.50, 23.90, 32, 6, 'Congelados', TIMESTAMP '2026-01-10 09:30:00', TIMESTAMP '2026-04-20 10:30:00'),
        ('Atun en Agua 170g', 'Conserva lista para ensaladas', 'SKU-0011', 8.40, 12.60, 45, 8, 'Enlatados', TIMESTAMP '2026-01-10 09:40:00', TIMESTAMP '2026-04-20 10:40:00'),
        ('Jamon Sandwich 250g', 'Embutido refrigerado', 'SKU-0012', 12.80, 18.70, 28, 5, 'Embutidos', TIMESTAMP '2026-01-10 09:50:00', TIMESTAMP '2026-04-20 10:50:00'),
        ('Cafe Molido 250g', 'Cafe tostado y molido', 'SKU-0013', 11.90, 17.50, 34, 6, 'Desayunos', TIMESTAMP '2026-01-10 10:00:00', TIMESTAMP '2026-04-20 11:00:00'),
        ('Galletas de Chocolate 12u', 'Galletas rellenas', 'SKU-0014', 4.60, 6.90, 80, 12, 'Galletas', TIMESTAMP '2026-01-10 10:10:00', TIMESTAMP '2026-04-20 11:10:00'),
        ('Chocolate en Barra 100g', 'Chocolate con leche', 'SKU-0015', 5.20, 7.80, 65, 10, 'Dulces', TIMESTAMP '2026-01-10 10:20:00', TIMESTAMP '2026-04-20 11:20:00'),
        ('Croquetas para Perro 2kg', 'Alimento balanceado para mascota', 'SKU-0016', 21.80, 31.50, 22, 4, 'Mascotas', TIMESTAMP '2026-01-10 10:30:00', TIMESTAMP '2026-04-20 11:30:00'),
        ('Pañales Talla M 20u', 'Pañales desechables para bebe', 'SKU-0017', 24.30, 34.90, 24, 4, 'Bebes', TIMESTAMP '2026-01-10 10:40:00', TIMESTAMP '2026-04-20 11:40:00'),
        ('Esponja Multiuso 3u', 'Esponjas para cocina', 'SKU-0018', 3.40, 5.20, 72, 10, 'Utiles Hogar', TIMESTAMP '2026-01-10 10:50:00', TIMESTAMP '2026-04-20 11:50:00'),
        ('Detergente Liquido 1L', 'Lavado de ropa a mano o maquina', 'SKU-0019', 10.60, 15.40, 36, 6, 'Cuidado Ropa', TIMESTAMP '2026-01-10 11:00:00', TIMESTAMP '2026-04-20 12:00:00'),
        ('Cuaderno Universitario', 'Cuaderno de 100 hojas', 'SKU-0020', 7.10, 10.40, 50, 8, 'Papeleria', TIMESTAMP '2026-01-10 11:10:00', TIMESTAMP '2026-04-20 12:10:00'),
        ('Oregano Molido 50g', 'Condimento seco para cocina', 'SKU-0021', 2.90, 4.50, 62, 10, 'Condimentos', TIMESTAMP '2026-01-10 11:20:00', TIMESTAMP '2026-04-20 12:20:00'),
        ('Spaghetti 900g', 'Pasta seca de alta rotacion', 'SKU-0022', 6.20, 9.10, 57, 9, 'Pastas', TIMESTAMP '2026-01-10 11:30:00', TIMESTAMP '2026-04-20 12:30:00'),
        ('Lenteja 1kg', 'Grano seleccionado', 'SKU-0023', 7.70, 11.20, 49, 8, 'Granos', TIMESTAMP '2026-01-10 11:40:00', TIMESTAMP '2026-04-20 12:40:00'),
        ('Aceite Vegetal 900ml', 'Aceite para cocina diaria', 'SKU-0024', 11.30, 16.50, 41, 7, 'Aceites', TIMESTAMP '2026-01-10 11:50:00', TIMESTAMP '2026-04-20 12:50:00'),
        ('Harina sin Preparar 1kg', 'Harina para reposteria y cocina', 'SKU-0025', 5.00, 7.60, 64, 10, 'Reposteria', TIMESTAMP '2026-01-10 12:00:00', TIMESTAMP '2026-04-20 13:00:00'),
        ('Cereal de Maiz 500g', 'Cereal crocante para desayuno', 'SKU-0026', 9.80, 14.10, 33, 6, 'Cereales', TIMESTAMP '2026-01-10 12:10:00', TIMESTAMP '2026-04-20 13:10:00'),
        ('Helado Vainilla 1L', 'Helado familiar', 'SKU-0027', 13.90, 19.80, 21, 4, 'Helados', TIMESTAMP '2026-01-10 12:20:00', TIMESTAMP '2026-04-20 13:20:00'),
        ('Alcohol Antiseptico 250ml', 'Solucion de uso basico', 'SKU-0028', 4.70, 7.10, 44, 7, 'Farmacia Basica', TIMESTAMP '2026-01-10 12:30:00', TIMESTAMP '2026-04-20 13:30:00'),
        ('Vasos Desechables 25u', 'Vasos para eventos y reuniones', 'SKU-0029', 3.90, 5.90, 68, 10, 'Desechables', TIMESTAMP '2026-01-10 12:40:00', TIMESTAMP '2026-04-20 13:40:00'),
        ('Cable USB Tipo C', 'Accesorio de carga rapida', 'SKU-0030', 12.40, 18.20, 26, 5, 'Tecnologia Basica', TIMESTAMP '2026-01-10 12:50:00', TIMESTAMP '2026-04-20 13:50:00')
)
INSERT INTO public.productos (
    nombre,
    descripcion,
    sku,
    precio_costo,
    precio_venta,
    stock_actual,
    stock_minimo,
    id_categoria,
    estado,
    fecha_creacion,
    fecha_actualizacion
)
SELECT
    dp.nombre,
    dp.descripcion,
    dp.sku,
    dp.precio_costo,
    dp.precio_venta,
    dp.stock_actual,
    dp.stock_minimo,
    c.id_categoria,
    'activo',
    dp.fecha_creacion,
    dp.fecha_actualizacion
FROM datos_productos dp
JOIN public.categorias c
    ON c.nombre = dp.categoria_nombre
ON CONFLICT (sku) DO NOTHING;

-- ==========================================
-- 5. CLIENTES
-- ==========================================
INSERT INTO public.clientes (
    nombre,
    apellido,
    email,
    telefono,
    direccion,
    ciudad,
    cedula_ruc,
    estado,
    fecha_registro,
    fecha_ultima_compra,
    total_compras,
    fecha_actualizacion
)
VALUES
    ('Luis', 'Fernandez', 'luis.fernandez@correo.test', '70010001', 'Av. Busch 120', 'La Paz', 'CI00000001', 'activo', TIMESTAMP '2026-01-15 08:00:00', NULL, 0.00, TIMESTAMP '2026-01-15 08:00:00'),
    ('Gabriela', 'Soria', 'gabriela.soria@correo.test', '70010002', 'Calle Aroma 45', 'Santa Cruz', 'CI00000002', 'activo', TIMESTAMP '2026-01-15 08:10:00', NULL, 0.00, TIMESTAMP '2026-01-15 08:10:00'),
    ('Marco', 'Alvarez', 'marco.alvarez@correo.test', '70010003', 'Zona Norte 221', 'Cochabamba', 'CI00000003', 'activo', TIMESTAMP '2026-01-15 08:20:00', NULL, 0.00, TIMESTAMP '2026-01-15 08:20:00'),
    ('Patricia', 'Vega', 'patricia.vega@correo.test', '70010004', 'Av. Potosi 98', 'Sucre', 'CI00000004', 'activo', TIMESTAMP '2026-01-15 08:30:00', NULL, 0.00, TIMESTAMP '2026-01-15 08:30:00'),
    ('Diego', 'Molina', 'diego.molina@correo.test', '70010005', 'Barrio Central 77', 'Tarija', 'CI00000005', 'activo', TIMESTAMP '2026-01-15 08:40:00', NULL, 0.00, TIMESTAMP '2026-01-15 08:40:00'),
    ('Carla', 'Nina', 'carla.nina@correo.test', '70010006', 'Calle Beni 301', 'Oruro', 'CI00000006', 'activo', TIMESTAMP '2026-01-15 08:50:00', NULL, 0.00, TIMESTAMP '2026-01-15 08:50:00'),
    ('Renzo', 'Paz', 'renzo.paz@correo.test', '70010007', 'Av. America 1200', 'Cochabamba', 'CI00000007', 'activo', TIMESTAMP '2026-01-15 09:00:00', NULL, 0.00, TIMESTAMP '2026-01-15 09:00:00'),
    ('Monica', 'Arce', 'monica.arce@correo.test', '70010008', 'Zona Sur 555', 'La Paz', 'CI00000008', 'activo', TIMESTAMP '2026-01-15 09:10:00', NULL, 0.00, TIMESTAMP '2026-01-15 09:10:00'),
    ('Javier', 'Ibarra', 'javier.ibarra@correo.test', '70010009', 'Calle 6 de Agosto 18', 'Santa Cruz', 'CI00000009', 'activo', TIMESTAMP '2026-01-15 09:20:00', NULL, 0.00, TIMESTAMP '2026-01-15 09:20:00'),
    ('Daniela', 'Peinado', 'daniela.peinado@correo.test', '70010010', 'Av. Blanco Galindo 900', 'Cochabamba', 'CI00000010', 'activo', TIMESTAMP '2026-01-15 09:30:00', NULL, 0.00, TIMESTAMP '2026-01-15 09:30:00'),
    ('Sergio', 'Loayza', 'sergio.loayza@correo.test', '70010011', 'Barrio Petrolero 33', 'Santa Cruz', 'CI00000011', 'activo', TIMESTAMP '2026-01-15 09:40:00', NULL, 0.00, TIMESTAMP '2026-01-15 09:40:00'),
    ('Natalia', 'Escobar', 'natalia.escobar@correo.test', '70010012', 'Calle Junin 208', 'Sucre', 'CI00000012', 'activo', TIMESTAMP '2026-01-15 09:50:00', NULL, 0.00, TIMESTAMP '2026-01-15 09:50:00'),
    ('Victor', 'Cespedes', 'victor.cespedes@correo.test', '70010013', 'Av. Banzer 480', 'Santa Cruz', 'CI00000013', 'activo', TIMESTAMP '2026-01-15 10:00:00', NULL, 0.00, TIMESTAMP '2026-01-15 10:00:00'),
    ('Luciana', 'Prado', 'luciana.prado@correo.test', '70010014', 'Calle Dalence 71', 'Oruro', 'CI00000014', 'activo', TIMESTAMP '2026-01-15 10:10:00', NULL, 0.00, TIMESTAMP '2026-01-15 10:10:00'),
    ('Oscar', 'Valdez', 'oscar.valdez@correo.test', '70010015', 'Av. Circunvalacion 62', 'Tarija', 'CI00000015', 'activo', TIMESTAMP '2026-01-15 10:20:00', NULL, 0.00, TIMESTAMP '2026-01-15 10:20:00'),
    ('Rocio', 'Mendez', 'rocio.mendez@correo.test', '70010016', 'Zona El Tejar 89', 'La Paz', 'CI00000016', 'activo', TIMESTAMP '2026-01-15 10:30:00', NULL, 0.00, TIMESTAMP '2026-01-15 10:30:00'),
    ('Hugo', 'Chura', 'hugo.chura@correo.test', '70010017', 'Calle Campero 12', 'Potosi', 'CI00000017', 'activo', TIMESTAMP '2026-01-15 10:40:00', NULL, 0.00, TIMESTAMP '2026-01-15 10:40:00'),
    ('Tatiana', 'Lema', 'tatiana.lema@correo.test', '70010018', 'Av. Integracion 150', 'Trinidad', 'CI00000018', 'activo', TIMESTAMP '2026-01-15 10:50:00', NULL, 0.00, TIMESTAMP '2026-01-15 10:50:00'),
    ('Kevin', 'Montes', 'kevin.montes@correo.test', '70010019', 'Barrio Nuevo 401', 'Montero', 'CI00000019', 'activo', TIMESTAMP '2026-01-15 11:00:00', NULL, 0.00, TIMESTAMP '2026-01-15 11:00:00'),
    ('Mariela', 'Sanchez', 'mariela.sanchez@correo.test', '70010020', 'Calle Republica 73', 'La Paz', 'CI00000020', 'activo', TIMESTAMP '2026-01-15 11:10:00', NULL, 0.00, TIMESTAMP '2026-01-15 11:10:00'),
    ('Edgar', 'Ribera', 'edgar.ribera@correo.test', '70010021', 'Av. Mutualista 510', 'Santa Cruz', 'CI00000021', 'activo', TIMESTAMP '2026-01-15 11:20:00', NULL, 0.00, TIMESTAMP '2026-01-15 11:20:00'),
    ('Vanessa', 'Torrico', 'vanessa.torrico@correo.test', '70010022', 'Zona Queru Queru 240', 'Cochabamba', 'CI00000022', 'activo', TIMESTAMP '2026-01-15 11:30:00', NULL, 0.00, TIMESTAMP '2026-01-15 11:30:00'),
    ('Julio', 'Arias', 'julio.arias@correo.test', '70010023', 'Av. Los Sauces 341', 'Tarija', 'CI00000023', 'activo', TIMESTAMP '2026-01-15 11:40:00', NULL, 0.00, TIMESTAMP '2026-01-15 11:40:00'),
    ('Cynthia', 'Zeballos', 'cynthia.zeballos@correo.test', '70010024', 'Calle Comercio 19', 'Oruro', 'CI00000024', 'activo', TIMESTAMP '2026-01-15 11:50:00', NULL, 0.00, TIMESTAMP '2026-01-15 11:50:00'),
    ('Mauricio', 'Pinto', 'mauricio.pinto@correo.test', '70010025', 'Av. Uyuni 88', 'Potosi', 'CI00000025', 'activo', TIMESTAMP '2026-01-15 12:00:00', NULL, 0.00, TIMESTAMP '2026-01-15 12:00:00'),
    ('Erika', 'Salinas', 'erika.salinas@correo.test', '70010026', 'Barrio Norte 605', 'Santa Cruz', 'CI00000026', 'activo', TIMESTAMP '2026-01-15 12:10:00', NULL, 0.00, TIMESTAMP '2026-01-15 12:10:00'),
    ('Ruben', 'Murillo', 'ruben.murillo@correo.test', '70010027', 'Av. Litoral 154', 'Sucre', 'CI00000027', 'activo', TIMESTAMP '2026-01-15 12:20:00', NULL, 0.00, TIMESTAMP '2026-01-15 12:20:00'),
    ('Paola', 'Cortez', 'paola.cortez@correo.test', '70010028', 'Calle Aroma 410', 'La Paz', 'CI00000028', 'activo', TIMESTAMP '2026-01-15 12:30:00', NULL, 0.00, TIMESTAMP '2026-01-15 12:30:00'),
    ('Nicolas', 'Choque', 'nicolas.choque@correo.test', '70010029', 'Zona Villa 29', 'El Alto', 'CI00000029', 'activo', TIMESTAMP '2026-01-15 12:40:00', NULL, 0.00, TIMESTAMP '2026-01-15 12:40:00'),
    ('Andrea', 'Mora', 'andrea.mora@correo.test', '70010030', 'Av. 6 de Marzo 132', 'El Alto', 'CI00000030', 'activo', TIMESTAMP '2026-01-15 12:50:00', NULL, 0.00, TIMESTAMP '2026-01-15 12:50:00')
ON CONFLICT (cedula_ruc) DO NOTHING;

-- ==========================================
-- 6. VENTAS
-- ==========================================
WITH base_ventas AS (
    SELECT
        gs,
        'FAC-202605-' || LPAD(gs::text, 3, '0') AS numero_factura,
        c.id_cliente,
        u.id_usuario,
        p.id_producto,
        p.precio_venta,
        TIMESTAMP '2026-05-01 09:00:00' + (gs - 1) * INTERVAL '2 hours' AS fecha_venta,
        ((gs - 1) % 4) + 1 AS cantidad,
        CASE
            WHEN gs % 5 = 0 THEN 10.00
            WHEN gs % 3 = 0 THEN 5.00
            ELSE 0.00
        END::numeric(5, 2) AS descuento_porcentaje,
        CASE
            WHEN gs % 4 = 0 THEN 'tarjeta'
            WHEN gs % 2 = 0 THEN 'transferencia'
            ELSE 'efectivo'
        END AS metodo_pago
    FROM generate_series(1, 30) AS gs
    JOIN public.clientes c
        ON c.cedula_ruc = 'CI' || LPAD(gs::text, 8, '0')
    JOIN public.usuarios u
        ON u.usuario = (
            ARRAY[
                'cmendoza','aflores','jrojas','mquispe','lgarcia',
                'pperez','rdiaz','slopez','aherrera','dtorrez',
                'fvargas','ncampos','ecastro','vortiz','ghuanca',
                'rcondori','jmamani','kgutierrez','ocallisaya','ybustillos',
                'hsalazar','caguilar','apadilla','lrivera','bmiranda',
                'msuarez','pnavarro','itarela','dvelasco','smedina'
            ]
        )[gs]
    JOIN public.productos p
        ON p.sku = 'SKU-' || LPAD(gs::text, 4, '0')
),
montos AS (
    SELECT
        gs,
        numero_factura,
        id_cliente,
        id_usuario,
        fecha_venta,
        metodo_pago,
        ROUND(cantidad * precio_venta, 2) AS bruto,
        descuento_porcentaje,
        ROUND((cantidad * precio_venta) * descuento_porcentaje / 100, 2) AS descuento_monto,
        ROUND((cantidad * precio_venta) - ROUND((cantidad * precio_venta) * descuento_porcentaje / 100, 2), 2) AS subtotal
    FROM base_ventas
)
INSERT INTO public.ventas (
    numero_factura,
    id_cliente,
    id_usuario,
    fecha_venta,
    subtotal,
    impuesto_porcentaje,
    impuesto_monto,
    total,
    monto_pagado,
    cambio,
    metodo_pago,
    estado,
    notas,
    fecha_actualizacion
)
SELECT
    numero_factura,
    id_cliente,
    id_usuario,
    fecha_venta,
    subtotal,
    12.00,
    ROUND(subtotal * 0.12, 2),
    ROUND(subtotal * 1.12, 2),
    ROUND(subtotal * 1.12, 2),
    0.00,
    metodo_pago,
    'completada',
    'Venta ejemplo ' || LPAD(gs::text, 3, '0'),
    fecha_venta
FROM montos
ON CONFLICT (numero_factura) DO NOTHING;

-- ==========================================
-- 7. DETALLE DE VENTAS
-- ==========================================
WITH base_detalle AS (
    SELECT
        gs,
        'FAC-202605-' || LPAD(gs::text, 3, '0') AS numero_factura,
        'SKU-' || LPAD(gs::text, 4, '0') AS sku,
        ((gs - 1) % 4) + 1 AS cantidad,
        CASE
            WHEN gs % 5 = 0 THEN 10.00
            WHEN gs % 3 = 0 THEN 5.00
            ELSE 0.00
        END::numeric(5, 2) AS descuento_porcentaje
    FROM generate_series(1, 30) AS gs
)
INSERT INTO public.detalle_ventas (
    id_venta,
    id_producto,
    cantidad,
    precio_unitario,
    descuento_porcentaje,
    descuento_monto,
    subtotal_item,
    fecha_actualizacion
)
SELECT
    v.id_venta,
    p.id_producto,
    bd.cantidad,
    p.precio_venta,
    bd.descuento_porcentaje,
    ROUND((bd.cantidad * p.precio_venta) * bd.descuento_porcentaje / 100, 2),
    ROUND(
        (bd.cantidad * p.precio_venta) -
        ROUND((bd.cantidad * p.precio_venta) * bd.descuento_porcentaje / 100, 2),
        2
    ),
    v.fecha_venta
FROM base_detalle bd
JOIN public.ventas v
    ON v.numero_factura = bd.numero_factura
JOIN public.productos p
    ON p.sku = bd.sku
WHERE NOT EXISTS (
    SELECT 1
    FROM public.detalle_ventas dv
    WHERE dv.id_venta = v.id_venta
      AND dv.id_producto = p.id_producto
);

-- ==========================================
-- 8. AJUSTE DE CLIENTES SEGUN VENTAS
-- ==========================================
UPDATE public.clientes c
SET
    total_compras = resumen.total_compras,
    fecha_ultima_compra = resumen.fecha_ultima_compra
FROM (
    SELECT
        id_cliente,
        ROUND(SUM(total), 2) AS total_compras,
        MAX(fecha_venta) AS fecha_ultima_compra
    FROM public.ventas
    GROUP BY id_cliente
) AS resumen
WHERE c.id_cliente = resumen.id_cliente;

COMMIT;

-- ==========================================
-- FIN DEL SEED
-- ==========================================
