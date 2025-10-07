from db import get_db_connection
from flask import jsonify

def HelloWorld():
    try:
        return "Hello World"
    except Exception as e:
        return jsonify(error=str(e)), 400

def getUser():
    try:
        mydb = get_db_connection()
        mycursor = mydb.cursor(dictionary=True)
        mycursor.execute("SELECT * FROM clients")
        myresult = mycursor.fetchall()
        mycursor.close()
        mydb.close()
        return myresult
    except Exception as e:
        return jsonify(error=str(e)), 400


def addUser(data):
    try:
        required_fields = ["firstname", "lastname", "age", "password", "bank_id"]
        for field in required_fields:
            if field not in data:
                return {"error": f"Missing field: {field}"}, 400

        mydb = get_db_connection()
        mycursor = mydb.cursor()
        sql = """
        INSERT INTO clients (firstname, lastname, age, password, address, city, zipcode, bank_id)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """
        values = (
            data.get("firstname"),
            data.get("lastname"),
            data.get("age"),
            data.get("password"),
            data.get("address"),
            data.get("city"),
            data.get("zipcode"),
            data.get("bank_id")
        )
        mycursor.execute(sql, values)
        mydb.commit()
        user_id = mycursor.lastrowid
        mycursor.close()
        mydb.close()
        return {"message": "User added", "id": user_id}, 201
    except Exception as e:
        return {"error": str(e)}, 400

def updateUser(user_id, data):
    try:
        allowed_fields = ["firstname", "lastname", "age", "password", "address", "city", "zipcode", "bank_id"]
        if not any(field in data for field in allowed_fields):
            return {"error": "No valid fields provided for update"}, 400

        mydb = get_db_connection()
        mycursor = mydb.cursor()
        set_clause = ", ".join(f"{field} = %s" for field in data if field in allowed_fields)
        values = tuple(data[field] for field in data if field in allowed_fields)
        sql = f"UPDATE clients SET {set_clause} WHERE id = %s"
        mycursor.execute(sql, values + (user_id,))
        mydb.commit()

        if mycursor.rowcount == 0:
            return {"error": "User not found"}, 404

        mycursor.close()
        mydb.close()
        return {"message": "User updated successfully"}, 200
    except Exception as e:
        return {"error": str(e)}, 400
