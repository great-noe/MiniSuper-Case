"""MiniSuper POS"""
from flask import Flask
from flask_cors import CORS
from app.presentation.routes.api import api_blueprint

app = Flask(__name__)
CORS(app)

app.register_blueprint(api_blueprint)

if __name__ == '__main__':
    app.run(debug=False, host='127.0.0.1', port=5000)
