import secrets
from functools import wraps
from flask import request, session, jsonify, abort, current_app, make_response

CSRF_COOKIE_NAME = "csrf_token"
CSRF_HEADER_NAME = "X-CSRF-Token"

def generate_csrf_token():
    token = secrets.token_urlsafe(32)
    session['csrf_token'] = token
    return token

def set_csrf_cookie(response):
    token = session.get('csrf_token') or generate_csrf_token()
    response.set_cookie(
        CSRF_COOKIE_NAME,
        token,
        samesite='Lax',
        secure=current_app.config.get("SESSION_COOKIE_SECURE", False),
        httponly=False,
        max_age=60*60*24 
    )
    return response


CSRF_HEADER_NAME = "X-CSRF-Token"

def verify_csrf():
    header_token = request.headers.get(CSRF_HEADER_NAME)
    session_token = session.get('csrf_token')
    return header_token is not None and header_token == session_token

def csrf_protect(view_func):
    @wraps(view_func)
    def wrapper(*args, **kwargs):
        if not verify_csrf():
            return jsonify(error="CSRF token missing or invalid"), 403
        return view_func(*args, **kwargs)
    return wrapper

