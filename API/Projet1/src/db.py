import mysql.connector
import os
import mysql.connector

def get_db_connection():
    return mysql.connector.connect(
        host=os.getenv("MYSQL_HOST", "db"),
        user=os.getenv("MYSQL_USER", "flaskuser"),
        password=os.getenv("MYSQL_PASSWORD", "flaskpass"),
        database=os.getenv("MYSQL_DATABASE", "event_management")
    )