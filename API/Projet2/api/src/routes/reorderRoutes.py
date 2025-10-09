from flask import Blueprint, request, jsonify
from controllers.HelloWorldController import HelloWorldRoute
from controllers.CsrfController import get_csrf_token
from controllers.UserController import getUsersRoute, getUserByIdRoute, getUserByEmailRoute
from controllers.EventController import getEventsRoute, getEventByIdRoute, getEventByNameRoute
from extension import limiter

reorderBlueprint = Blueprint('reorder', __name__)

@reorderBlueprint.route('/', methods=['GET'])
@limiter.limit("5 per minute")
def hello_world():
    return HelloWorldRoute()

@reorderBlueprint.route('/get-token', methods=['GET'])
@limiter.limit("2 per day")
def get_token():
    return get_csrf_token()

# --------------------- USERS --------------------- #

@reorderBlueprint.route('/users', methods=['GET'])
@limiter.limit("10 per minute")
def get_users():
    return getUsersRoute()

@reorderBlueprint.route('/user-id', methods=['GET'])
@limiter.limit("3 per minute")
def get_user_by_id():
    user_id = request.args.get('user_id', type=int)
    if not user_id:
        return jsonify(error="Le paramètre 'user_id' est manquant ou invalide."), 400
    return getUserByIdRoute(user_id)

@reorderBlueprint.route('/user-email', methods=['GET'])
@limiter.limit("3 per minute")
def get_user_by_email():
    user_email = request.args.get('user_email', type=str)
    if not user_email:
        return jsonify(error="Le paramètre 'user_email' est manquant ou invalide."), 400
    return getUserByEmailRoute(user_email)

# --------------------- EVENTS --------------------- #

@reorderBlueprint.route('/events', methods=['GET'])
@limiter.limit("10 per minute")
def get_events():
    return getEventsRoute()

@reorderBlueprint.route('/event-id', methods=['GET'])
@limiter.limit("10 per minute")
def get_event_by_id():
    event_id = request.args.get('event_id', type=int)
    if not event_id:
        return jsonify(error="Le paramètre 'event_id' est manquant ou invalide."), 400
    return getEventByIdRoute(event_id)

@reorderBlueprint.route('/event-name', methods=['GET'])
@limiter.limit("10 per minute")
def get_event_by_name():
    event_name = request.args.get('event_name', type=str)
    if not event_name:
        return jsonify(error="Le paramètre 'event_name' est manquant ou invalide."), 400
    return getEventByNameRoute(event_name)