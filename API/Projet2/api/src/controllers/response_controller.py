def set_response_headers(response):
    response.headers.add('Access-Control-Allow-Origin', 'https://127.0.0.1:5000')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type, X-CSRFToken')
    response.headers.add('Access-Control-Allow-Methods', 'GET, POST, PUT')
    response.headers['Strict-Transport-Security'] = 'max-age=31536000; includeSubDomains'
    response.headers['Content-Security-Policy'] = "default-src 'self'"
    response.headers['X-Content-Type-Options'] = 'nosniff'
    response.headers['X-Frame-Options'] = 'SAMEORIGIN'
    return response