from bd import get_db_connection
from flask import jsonify

def getThreads():
    try:
        mydb = get_db_connection()
        mycursor = mydb.cursor(dictionary=True)
        mycursor.execute("SELECT * FROM thread")
        myresult = mycursor.fetchall()
        mycursor.close()
        mydb.close()
        return myresult
    except Exception as e:
        return jsonify(error=str(e)), 400

def getThreadById(thread_id):
    try:
        mydb = get_db_connection()
        mycursor = mydb.cursor(dictionary=True)
        query = "SELECT * FROM thread WHERE id = %s"
        mycursor.execute(query, (thread_id,))
        myresult = mycursor.fetchone()
        mycursor.close()
        mydb.close()
        return myresult
    except Exception as e:
        return jsonify(error=str(e)), 400
    
def getThreadByName(thread_name):
    try:
        mydb = get_db_connection()
        mycursor = mydb.cursor(dictionary=True)
        query = "SELECT * FROM thread WHERE thread_name = %s"
        mycursor.execute(query, (thread_name,))
        myresult = mycursor.fetchone()
        mycursor.close()
        mydb.close()
        return myresult
    except Exception as e:
        return jsonify(error=str(e)), 400