INSERT INTO bank (name, location) VALUES
('Banque du Soleil', 'Paris'),
('Crédit Universel', 'Lyon'),
('Banque du Futur', 'Toulouse'),
('ÉcoBank', 'Marseille'),
('Banque Horizon', 'Bordeaux');

INSERT INTO clients (firstname, lastname, age, password, address, city, zipcode, bank_id) VALUES
('Alice', 'Durand', 28, 'azerty123', '12 rue des Fleurs', 'Paris', '75010', 1),
('Benoit', 'Lefèvre', 35, 'mdp2024', '25 avenue Victor Hugo', 'Lyon', '69003', 2),
('Clara', 'Martin', 22, 'passw0rd', '8 impasse des Lilas', 'Toulouse', '31000', 3),
('David', 'Bernard', 41, 'davidB!', '45 rue Nationale', 'Marseille', '13001', 4),
('Élodie', 'Petit', 30, 'secret123', '3 chemin des Jardins', 'Bordeaux', '33000', 5),
('François', 'Moreau', 55, 'fran2024', '10 boulevard Saint-Germain', 'Paris', '75005', 1),
('Géraldine', 'Roux', 27, 'gigi789', '7 rue du Marché', 'Lyon', '69006', 2),
('Hugo', 'Lambert', 19, 'hugoPass', '2 rue des Étudiants', 'Toulouse', '31000', 3),
('Isabelle', 'Dubois', 33, 'isa!234', '11 avenue de la Mer', 'Marseille', '13008', 4),
('Julien', 'Renard', 38, 'julR2025', '22 allée des Peupliers', 'Bordeaux', '33000', 5);

INSERT INTO account (amount, current, credit, client_id, bank_id) VALUES
(1250.50, TRUE, FALSE, 1, 1),
(3050.00, TRUE, TRUE, 1, 1),
(980.75, TRUE, FALSE, 2, 2),
(15000.00, FALSE, TRUE, 2, 2),
(430.10, TRUE, FALSE, 3, 3),
(50.00, TRUE, FALSE, 3, 3),
(8300.00, FALSE, TRUE, 4, 4),
(220.00, TRUE, FALSE, 4, 4),
(1100.55, TRUE, FALSE, 5, 5),
(9999.99, FALSE, TRUE, 5, 5),
(120.00, TRUE, FALSE, 6, 1),
(780.80, TRUE, TRUE, 6, 1),
(400.00, TRUE, FALSE, 7, 2),
(10000.00, FALSE, TRUE, 7, 2),
(150.00, TRUE, FALSE, 8, 3),
(75.25, TRUE, FALSE, 8, 3),
(6500.00, FALSE, TRUE, 9, 4),
(830.00, TRUE, FALSE, 9, 4),
(420.42, TRUE, FALSE, 10, 5),
(8000.00, FALSE, TRUE, 10, 5);
