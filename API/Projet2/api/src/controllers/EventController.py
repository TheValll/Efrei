from flask import jsonify
from models.EventModel import getEvents, getEventById, getEventByName
from controllers.response_controller import set_response_headers

def getEventsRoute():
    try:
        myresult = getEvents()
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400
    

def getEventByIdRoute(event_id):
    try:
        myresult = getEventById(event_id)
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400
    

def getEventByNameRoute(event_name):
    try:
        myresult = getEventByName(event_name)
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400
    