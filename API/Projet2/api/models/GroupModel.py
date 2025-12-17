from bd import get_db_connection

def getGroups():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM `group`")
    myresult = cursor.fetchall()
    cursor.close()
    conn.close()
    return myresult

def getGroupById(group_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM `group` WHERE id = %s", (group_id,))
    myresult = cursor.fetchone()
    cursor.close()
    conn.close()
    if not myresult:
        raise Exception(f"Groupe avec l'ID {group_id} non trouvé.")
    return myresult

def getGroupByName(group_name):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM `group` WHERE name = %s", (group_name,))
    myresult = cursor.fetchone()
    cursor.close()
    conn.close()
    if not myresult:
        raise Exception(f"Groupe avec le nom '{group_name}' non trouvé.")
    return myresult

def getGroupsByUserId(user_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM `group` WHERE created_by = %s", (user_id,))
    myresult = cursor.fetchall()
    cursor.close()
    conn.close()
    if not myresult:
        raise Exception(f"Aucun groupe créé par l'utilisateur {user_id}.")
    return myresult
