-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Generation Time: Oct 07, 2025 at 06:14 PM
-- Server version: 8.0.43
-- PHP Version: 8.2.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `flaskdb`
--

-- --------------------------------------------------------

--
-- Table structure for table `account`
--

CREATE TABLE `account` (
  `id` int NOT NULL,
  `amount` decimal(15,2) DEFAULT '0.00',
  `current` tinyint(1) DEFAULT '0',
  `credit` tinyint(1) DEFAULT '0',
  `client_id` int NOT NULL,
  `bank_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `account`
--

INSERT INTO `account` (`id`, `amount`, `current`, `credit`, `client_id`, `bank_id`) VALUES
(1, 1250.50, 1, 0, 1, 1),
(2, 3050.00, 1, 1, 1, 1),
(3, 980.75, 1, 0, 2, 2),
(4, 15000.00, 0, 1, 2, 2),
(5, 430.10, 1, 0, 3, 3),
(6, 50.00, 1, 0, 3, 3),
(7, 8300.00, 0, 1, 4, 4),
(8, 220.00, 1, 0, 4, 4),
(9, 1100.55, 1, 0, 5, 5),
(10, 9999.99, 0, 1, 5, 5),
(11, 120.00, 1, 0, 6, 1),
(12, 780.80, 1, 1, 6, 1),
(13, 400.00, 1, 0, 7, 2),
(14, 10000.00, 0, 1, 7, 2),
(15, 150.00, 1, 0, 8, 3),
(16, 75.25, 1, 0, 8, 3),
(17, 6500.00, 0, 1, 9, 4),
(18, 830.00, 1, 0, 9, 4),
(19, 420.42, 1, 0, 10, 5),
(20, 8000.00, 0, 1, 10, 5);

-- --------------------------------------------------------

--
-- Table structure for table `bank`
--

CREATE TABLE `bank` (
  `id` int NOT NULL,
  `name` varchar(150) NOT NULL,
  `location` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `bank`
--

INSERT INTO `bank` (`id`, `name`, `location`) VALUES
(1, 'Banque du Soleil', 'Paris'),
(2, 'Crédit Universel', 'Lyon'),
(3, 'Banque du Futur', 'Toulouse'),
(4, 'ÉcoBank', 'Marseille'),
(5, 'Banque Horizon', 'Bordeaux');

-- --------------------------------------------------------

--
-- Table structure for table `clients`
--

CREATE TABLE `clients` (
  `id` int NOT NULL,
  `firstname` varchar(100) NOT NULL,
  `lastname` varchar(100) NOT NULL,
  `age` int DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `zipcode` varchar(20) DEFAULT NULL,
  `bank_id` int NOT NULL
) ;

--
-- Dumping data for table `clients`
--

INSERT INTO `clients` (`id`, `firstname`, `lastname`, `age`, `password`, `address`, `city`, `zipcode`, `bank_id`) VALUES
(1, 'Alice', 'Durand', 28, 'azerty123', '12 rue des Fleurs', 'Paris', '75010', 1),
(2, 'Benoit', 'Lefèvre', 35, 'mdp2024', '25 avenue Victor Hugo', 'Lyon', '69003', 2),
(3, 'Clara', 'Martin', 22, 'passw0rd', '8 impasse des Lilas', 'Toulouse', '31000', 3),
(4, 'David', 'Bernard', 41, 'davidB!', '45 rue Nationale', 'Marseille', '13001', 4),
(5, 'Élodie', 'Petit', 30, 'secret123', '3 chemin des Jardins', 'Bordeaux', '33000', 5),
(6, 'François', 'Moreau', 55, 'fran2024', '10 boulevard Saint-Germain', 'Paris', '75005', 1),
(7, 'Géraldine', 'Roux', 27, 'gigi789', '7 rue du Marché', 'Lyon', '69006', 2),
(8, 'Hugo', 'Lambert', 19, 'hugoPass', '2 rue des Étudiants', 'Toulouse', '31000', 3),
(9, 'Isabelle', 'Dubois', 33, 'isa!234', '11 avenue de la Mer', 'Marseille', '13008', 4),
(10, 'Julien', 'Renard', 38, 'julR2025', '22 allée des Peupliers', 'Bordeaux', '33000', 5),
(11, 'Ananda', 'Ouistiti', 58, 'goodpassword', '2 rue du chat', 'Paris', '95003', 3);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `username` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `api_key` varchar(255) NOT NULL,
  `role` enum('admin','editor','viewer') DEFAULT 'viewer',
  `permissions` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password_hash`, `api_key`, `role`, `permissions`, `created_at`) VALUES
(1, 'admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'APIKEY-ADMIN-12345', 'admin', '[\"view_users\", \"add_user\", \"update_user\"]', '2025-10-07 16:57:53'),
(2, 'editor', 'ef5e5a1fb95055e0e56cccf98a41e784a132c14e7f6e1ba244302f0e72b29baf', 'APIKEY-EDITOR-55555', 'editor', '[\"view_users\", \"add_user\"]', '2025-10-07 16:57:53'),
(3, 'viewer', '65375049b9e4d7cad6c9ba286fdeb9394b28135a3e84136404cfccfdcc438894', 'APIKEY-VIEWER-67890', 'viewer', '[\"view_users\"]', '2025-10-07 16:57:53');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_id` (`client_id`),
  ADD KEY `bank_id` (`bank_id`);

--
-- Indexes for table `bank`
--
ALTER TABLE `bank`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `clients`
--
ALTER TABLE `clients`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bank_id` (`bank_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `api_key` (`api_key`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account`
--
ALTER TABLE `account`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `bank`
--
ALTER TABLE `bank`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `clients`
--
ALTER TABLE `clients`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `account`
--
ALTER TABLE `account`
  ADD CONSTRAINT `account_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `account_ibfk_2` FOREIGN KEY (`bank_id`) REFERENCES `bank` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `clients`
--
ALTER TABLE `clients`
  ADD CONSTRAINT `clients_ibfk_1` FOREIGN KEY (`bank_id`) REFERENCES `bank` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
