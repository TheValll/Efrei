from bd import get_db_connection
from flask import jsonify

def getUsers():
    try:
        mydb = get_db_connection()
        mycursor = mydb.cursor(dictionary=True)
        mycursor.execute("SELECT * FROM user")
        myresult = mycursor.fetchall()
        mycursor.close()
        mydb.close()
        return myresult
    except Exception as e:
        return jsonify(error=str(e)), 400
    

def getUserById(user_id):
    try:
        mydb = get_db_connection()
        mycursor = mydb.cursor(dictionary=True)
        query = "SELECT * FROM user WHERE id = %s"
        mycursor.execute(query, (user_id,))
        myresult = mycursor.fetchone()
        mycursor.close()
        mydb.close()
        return myresult
    except Exception as e:
        return jsonify(error=str(e)), 400


def getUserByEmail(user_email):
    try:
        mydb = get_db_connection()
        mycursor = mydb.cursor(dictionary=True)
        query = "SELECT * FROM user WHERE email = %s"
        mycursor.execute(query, (user_email,))
        myresult = mycursor.fetchall()
        mycursor.close()
        mydb.close()
        return myresult
    except Exception as e:
        return jsonify(error=str(e)), 400

