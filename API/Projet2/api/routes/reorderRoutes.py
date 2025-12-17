from flask import Blueprint, request, jsonify
from controllers.HelloWorldController import HelloWorldRoute
from controllers.CsrfController import get_csrf_token
from controllers.UserController import getUsersRoute, getUserByIdRoute, getUserByEmailRoute
from controllers.EventController import getEventsRoute, getEventByIdRoute, getEventByNameRoute
from controllers.ThreadsController import getThreadsRoute, getThreadByIdRoute, getThreadByNameRoute
from controllers.GroupController import getGroupsRoute, getGroupByIdRoute, getGroupByNameRoute, getGroupsByUserIdRoute
from controllers.MessageController import getMessagesRoute, getMessageByIdRoute, getMessagesByThreadIdRoute, getMessagesByUserIdRoute
from controllers.ProductController import getProductsRoute, getProductByIdRoute, getProductByNameRoute, getProductsByEventIdRoute, getProductsByUserIdRoute
from controllers.TicketController import getTicketsRoute, getTicketByIdRoute, getTicketsByEventIdRoute, getTicketsByUserIdRoute
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


# --------------------- THREADS --------------------- #

@reorderBlueprint.route('/threads', methods=['GET'])
@limiter.limit("10 per minute")
def get_threads():
    return getThreadsRoute()

@reorderBlueprint.route('/thread-id', methods=['GET'])
@limiter.limit("10 per minute")
def get_thread_by_id():
    thread_id = request.args.get('thread_id', type=int)
    if not thread_id:
        return jsonify(error="Le paramètre 'thread_id' est manquant ou invalide."), 400
    return getThreadByIdRoute(thread_id)

@reorderBlueprint.route('/thread-name', methods=['GET'])
@limiter.limit("10 per minute")
def get_thread_by_name():
    thread_name = request.args.get('thread_name', type=str)
    if not thread_name:
        return jsonify(error="Le paramètre 'thread_name' est manquant ou invalide."), 400
    return getThreadByNameRoute(thread_name)


# --------------------- GROUPS --------------------- #

@reorderBlueprint.route('/groups', methods=['GET'])
@limiter.limit("10 per minute")
def get_groups():
    return getGroupsRoute()

@reorderBlueprint.route('/group-id', methods=['GET'])
@limiter.limit("10 per minute")
def get_group_by_id():
    group_id = request.args.get('group_id', type=int)
    if not group_id:
        return jsonify(error="Le paramètre 'group_id' est manquant ou invalide."), 400
    return getGroupByIdRoute(group_id)

@reorderBlueprint.route('/group-name', methods=['GET'])
@limiter.limit("10 per minute")
def get_group_by_name():
    group_name = request.args.get('group_name', type=str)
    if not group_name:
        return jsonify(error="Le paramètre 'group_name' est manquant ou invalide."), 400
    return getGroupByNameRoute(group_name)

@reorderBlueprint.route('/groups-user', methods=['GET'])
@limiter.limit("10 per minute")
def get_groups_by_user():
    user_id = request.args.get('user_id', type=int)
    if not user_id:
        return jsonify(error="Le paramètre 'user_id' est manquant ou invalide."), 400
    return getGroupsByUserIdRoute(user_id)


# --------------------- MESSAGES --------------------- #

@reorderBlueprint.route('/messages', methods=['GET'])
@limiter.limit("10 per minute")
def get_messages():
    return getMessagesRoute()

@reorderBlueprint.route('/message-id', methods=['GET'])
@limiter.limit("10 per minute")
def get_message_by_id():
    message_id = request.args.get('message_id', type=int)
    if not message_id:
        return jsonify(error="Le paramètre 'message_id' est manquant ou invalide."), 400
    return getMessageByIdRoute(message_id)

@reorderBlueprint.route('/messages-thread', methods=['GET'])
@limiter.limit("10 per minute")
def get_messages_by_thread():
    thread_id = request.args.get('thread_id', type=int)
    if not thread_id:
        return jsonify(error="Le paramètre 'thread_id' est manquant ou invalide."), 400
    return getMessagesByThreadIdRoute(thread_id)

@reorderBlueprint.route('/messages-user', methods=['GET'])
@limiter.limit("10 per minute")
def get_messages_by_user():
    user_id = request.args.get('user_id', type=int)
    if not user_id:
        return jsonify(error="Le paramètre 'user_id' est manquant ou invalide."), 400
    return getMessagesByUserIdRoute(user_id)


# --------------------- PRODUCTS --------------------- #

@reorderBlueprint.route('/products', methods=['GET'])
@limiter.limit("10 per minute")
def get_products():
    return getProductsRoute()

@reorderBlueprint.route('/product-id', methods=['GET'])
@limiter.limit("10 per minute")
def get_product_by_id():
    product_id = request.args.get('product_id', type=int)
    if not product_id:
        return jsonify(error="Le paramètre 'product_id' est manquant ou invalide."), 400
    return getProductByIdRoute(product_id)

@reorderBlueprint.route('/product-name', methods=['GET'])
@limiter.limit("10 per minute")
def get_product_by_name():
    product_name = request.args.get('product_name', type=str)
    if not product_name:
        return jsonify(error="Le paramètre 'product_name' est manquant ou invalide."), 400
    return getProductByNameRoute(product_name)

@reorderBlueprint.route('/products-event', methods=['GET'])
@limiter.limit("10 per minute")
def get_products_by_event():
    event_id = request.args.get('event_id', type=int)
    if not event_id:
        return jsonify(error="Le paramètre 'event_id' est manquant ou invalide."), 400
    return getProductsByEventIdRoute(event_id)

@reorderBlueprint.route('/products-user', methods=['GET'])
@limiter.limit("10 per minute")
def get_products_by_user():
    user_id = request.args.get('user_id', type=int)
    if not user_id:
        return jsonify(error="Le paramètre 'user_id' est manquant ou invalide."), 400
    return getProductsByUserIdRoute(user_id)


# --------------------- TICKETS --------------------- #

@reorderBlueprint.route('/tickets', methods=['GET'])
@limiter.limit("10 per minute")
def get_tickets():
    return getTicketsRoute()

@reorderBlueprint.route('/ticket-id', methods=['GET'])
@limiter.limit("10 per minute")
def get_ticket_by_id():
    ticket_id = request.args.get('ticket_id', type=int)
    if not ticket_id:
        return jsonify(error="Le paramètre 'ticket_id' est manquant ou invalide."), 400
    return getTicketByIdRoute(ticket_id)

@reorderBlueprint.route('/tickets-event', methods=['GET'])
@limiter.limit("10 per minute")
def get_tickets_by_event():
    event_id = request.args.get('event_id', type=int)
    if not event_id:
        return jsonify(error="Le paramètre 'event_id' est manquant ou invalide."), 400
    return getTicketsByEventIdRoute(event_id)

@reorderBlueprint.route('/tickets-user', methods=['GET'])
@limiter.limit("10 per minute")
def get_tickets_by_user():
    user_id = request.args.get('user_id', type=int)
    if not user_id:
        return jsonify(error="Le paramètre 'user_id' est manquant ou invalide."), 400
    return getTicketsByUserIdRoute(user_id)