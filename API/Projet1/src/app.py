from flask import Flask, Response
from flask_cors import CORS
from routes.reorderRoutes import reorderBlueprint

app = Flask(__name__)
app.secret_key = "03583b1ffc8b89f24c79f79be63916f8"
app.config['SESSION_COOKIE_SECURE'] = True
app.config['SESSION_COOKIE_SAMESITE'] = 'Lax'
CORS(app)

app.register_blueprint(reorderBlueprint, url_prefix='/api')

@app.errorhandler(404)
def page_not_found(e):
    return Response("Not found !", status=404)

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
