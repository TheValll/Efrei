from flask import jsonify, request
from flask_wtf.csrf import generate_csrf
from models.reorderModel import HelloWorld, getUser, addUser, updateUser

def set_response_headers(response):
    response.headers.add('Access-Control-Allow-Origin', 'https://127.0.0.1:5000')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type, X-CSRFToken')
    response.headers.add('Access-Control-Allow-Methods', 'GET, POST, PUT')
    response.headers['Strict-Transport-Security'] = 'max-age=31536000; includeSubDomains'
    response.headers['Content-Security-Policy'] = "default-src 'self'"
    response.headers['X-Content-Type-Options'] = 'nosniff'
    response.headers['X-Frame-Options'] = 'SAMEORIGIN'
    return response

def get_csrf_token():
    return jsonify({"csrf_token": generate_csrf()})

def HelloWorldRoute():
    try:
        myresult = HelloWorld()
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400

def getUserRoute():
    try:
        myresult = getUser()
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400

def addUserRoute():
    try:
        data = request.args.to_dict()
        if not data:
            return jsonify(error="JSON body missing"), 400
        result, status = addUser(data)
        response = jsonify(result)
        return set_response_headers(response), status
    except Exception as e:
        return jsonify(error=str(e)), 400

def updateUserRoute(user_id):
    try:
        if not user_id:
            return jsonify(error="User ID is required"), 400
        
        data = request.args.to_dict()
        if not data:
            return jsonify(error="JSON body missing"), 400

        result, status = updateUser(user_id, data)
        response = jsonify(result)
        return set_response_headers(response), status
    except Exception as e:
        return jsonify(error=str(e)), 400
