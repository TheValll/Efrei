from flask import jsonify
from models.MessageModel import getMessages, getMessageById, getMessagesByThreadId, getMessagesByUserId
from controllers.response_controller import set_response_headers

def getMessagesRoute():
    try:
        myresult = getMessages()
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400

def getMessageByIdRoute(message_id):
    try:
        myresult = getMessageById(message_id)
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400

def getMessagesByThreadIdRoute(thread_id):
    try:
        myresult = getMessagesByThreadId(thread_id)
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400

def getMessagesByUserIdRoute(user_id):
    try:
        myresult = getMessagesByUserId(user_id)
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400
