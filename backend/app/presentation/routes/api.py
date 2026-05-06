"""API Routes"""
from flask import Blueprint, jsonify

api_blueprint = Blueprint('api', __name__, url_prefix='/api')

@api_blueprint.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'ok'}), 200
