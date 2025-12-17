from flask import jsonify
from models.ProductModel import getProducts, getProductById, getProductByName, getProductsByEventId, getProductsByUserId
from controllers.response_controller import set_response_headers

def getProductsRoute():
    try:
        myresult = getProducts()
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400

def getProductByIdRoute(product_id):
    try:
        myresult = getProductById(product_id)
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400

def getProductByNameRoute(product_name):
    try:
        myresult = getProductByName(product_name)
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400

def getProductsByEventIdRoute(event_id):
    try:
        myresult = getProductsByEventId(event_id)
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400

def getProductsByUserIdRoute(user_id):
    try:
        myresult = getProductsByUserId(user_id)
        response = jsonify(data=myresult)
        response = set_response_headers(response)
        return response, 200
    except Exception as e:
        return jsonify(error=str(e)), 400
