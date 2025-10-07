from flask import jsonify, request, session
from models.reorderModel import HelloWorld, getUser, addUser, updateUser
from security import set_csrf_cookie, csrf_protect, generate_csrf_token

def set_response_headers(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    return response

def HelloWorldRoute():
    try:
        myresult = HelloWorld()
        response = jsonify(data=myresult)
        response = set_csrf_cookie(response)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400

@csrf_protect
def getUserRoute():
    try:
        myresult = getUser()
        response = jsonify(data=myresult)
        response = set_csrf_cookie(response)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400

@csrf_protect
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
    
def csrfTokenRoute():
    token = session.get('csrf_token') 
    if not token:
        token = generate_csrf_token()
    response = jsonify(csrf_token=token)
    response = set_csrf_cookie(response)
    response = set_response_headers(response) 
    return response, 200

@csrf_protect
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
