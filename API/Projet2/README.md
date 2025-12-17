# API REST - Documentation

## Structure et Architecture

La base de données est basée sur le modèle conceptuel de données (MCD) disponible dans le dossier assets. Vous pouvez l'ouvrir avec JMerise : https://www.jfreesoft.com/JMerise/index.php

L'API suit le pattern MVC (Model-View-Controller).

## Fonctionnalités

L'API intègre les fonctionnalités suivantes :

- CORS
- CSRF TOKEN
- Système de permissions
- Gestion par clé API

## API Key Permissions

SQL Schema for Users and Permissions
CREATE TABLE IF NOT EXISTS users (
id INT AUTO_INCREMENT PRIMARY KEY,
username VARCHAR(100) NOT NULL UNIQUE,
password_hash VARCHAR(255) NOT NULL,
api_key VARCHAR(255) NOT NULL UNIQUE,
role ENUM('admin', 'editor', 'viewer') DEFAULT 'viewer',
permissions JSON DEFAULT NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Example users with roles and permissions
INSERT INTO users (username, password_hash, api_key, role, permissions) VALUES
('admin', SHA2('admin123', 256), 'APIKEY-ADMIN-12345', 'admin', JSON_ARRAY('view_users', 'add_user', 'update_user')),
('editor', SHA2('editor123', 256), 'APIKEY-EDITOR-55555', 'editor', JSON_ARRAY('view_users', 'add_user')),
('viewer', SHA2('viewer123', 256), 'APIKEY-VIEWER-67890', 'viewer', JSON_ARRAY('view_users'));

How Permissions Work
Each API key is associated with a role (admin, editor, viewer).
Each role has a set of permissions stored as a JSON array in the permissions column.
When a request is made, the API checks:
If the X-API-KEY header is present.
If the key exists in the users table.
If the key has the required permission for the requested endpoint.
Example permission check in Python:

def check_permission(api_key, required_permission):
conn = get_db_connection()
cursor = conn.cursor(dictionary=True)
cursor.execute("SELECT permissions FROM users WHERE api_key = %s", (api_key,))
user = cursor.fetchone()
if not user:
return False
permissions = json.loads(user['permissions'])
return required_permission in permissions

![Modèle de données](assets/MCD.png)

## Installation et Démarrage

### 1. Cloner le repository

```bash
git clone https://github.com/TheValll/Efrei/tree/main/API/Projet2
cd Projet2
```

### 2. Créer le fichier .env

Créez un fichier `.env` avec les variables suivantes :

```
MYSQL_ROOT_PASSWORD=rootpass
MYSQL_DATABASE=flaskdb
MYSQL_USER=flaskuser
MYSQL_PASSWORD=flaskpass
SECRET_KEY=random_long_stable_string
```

Remplacez la `SECRET_KEY` par une chaîne aléatoire sécurisée. Vous pouvez en générer une ici : https://onlinehashtools.com/generate-random-sha256-hash

### 3. Générer un certificat SSL

```bash
cd api
& "C:\Program Files\Git\usr\bin\openssl.exe" req -x509 -newkey rsa:4096 -nodes -out cert.pem -keyout key.pem -days 3650
```

### 4. Lancer les conteneurs Docker

```bash
cd ..
docker compose up --build
```

## Accès aux services

Après le démarrage, les services sont accessibles à :

- Flask API : http://localhost:5000
- phpMyAdmin : http://localhost:8080
- Base de données MySQL : db:3306 (accès interne)

### 5. Initialiser la base de données

1. Accédez à http://localhost:8080
2. Connectez-vous avec les identifiants configurés
3. Importez le fichier SQL du dossier assets

### 6. Générer un jeton API

```bash
curl -H "X-API-KEY: APIKEY-VIEWER-67890" https://127.0.0.1:5000/api/get-token
```

### 7. Tester l'API

Utilisez la collection Postman fournie dans le dossier assets pour tester l'API.
