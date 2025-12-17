from bd import get_db_connection

def getTickets():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM `ticket`")
    myresult = cursor.fetchall()
    cursor.close()
    conn.close()
    return myresult

def getTicketById(ticket_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM `ticket` WHERE id = %s", (ticket_id,))
    myresult = cursor.fetchone()
    cursor.close()
    conn.close()
    if not myresult:
        raise Exception(f"Ticket avec l'ID {ticket_id} non trouvé.")
    return myresult

def getTicketsByEventId(event_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM `ticket` WHERE event_id = %s", (event_id,))
    myresult = cursor.fetchall()
    cursor.close()
    conn.close()
    if not myresult:
        raise Exception(f"Aucun ticket trouvé pour l'événement {event_id}.")
    return myresult

def getTicketsByUserId(user_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM `ticket` WHERE created_by = %s", (user_id,))
    myresult = cursor.fetchall()
    cursor.close()
    conn.close()
    if not myresult:
        raise Exception(f"Aucun ticket créé par l'utilisateur {user_id}.")
    return myresult