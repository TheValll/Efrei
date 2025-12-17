1. git clone https://github.com/TheValll/Efrei/tree/main/API/Projet2
2. cd Projet2
3. Create the .env file
   MYSQL_ROOT_PASSWORD=rootpass
   MYSQL_DATABASE=flaskdb
   MYSQL_USER=flaskuser
   MYSQL_PASSWORD=flaskpass
   SECRET_KEY=random_long_stable_string
4. Create a SSL certificate
   cd api
   & "C:\Program Files\Git\usr\bin\openssl.exe" req -x509 -newkey rsa:4096 -nodes -out cert.pem -keyout key.pem -days 3650

5. Build and start the containers
   cd ..
   docker compose up --build

Flask API → http://localhost:5000
phpMyAdmin → http://localhost:8080
MySQL database → accessible internally as db:3306

6. Go to http://localhost:8080
   Connect you
   Add the SQL file in the database

7. Generate your API token
   curl -H "X-API-KEY: APIKEY-VIEWER-67890" https://127.0.0.1:5000/api/get-token
