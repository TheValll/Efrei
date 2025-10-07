import os
from flask import Flask, request, jsonify, Response
from flask_cors import CORS
from routes.reorderRoutes import reorderBlueprint
from flask_wtf import CSRFProtect
from dotenv import load_dotenv
from db import get_db_connection
from flask import send_from_directory, render_template

app = Flask(__name__)
app.secret_key = "03583b1ffc8b89f24c79f79be63916f8"
app.config['SESSION_COOKIE_SECURE'] = True
app.config['SESSION_COOKIE_SAMESITE'] = 'Lax'
CORS(app)
load_dotenv()
API_KEY = os.getenv("API_KEY")

# csrf = CSRFProtect(app)

app.register_blueprint(reorderBlueprint, url_prefix='/api')


@app.route('/docs')
def docs():
    return render_template('docs.html')

@app.route('/static/openapi.json')
def openapi_spec():
    return send_from_directory('static', 'openapi.json')

@app.errorhandler(404)
def page_not_found(e):
    return Response("Not found !", status=404)

@app.before_request
def check_api_key():
    public_routes = ['/docs','/api', '/static/openapi.json']
    if request.path in public_routes:
        return

    api_key = request.headers.get("X-API-KEY")
    if not api_key:
        return jsonify({"error": "Missing API key"}), 401

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT id, username, permissions FROM users WHERE api_key = %s", (api_key,))
    user = cursor.fetchone()

    if not user:
        cursor.close()
        conn.close()
        return jsonify({"error": "Invalid API key"}), 403
    
    route_perm_map = {
        '/api/users': 'view_users',
        '/api/addUser': 'add_user',
        '/api/updateUser': 'update_user'
    }

    for route_prefix, perm in route_perm_map.items():
        if request.path.startswith(route_prefix):
            perms = user["permissions"]
            if perms is None or perm not in perms:
                cursor.close()
                conn.close()
                return jsonify({"error": "Access denied: insufficient permissions"}), 403

    cursor.close()
    conn.close()

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
