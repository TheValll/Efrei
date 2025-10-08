from flask import Blueprint
from controllers.reorderController import get_csrf_token, HelloWorldRoute, getUserRoute, addUserRoute, updateUserRoute

reorderBlueprint = Blueprint('reorder', __name__)

reorderBlueprint.route('/get-token', methods=['GET'])(get_csrf_token)
reorderBlueprint.route('/', methods=['GET'])(HelloWorldRoute)
reorderBlueprint.route('/users', methods=['GET'])(getUserRoute)
reorderBlueprint.route('/addUser', methods=['POST'])(addUserRoute)
reorderBlueprint.route('/updateUser/<int:user_id>', methods=['PUT'])(updateUserRoute)
