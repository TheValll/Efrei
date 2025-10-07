from flask import Blueprint
from controllers.reorderController import HelloWorldRoute, getUserRoute, addUserRoute, updateUserRoute

reorderBlueprint = Blueprint('reorder', __name__)

reorderBlueprint.route('/', methods=['GET'])(HelloWorldRoute)
reorderBlueprint.route('/users', methods=['GET'])(getUserRoute)
reorderBlueprint.route('/addUser', methods=['POST'])(addUserRoute)
reorderBlueprint.route('/updateUser/<int:user_id>', methods=['PUT'])(updateUserRoute)
