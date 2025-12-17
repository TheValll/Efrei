from flask import jsonify
from models.GroupModel import getGroups, getGroupById, getGroupByName, getGroupsByUserId
from controllers.response_controller import set_response_headers

def getGroupsRoute():
    try:
        myresult = getGroups()
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400

def getGroupByIdRoute(group_id):
    try:
        myresult = getGroupById(group_id)
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400

def getGroupByNameRoute(group_name):
    try:
        myresult = getGroupByName(group_name)
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400

def getGroupsByUserIdRoute(user_id):
    try:
        myresult = getGroupsByUserId(user_id)
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400
