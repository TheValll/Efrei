from flask import jsonify
from models.UserModel import getUsers, getUserById, getUserByEmail
from controllers.response_controller import set_response_headers

def getUsersRoute():
    try:
        myresult = getUsers()
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400
    

def getUserByIdRoute(user_id):
    try:
        myresult = getUserById(user_id)
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400
    
def getUserByEmailRoute(user_email):
    try:
        myresult = getUserByEmail(user_email)
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400