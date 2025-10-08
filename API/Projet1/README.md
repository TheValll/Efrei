# 🚀 Flask + MySQL + Docker + phpMyAdmin API

README written with chatGPT

This project is a **Flask REST API** connected to a **MySQL database**, containerized with **Docker Compose**, and includes **phpMyAdmin**. It features **API key authentication** and **role-based permissions** for secure access.

---

## 🧩 Project Architecture

```
project-root/
│
├── .env
├── docker-compose.yml
├── Dockerfile
├── requirements.txt
└── src/
    ├── app.py
    ├── db.py
    ├── routes/
    │   └── reorderRoutes.py
    ├── controllers/
    │   └── reorderController.py
    └── models/
        └── reorderModel.py
```

### 🔍 Folder Overview

| Folder/File            | Purpose                                                                              |
| ---------------------- | ------------------------------------------------------------------------------------ |
| **app.py**             | Main Flask entry point, API initialization, route registration, API key verification |
| **db.py**              | Handles database connection using environment variables                              |
| **routes/**            | Defines Flask endpoints and connects them to controllers                             |
| **controllers/**       | Manages API logic (receives requests, calls models, returns JSON responses)          |
| **models/**            | Handles database queries and CRUD operations                                         |
| **.env**               | Stores MySQL credentials and API keys used by Docker services                        |
| **Dockerfile**         | Defines how the Flask API container is built                                         |
| **docker-compose.yml** | Orchestrates all containers (Flask API, MySQL, phpMyAdmin)                           |

---

## ⚙️ How It Works

### 🧱 Flask Application (`src/app.py`)

- The API is built with Flask and organized using **Blueprints**.
- Loads environment variables via `.env`.
- Registers routes under `/api`.
- Enables **CORS** for frontend access.
- Validates **API keys** in headers for protected routes.

### 🧩 Routes Overview

All API endpoints are registered in `src/routes/reorderRoutes.py`:

| Method | Endpoint             | Description                                       |
| ------ | -------------------- | ------------------------------------------------- |
| GET    | /api/                | Simple "Hello World" route to test API connection |
| GET    | /api/users           | Fetches all users from the `clients` table        |
| POST   | /api/addUser         | Adds a new user to the database                   |
| PUT    | /api/updateUser/<id> | Updates user information by ID                    |

---

### 📄 Swagger Documentation

The API provides interactive documentation via **Swagger UI** at [`/docs`](http://localhost:5000/docs).

- **How to use:**  
   Visit `/docs` in your browser after starting the containers to explore and test all endpoints.
- **Features:**
  - View all available routes, parameters, and responses.
  - Try out requests directly from the browser.
  - See required headers (e.g., `X-API-KEY`) for authentication.

### 🧠 Request Flow

1. **Route layer**: Receives the HTTP request and directs it to the correct controller.
2. **Controller layer**: Validates the input, checks permissions, calls the model, and structures the response.
3. **Model layer**: Interacts directly with MySQL using SQL queries.
4. **Response**: Returns JSON data to the client.

---

## 🔐 API Key Permissions

### SQL Schema for Users and Permissions

```sql
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
```

### How Permissions Work

- Each API key is associated with a **role** (`admin`, `editor`, `viewer`).
- Each role has a set of **permissions** stored as a JSON array in the `permissions` column.
- When a request is made, the API checks:
  1. If the `X-API-KEY` header is present.
  2. If the key exists in the `users` table.
  3. If the key has the required permission for the requested endpoint.

Example permission check in Python:

```python
def check_permission(api_key, required_permission):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT permissions FROM users WHERE api_key = %s", (api_key,))
    user = cursor.fetchone()
    if not user:
        return False
    permissions = json.loads(user['permissions'])
    return required_permission in permissions
```

---

## 🛠️ Installation & Setup

1. **Clone the repository**

   ```bash
   git clone <https://github.com/TheValll/Efrei/tree/main/API/Projet1>
   cd Project1
   ```

2. **Create the `.env` file**

   ```
   MYSQL_ROOT_PASSWORD=rootpass
   MYSQL_DATABASE=flaskdb
   MYSQL_USER=flaskuser
   MYSQL_PASSWORD=flaskpass
   SECRET_KEY=random_long_stable_string
   ```

3. **Build and start the containers**

   ```bash
   docker compose up --build
   ```

   This will start:

   - Flask API → [http://localhost:5000](http://localhost:5000)
   - phpMyAdmin → [http://localhost:8080](http://localhost:8080)
   - MySQL database → accessible internally as `db:3306`

4. **Create a SSL certificate**

   ```bash
   cd src
   "C:\Program Files\Git\usr\bin\openssl.exe" req -x509 -newkey rsa:4096 -nodes -out cert.pem -keyout key.pem -days 3650
   ```

   Follow the steps in the terminal

5. **Generate your API token**

   ```bash
   curl -H "X-API-KEY: APIKEY-VIEWER-67890" https://127.0.0.1:5000/api/get-token
   ```

6. **Test the API**

   ! Comment the csrf = CSRFProtect(app) in the app.py for testing the API in Postman or anything else!
   You can also use Postman with the assets/Flask API Efrei.postman_collection.json
   ! For POST and PUT methods, you have to put a X-CSRFToken and Referer header !

   - Test route:
     ```bash
     curl -H "X-API-KEY: APIKEY-VIEWER-67890" http://localhost:5000/api/
     ```
   - Get all users:
     ```bash
     curl -H "X-API-KEY: APIKEY-VIEWER-67890" http://localhost:5000/api/users
     ```
   - Add a user:
     `bash
  curl --location --request POST 'https://127.0.0.1:5000/api/addUser?firstname=Ananda&lastname=Ouistiti&age=35&password=goodpassword&address=41%20avenue%20du%20Paradis&city=Paris&zipcode=95003&bank_id=3' \
--header 'Content-Type: application/json' \
--header 'X-API-KEY: APIKEY-ADMIN-12345' \
--header 'X-CSRFToken: YOUT_TOKEN' \
--header 'Referer: https://127.0.0.1:5000/' \
--header 'Cookie: session=YOUR_SESSION' \
--data ''
  `

   - Update a user:
     `bash
 curl --location --request PUT 'https://127.0.0.1:5000/api/updateUser/11?firstname=Ananda&lastname=Ouistiti&age=58&address=2%20rue%20du%20chat&city=Paris&zipcode=95004&bank_id=3' \
 --header 'Content-Type: application/json' \
 --header 'X-API-KEY: APIKEY-ADMIN-12345' \
 --header 'X-CSRFToken: YOUR_TOKEN' \
 --header 'Referer: https://127.0.0.1:5000/' \
 --header 'Cookie: session=YOUT_SESSION'
`
     ...

7. **Stopping and Cleaning**
   ```bash
   docker compose down -v
   ```
