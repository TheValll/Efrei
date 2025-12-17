from bd import get_db_connection

def getProducts():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM `product`")
    myresult = cursor.fetchall()
    cursor.close()
    conn.close()
    return myresult

def getProductById(product_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM `product` WHERE id = %s", (product_id,))
    myresult = cursor.fetchone()
    cursor.close()
    conn.close()
    if not myresult:
        raise Exception(f"Produit avec l'ID {product_id} non trouvé.")
    return myresult

def getProductByName(product_name):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM `product` WHERE name = %s", (product_name,))
    myresult = cursor.fetchone()
    cursor.close()
    conn.close()
    if not myresult:
        raise Exception(f"Produit avec le nom '{product_name}' non trouvé.")
    return myresult

def getProductsByEventId(event_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM `product` WHERE event_id = %s", (event_id,))
    myresult = cursor.fetchall()
    cursor.close()
    conn.close()
    if not myresult:
        raise Exception(f"Aucun produit trouvé pour l'événement {event_id}.")
    return myresult

def getProductsByUserId(user_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM `product` WHERE created_by = %s", (user_id,))
    myresult = cursor.fetchall()
    cursor.close()
    conn.close()
    if not myresult:
        raise Exception(f"Aucun produit créé par l'utilisateur {user_id}.")
    return myresult