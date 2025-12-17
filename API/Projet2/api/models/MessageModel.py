from bd import get_db_connection

def getMessages():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM `message`")
    myresult = cursor.fetchall()
    cursor.close()
    conn.close()
    return myresult

def getMessageById(message_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM `message` WHERE id = %s", (message_id,))
    myresult = cursor.fetchone()
    cursor.close()
    conn.close()
    if not myresult:
        raise Exception(f"Message avec l'ID {message_id} non trouvé.")
    return myresult

def getMessagesByThreadId(thread_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM `message` WHERE thread_id = %s", (thread_id,))
    myresult = cursor.fetchall()
    cursor.close()
    conn.close()
    if not myresult:
        raise Exception(f"Aucun message trouvé pour le thread {thread_id}.")
    return myresult

def getMessagesByUserId(user_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM `message` WHERE created_by = %s", (user_id,))
    myresult = cursor.fetchall()
    cursor.close()
    conn.close()
    if not myresult:
        raise Exception(f"Aucun message créé par l'utilisateur {user_id}.")
    return myresult