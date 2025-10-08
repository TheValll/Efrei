from flask import Blueprint
from controllers.reorderController import (
    get_csrf_token,
    HelloWorldRoute,
    getUserRoute,
    addUserRoute,
    updateUserRoute,
)
from extension import limiter

reorderBlueprint = Blueprint('reorder', __name__)

@reorderBlueprint.route('/get-token', methods=['GET'])
@limiter.limit("2 per day")
def get_token():
    return get_csrf_token()

@reorderBlueprint.route('/', methods=['GET'])
@limiter.limit("5 per minute")
def hello_world():
    return HelloWorldRoute()

@reorderBlueprint.route('/users', methods=['GET'])
@limiter.limit("10 per minute")
def get_users():
    return getUserRoute()

@reorderBlueprint.route('/addUser', methods=['POST'])
@limiter.limit("3 per minute")
def add_user():
    return addUserRoute()

@reorderBlueprint.route('/updateUser/<int:user_id>', methods=['PUT'])
@limiter.limit("3 per minute")
def update_user(user_id):
    return updateUserRoute(user_id)
