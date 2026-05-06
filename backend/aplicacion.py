"""
MiniSuper API - Conexión real a PostgreSQL
"""

from flask import Flask, jsonify, request
from flask_cors import CORS
import subprocess
import os
import json
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)
CORS(app)

class FormatoDecimalJSON(json.JSONEncoder):
    def encode(self, o):
        if isinstance(o, dict):
            return json.dumps({k: self._format_value(v) for k, v in o.items()})
        return super().encode(o)
    
    def _format_value(self, v):
        if isinstance(v, float):
            return float(f"{v:.2f}")
        elif isinstance(v, dict):
            return {k: self._format_value(val) for k, val in v.items()}
        elif isinstance(v, list):
            return [self._format_value(item) for item in v]
        return v

app.json_encoder = FormatoDecimalJSON

DB_HOST = os.getenv('DB_HOST', 'localhost')
DB_PORT = os.getenv('DB_PORT', '5432')
DB_NAME = os.getenv('DB_NAME', 'minisuper')
DB_USER = os.getenv('DB_USER', 'postgres')
DB_PASSWORD = os.getenv('DB_PASSWORD', 'Upds123')

def query_db(sql):
    """Ejecuta query en PostgreSQL usando psql"""
    env = os.environ.copy()
    env['PGPASSWORD'] = DB_PASSWORD
    
    cmd = [
        'C:\\Program Files\\PostgreSQL\\18\\bin\\psql',
        '-U', DB_USER,
        '-h', DB_HOST,
        '-d', DB_NAME,
        '-t', '-A',
        '-F', '|',
        '-c', sql
    ]
    
    try:
        result = subprocess.run(cmd, env=env, capture_output=True, text=True, timeout=5)
        if result.returncode == 0:
            return result.stdout.strip()
        else:
            return None
    except Exception as e:
        print(f"Error: {e}")
        return None

def parse_rows(output):
    """Convierte salida de psql en lista de dicts"""
    if not output:
        return []
    
    rows = []
    for line in output.split('\n'):
        if line.strip():
            values = line.split('|')
            rows.append(values)
    return rows

@app.route('/api/health', methods=['GET'])
def health():
    return jsonify({
        'status': 'ok',
        'message': 'API conectada a PostgreSQL',
        'database': DB_NAME,
        'endpoints': {
            'GET': ['/api/categorias', '/api/productos', '/api/clientes', '/api/ventas']
        }
    }), 200

@app.route('/api/categorias', methods=['GET'])
def get_categorias():
    sql = "SELECT id_categoria, nombre, descripcion FROM public.categorias WHERE estado='activo' LIMIT 10;"
    result = query_db(sql)
    rows = parse_rows(result)
    
    data = []
    for row in rows:
        if len(row) >= 3:
            data.append({
                'id_categoria': int(row[0]),
                'nombre': row[1],
                'descripcion': row[2]
            })
    
    return jsonify({'success': True, 'data': data, 'count': len(data)}), 200

@app.route('/api/productos', methods=['GET'])
def get_productos():
    sql = """
    SELECT p.id_producto, p.nombre, p.precio_venta, p.stock_actual, c.nombre 
    FROM public.productos p
    JOIN public.categorias c ON p.id_categoria = c.id_categoria
    WHERE p.estado='activo' LIMIT 10;
    """
    result = query_db(sql)
    rows = parse_rows(result)
    
    data = []
    for row in rows:
        if len(row) >= 5:
            precio = float(row[2])
            data.append({
                'id_producto': int(row[0]),
                'nombre': row[1],
                'precio_venta': f"{precio:.2f}",
                'stock_actual': int(row[3]),
                'categoria_nombre': row[4]
            })
    
    return jsonify({'success': True, 'data': data, 'count': len(data)}), 200

@app.route('/api/productos/<int:id>', methods=['PUT'])
def actualizar_producto(id):
    datos = request.get_json()
    
    if not datos or 'precio_venta' not in datos:
        return jsonify({'success': False, 'error': 'Requiere: {"precio_venta": 19.50}'}), 400
    
    precio = datos['precio_venta']
    sql = f"UPDATE public.productos SET precio_venta = {precio} WHERE id_producto = {id};"
    
    result = query_db(sql)
    if result is not None:
        return jsonify({'success': True, 'mensaje': f'Producto {id} actualizado a {precio}'}), 200
    else:
        return jsonify({'success': False, 'error': 'Error al actualizar'}), 500

@app.route('/api/clientes', methods=['GET'])
def get_clientes():
    sql = "SELECT id_cliente, nombre, apellido, ci_nit, email, telefono FROM public.clientes WHERE estado='activo' LIMIT 10;"
    result = query_db(sql)
    rows = parse_rows(result)
    
    data = []
    for row in rows:
        if len(row) >= 6:
            data.append({
                'id_cliente': int(row[0]),
                'nombre': row[1],
                'apellido': row[2],
                'ci_nit': row[3],
                'email': row[4],
                'telefono': row[5]
            })
    
    return jsonify({'success': True, 'data': data, 'count': len(data), 'importante': 'CI/NIT es único por cliente'}), 200

@app.route('/api/ventas', methods=['GET'])
def get_ventas():
    sql = """
    SELECT v.id_venta, v.numero_factura, CONCAT(c.nombre,' ',c.apellido) as cliente, 
           v.total, v.fecha_venta
    FROM public.ventas v
    JOIN public.clientes c ON v.id_cliente = c.id_cliente
    WHERE v.estado='completada' LIMIT 10;
    """
    result = query_db(sql)
    rows = parse_rows(result)
    
    data = []
    for row in rows:
        if len(row) >= 5:
            data.append({
                'id_venta': int(row[0]),
                'numero_factura': row[1],
                'cliente': row[2],
                'total': float(row[3]),
                'fecha_venta': row[4]
            })
    
    return jsonify({'success': True, 'data': data, 'count': len(data)}), 200

if __name__ == '__main__':
    print("\n" + "="*60)
    print("🚀 MiniSuper API - Conexión Real a PostgreSQL")
    print("="*60)
    print(f"Database: {DB_NAME}")
    print(f"Host: {DB_HOST}:{DB_PORT}")
    print(f"User: {DB_USER}")
    print("="*60 + "\n")
    app.run(host='127.0.0.1', port=5000, debug=False)
