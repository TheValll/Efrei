from flask import jsonify
from models.ThreadModel import getThreads, getThreadById, getThreadByName
from controllers.response_controller import set_response_headers

def getThreadsRoute():
    try:
        myresult = getThreads()
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400
    
def getThreadByIdRoute(thread_id):
    try:
        myresult = getThreadById(thread_id)
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400
    

def getThreadByNameRoute(thread_name):
    try:
        myresult = getThreadByName(thread_name)
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400