CREATE TABLE bank (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    location VARCHAR(255)
);

CREATE TABLE clients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    firstname VARCHAR(100) NOT NULL,
    lastname VARCHAR(100) NOT NULL,
    age INT CHECK (age >= 0),
    password VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    city VARCHAR(100),
    zipcode VARCHAR(20),
    
    bank_id INT NOT NULL,
    FOREIGN KEY (bank_id) REFERENCES bank(id) ON DELETE CASCADE
);

CREATE TABLE account (
    id INT AUTO_INCREMENT PRIMARY KEY,
    amount DECIMAL(15,2) DEFAULT 0.00,
    current BOOLEAN DEFAULT FALSE,
    credit BOOLEAN DEFAULT FALSE,

    client_id INT NOT NULL,
    bank_id INT NOT NULL,
    
    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
    FOREIGN KEY (bank_id) REFERENCES bank(id) ON DELETE CASCADE
);
