from bd import get_db_connection
from flask import jsonify

def getEvents():
    try:
        mydb = get_db_connection()
        mycursor = mydb.cursor(dictionary=True)
        mycursor.execute("SELECT * FROM event")
        myresult = mycursor.fetchall()
        mycursor.close()
        mydb.close()
        return myresult
    except Exception as e:
        return jsonify(error=str(e)), 400
    

def getEventById(event_id):
    try:
        mydb = get_db_connection()
        mycursor = mydb.cursor(dictionary=True)
        query = "SELECT * FROM event WHERE id = %s"
        mycursor.execute(query, (event_id,))
        myresult = mycursor.fetchone()
        mycursor.close()
        mydb.close()
        return myresult
    except Exception as e:
        return jsonify(error=str(e)), 400
    

def getEventByName(event_name):
    try:
        mydb = get_db_connection()
        mycursor = mydb.cursor(dictionary=True)
        query = "SELECT * FROM event WHERE name = %s"
        mycursor.execute(query, (event_name,))
        myresult = mycursor.fetchone()
        mycursor.close()
        mydb.close()
        return myresult
    except Exception as e:
        return jsonify(error=str(e)), 400