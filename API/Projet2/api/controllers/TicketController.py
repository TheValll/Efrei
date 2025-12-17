from flask import jsonify
from models.TicketModel import getTickets, getTicketById, getTicketsByEventId, getTicketsByUserId
from controllers.response_controller import set_response_headers

def getTicketsRoute():
    try:
        myresult = getTickets()
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400

def getTicketByIdRoute(ticket_id):
    try:
        myresult = getTicketById(ticket_id)
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400

def getTicketsByEventIdRoute(event_id):
    try:
        myresult = getTicketsByEventId(event_id)
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400

def getTicketsByUserIdRoute(user_id):
    try:
        myresult = getTicketsByUserId(user_id)
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400
