CREATE TABLE `api_key_user` (
  `id` int NOT NULL,
  `username` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `api_key` varchar(255) NOT NULL,
  `role` enum('admin','editor','viewer') DEFAULT 'viewer',
  `permissions` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table `group`
CREATE TABLE IF NOT EXISTS `group` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `cover_photo` TEXT NULL,
  `description` TEXT NULL,
  `rules` TEXT NULL,
  `can_publish` BOOLEAN NOT NULL DEFAULT 1,
  `can_create_event` BOOLEAN NOT NULL DEFAULT 1,
  `visibility` BOOLEAN NOT NULL DEFAULT 1,
  `created_by` INT NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

-- Table `thread`
CREATE TABLE IF NOT EXISTS `thread` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `thread_name` VARCHAR(255) NOT NULL,
  `group_id` INT NULL,
  `event_id` INT NULL,
  `created_by` INT NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `chk_thread_parent` CHECK ((`group_id` IS NOT NULL AND `event_id` IS NULL) OR (`group_id` IS NULL AND `event_id` IS NOT NULL))
);

-- Table `message`
CREATE TABLE IF NOT EXISTS `message` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `thread_id` INT NOT NULL,
  `message_id` INT NOT NULL,
  `content` TEXT NOT NULL,
  `created_by` INT NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

-- Table `user`
CREATE TABLE IF NOT EXISTS `user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(255) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  `first_name` VARCHAR(45) NULL,
  `last_name` VARCHAR(45) NULL,
  `street_number` INT NULL,
  `street_name` VARCHAR(255) NULL,
  `zip_code` VARCHAR(5) NULL,
  `city` VARCHAR(45) NULL,
  `country` VARCHAR(45) NULL,
  PRIMARY KEY (`id`)
);

-- Table `event`
CREATE TABLE IF NOT EXISTS `event` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `is_ticketed` BOOLEAN NOT NULL DEFAULT 0,
  `visibility` BOOLEAN NOT NULL DEFAULT 1,
  `start_date` DATETIME NOT NULL,
  `end_date` DATETIME NOT NULL,
  `location` VARCHAR(255) NULL,
  `cover_photo` TEXT NULL,
  `carpooling` BOOLEAN NOT NULL DEFAULT 0,
  `created_by` INT NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

-- Table `carpooling`
CREATE TABLE IF NOT EXISTS `carpooling` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `event_id` INT NOT NULL,
  `car_type` VARCHAR(50) NULL,
  `insured_drive` BOOLEAN NULL,
  `price` FLOAT NULL,
  `number_place` INT NULL,
  `departure_datetime` DATETIME NOT NULL,
  `address` VARCHAR(255) NULL,
  `street_number` INT NULL,
  `street_name` VARCHAR(255) NULL,
  `zip_code` VARCHAR(5) NULL,
  `city` VARCHAR(45) NULL,
  `country` VARCHAR(45) NULL,
  `created_by` INT NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

-- Table `product`
CREATE TABLE IF NOT EXISTS `product` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `event_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `quantity` INT NOT NULL,
  `arrival_time` DATETIME NULL,
  `created_by` INT NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_product_id_name` (`product_id`, `name`)
);

-- Table `ticket`
CREATE TABLE IF NOT EXISTS `ticket` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `event_id` INT NOT NULL,
  `ticket_id` INT NOT NULL,
  `pricing` FLOAT NOT NULL,
  `free_quantity` INT NULL,
  `created_by` INT NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

-- Table `poll`
CREATE TABLE IF NOT EXISTS `poll` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `poll_id` INT NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `start_date` DATETIME NOT NULL,
  `end_date` DATETIME NOT NULL,
  `is_active` BOOLEAN NOT NULL DEFAULT 1,
  `created_by` INT NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

-- Table `poll_question`
CREATE TABLE IF NOT EXISTS `poll_question` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `poll_id` INT NOT NULL,
  `question_id` INT NOT NULL,
  `content` TEXT NOT NULL,
  `created_by` INT NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

-- Table `poll_answer`
CREATE TABLE IF NOT EXISTS `poll_answer` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `question_id` INT NOT NULL,
  `answer_id` INT NOT NULL,
  `answer_content` TEXT NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

-- Table `poll_system`
CREATE TABLE IF NOT EXISTS `poll_system` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `question_id` INT NOT NULL,
  `option_id` INT NOT NULL,
  `option_order` INT NOT NULL,
  PRIMARY KEY (`id`)
);

-- Table `album`
CREATE TABLE IF NOT EXISTS `album` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `album_name` VARCHAR(255) NOT NULL,
  `event_id` INT NULL,
  `group_id` INT NULL,
  `created_by` INT NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `chk_album_parent` CHECK ((`event_id` IS NOT NULL AND `group_id` IS NULL) OR (`event_id` IS NULL AND `group_id` IS NOT NULL))
);

-- Table `photo`
CREATE TABLE IF NOT EXISTS `photo` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `album_id` INT NOT NULL,
  `photo_id` VARCHAR(255) NOT NULL,
  `picture_link` TEXT NOT NULL,
  `created_by` INT NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

-- Table `photo_comment`
CREATE TABLE IF NOT EXISTS `photo_comment` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `photo_id` INT NOT NULL,
  `comment_id` INT NOT NULL,
  `content` TEXT NULL,
  `created_by` INT NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

-- Table `comment`
CREATE TABLE IF NOT EXISTS `comment` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `statement_id` INT NOT NULL,
  `content` TEXT NULL,
  PRIMARY KEY (`id`)
);

-- `user_group_membership` (User - Group)
CREATE TABLE IF NOT EXISTS `user_group_membership` (
  `user_id` INT NOT NULL,
  `group_id` INT NOT NULL,
  `role` VARCHAR(45) NULL,
  `join_date` DATE NOT NULL,
  PRIMARY KEY (`user_id`, `group_id`)
);

-- `user_event_participation` (User - Event)
CREATE TABLE IF NOT EXISTS `user_event_participation` (
  `user_id` INT NOT NULL,
  `event_id` INT NOT NULL,
  `joined_at` DATE NOT NULL,
  PRIMARY KEY (`user_id`, `event_id`)
);

-- `driver_carpooling` (User - Carpooling)
CREATE TABLE IF NOT EXISTS `driver_carpooling` (
  `user_id` INT NOT NULL,
  `carpooling_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `carpooling_id`)
);

-- `passenger_carpooling` (User - Carpooling)
CREATE TABLE IF NOT EXISTS `passenger_carpooling` (
  `user_id` INT NOT NULL,
  `carpooling_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `carpooling_id`)
);

-- `user_ticket_purchase` (User - Ticket)
CREATE TABLE IF NOT EXISTS `user_ticket_purchase` (
  `user_id` INT NOT NULL,
  `ticket_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `ticket_id`)
);

-- `user_product_contribution` (User - Product)
CREATE TABLE IF NOT EXISTS `user_product_contribution` (
  `user_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `product_id`)
);

-- `user_poll_creation` (User - Poll)
CREATE TABLE IF NOT EXISTS `user_poll_creation` (
  `user_id` INT NOT NULL,
  `poll_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `poll_id`)
);

-- `user_poll_answer` (User - Poll_Answer)
CREATE TABLE IF NOT EXISTS `user_poll_answer` (
  `user_id` INT NOT NULL,
  `poll_answer_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `poll_answer_id`)
);

-- `user_question_answer` (User - Poll_Question)
CREATE TABLE IF NOT EXISTS `user_question_answer` (
  `user_id` INT NOT NULL,
  `poll_question_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `poll_question_id`)
);

-- `user_poll_moderation` (User - Poll)
CREATE TABLE IF NOT EXISTS `user_poll_moderation` (
  `user_id` INT NOT NULL,
  `poll_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `poll_id`)
);

-- `user_photo_upload` (User - Photo)
CREATE TABLE IF NOT EXISTS `user_photo_upload` (
  `user_id` INT NOT NULL,
  `photo_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `photo_id`)
);

-- `user_album_contribution` (User - Album)
CREATE TABLE IF NOT EXISTS `user_album_contribution` (
  `user_id` INT NOT NULL,
  `album_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `album_id`)
);

-- `user_comment_authorship` (User - Comment)
CREATE TABLE IF NOT EXISTS `user_comment_authorship` (
  `user_id` INT NOT NULL,
  `comment_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `comment_id`)
);

-- `user_thread_creation` (User - Thread)
CREATE TABLE IF NOT EXISTS `user_thread_creation` (
  `user_id` INT NOT NULL,
  `thread_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `thread_id`)
);

-- `user_message_authorship` (User - Message)
CREATE TABLE IF NOT EXISTS `user_message_authorship` (
  `user_id` INT NOT NULL,
  `message_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `message_id`)
);

-- `user_event_organizer` (User - Event)
CREATE TABLE IF NOT EXISTS `user_event_organizer` (
  `user_id` INT NOT NULL,
  `event_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `event_id`)
);

ALTER TABLE `thread`
  ADD CONSTRAINT `fk_thread_group` FOREIGN KEY (`group_id`) REFERENCES `group` (`id`),
  ADD CONSTRAINT `fk_thread_event` FOREIGN KEY (`event_id`) REFERENCES `event` (`id`),
  ADD CONSTRAINT `fk_thread_creator` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`);

ALTER TABLE `message`
  ADD CONSTRAINT `fk_message_thread` FOREIGN KEY (`thread_id`) REFERENCES `thread` (`id`),
  ADD CONSTRAINT `fk_message_creator` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`);

ALTER TABLE `carpooling`
  ADD CONSTRAINT `fk_carpooling_event` FOREIGN KEY (`event_id`) REFERENCES `event` (`id`),
  ADD CONSTRAINT `fk_carpooling_creator` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`);

ALTER TABLE `product`
  ADD CONSTRAINT `fk_product_event` FOREIGN KEY (`event_id`) REFERENCES `event` (`id`),
  ADD CONSTRAINT `fk_product_creator` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`);

ALTER TABLE `ticket`
  ADD CONSTRAINT `fk_ticket_event` FOREIGN KEY (`event_id`) REFERENCES `event` (`id`),
  ADD CONSTRAINT `fk_ticket_creator` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`);

ALTER TABLE `poll_question`
  ADD CONSTRAINT `fk_question_poll` FOREIGN KEY (`poll_id`) REFERENCES `poll` (`id`),
  ADD CONSTRAINT `fk_question_creator` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`);

ALTER TABLE `poll_answer`
  ADD CONSTRAINT `fk_poll_answer_question` FOREIGN KEY (`question_id`) REFERENCES `poll_question` (`id`);

ALTER TABLE `poll_system`
  ADD CONSTRAINT `fk_poll_option_question` FOREIGN KEY (`question_id`) REFERENCES `poll_question` (`id`);

ALTER TABLE `poll`
  ADD CONSTRAINT `fk_poll_creator` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`);

ALTER TABLE `album`
  ADD CONSTRAINT `fk_album_event` FOREIGN KEY (`event_id`) REFERENCES `event` (`id`),
  ADD CONSTRAINT `fk_album_group` FOREIGN KEY (`group_id`) REFERENCES `group` (`id`),
  ADD CONSTRAINT `fk_album_creator` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`);

ALTER TABLE `photo`
  ADD CONSTRAINT `fk_photo_album` FOREIGN KEY (`album_id`) REFERENCES `album` (`id`),
  ADD CONSTRAINT `fk_photo_creator` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`);

ALTER TABLE `photo_comment`
  ADD CONSTRAINT `fk_photo_comment_photo` FOREIGN KEY (`photo_id`) REFERENCES `photo` (`id`),
  ADD CONSTRAINT `fk_photo_comment_creator` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`);

ALTER TABLE `group`
  ADD CONSTRAINT `fk_group_creator` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`);

ALTER TABLE `event`
  ADD CONSTRAINT `fk_event_creator` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`);

ALTER TABLE `user_group_membership`
  ADD CONSTRAINT `fk_ugm_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `fk_ugm_group` FOREIGN KEY (`group_id`) REFERENCES `group` (`id`);

ALTER TABLE `user_event_participation`
  ADD CONSTRAINT `fk_uep_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `fk_uep_event` FOREIGN KEY (`event_id`) REFERENCES `event` (`id`);

ALTER TABLE `driver_carpooling`
  ADD CONSTRAINT `fk_dc_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `fk_dc_carpooling` FOREIGN KEY (`carpooling_id`) REFERENCES `carpooling` (`id`);

ALTER TABLE `passenger_carpooling`
  ADD CONSTRAINT `fk_pc_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `fk_pc_carpooling` FOREIGN KEY (`carpooling_id`) REFERENCES `carpooling` (`id`);

ALTER TABLE `user_ticket_purchase`
  ADD CONSTRAINT `fk_utp_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `fk_utp_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `ticket` (`id`);

ALTER TABLE `user_product_contribution`
  ADD CONSTRAINT `fk_upc_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `fk_upc_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`);

ALTER TABLE `user_poll_creation`
  ADD CONSTRAINT `fk_upollc_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `fk_upollc_poll` FOREIGN KEY (`poll_id`) REFERENCES `poll` (`id`);

ALTER TABLE `user_poll_answer`
  ADD CONSTRAINT `fk_upa_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `fk_upa_poll_answer` FOREIGN KEY (`poll_answer_id`) REFERENCES `poll_answer` (`id`);

ALTER TABLE `user_question_answer`
  ADD CONSTRAINT `fk_uqa_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `fk_uqa_question` FOREIGN KEY (`poll_question_id`) REFERENCES `poll_question` (`id`);

ALTER TABLE `user_poll_moderation`
  ADD CONSTRAINT `fk_upm_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `fk_upm_poll` FOREIGN KEY (`poll_id`) REFERENCES `poll` (`id`);

ALTER TABLE `user_photo_upload`
  ADD CONSTRAINT `fk_upu_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `fk_upu_photo` FOREIGN KEY (`photo_id`) REFERENCES `photo` (`id`);

ALTER TABLE `user_album_contribution`
  ADD CONSTRAINT `fk_uac_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `fk_uac_album` FOREIGN KEY (`album_id`) REFERENCES `album` (`id`);

ALTER TABLE `user_comment_authorship`
  ADD CONSTRAINT `fk_uca_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `fk_uca_comment` FOREIGN KEY (`comment_id`) REFERENCES `comment` (`id`);

ALTER TABLE `user_thread_creation`
  ADD CONSTRAINT `fk_utc_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `fk_utc_thread` FOREIGN KEY (`thread_id`) REFERENCES `thread` (`id`);

ALTER TABLE `user_message_authorship`
  ADD CONSTRAINT `fk_uma_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `fk_uma_message` FOREIGN KEY (`message_id`) REFERENCES `message` (`id`);

ALTER TABLE `user_event_organizer`
  ADD CONSTRAINT `fk_ueo_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `fk_ueo_event` FOREIGN KEY (`event_id`) REFERENCES `event` (`id`);

INSERT INTO `user` (`id`, `email`, `password`, `first_name`, `last_name`, `street_number`, `street_name`, `zip_code`, `city`, `country`) VALUES
(1, 'jean.dupont@example.com', 'hashed_password_1', 'Jean', 'Dupont', 15, 'Rue de la Paix', '75002', 'Paris', 'France'),
(2, 'marie.curie@example.com', 'hashed_password_2', 'Marie', 'Curie', 1, 'Quai de Conti', '75006', 'Paris', 'France'),
(3, 'pierre.martin@example.com', 'hashed_password_3', 'Pierre', 'Martin', 42, 'Boulevard de la Liberté', '59000', 'Lille', 'France'),
(4, 'sophie.bernard@example.com', 'hashed_password_4', 'Sophie', 'Bernard', 8, 'Rue du Commerce', '69002', 'Lyon', 'France'),
(5, 'lucas.dubois@example.com', 'hashed_password_5', 'Lucas', 'Dubois', 123, 'Avenue du Prado', '13008', 'Marseille', 'France'),
(6, 'camille.petit@example.com', 'hashed_password_6', 'Camille', 'Petit', 7, 'Place de la Comédie', '34000', 'Montpellier', 'France'),
(7, 'nathan.leroy@example.com', 'hashed_password_7', 'Nathan', 'Leroy', 22, 'Rue Saint-Michel', '35000', 'Rennes', 'France'),
(8, 'chloe.moreau@example.com', 'hashed_password_8', 'Chloé', 'Moreau', 56, 'Cours Victor Hugo', '33000', 'Bordeaux', 'France'),
(9, 'hugo.laurent@example.com', 'hashed_password_9', 'Hugo', 'Laurent', 9, 'Quai des Bateliers', '67000', 'Strasbourg', 'France'),
(10, 'emma.simon@example.com', 'hashed_password_10', 'Emma', 'Simon', 33, 'Rue Esquermoise', '59800', 'Lille', 'France'),
(11, 'gabriel.michel@example.com', 'hashed_password_11', 'Gabriel', 'Michel', 18, 'Rue de la République', '69001', 'Lyon', 'France'),
(12, 'alice.garcia@example.com', 'hashed_password_12', 'Alice', 'Garcia', 101, 'La Canebière', '13001', 'Marseille', 'France'),
(13, 'adam.lefevre@example.com', 'hashed_password_13', 'Adam', 'Lefèvre', 2, 'Place du Capitole', '31000', 'Toulouse', 'France'),
(14, 'louise.andre@example.com', 'hashed_password_14', 'Louise', 'André', 14, 'Rue de la Mésange', '67000', 'Strasbourg', 'France'),
(15, 'raphael.mercier@example.com', 'hashed_password_15', 'Raphaël', 'Mercier', 29, 'Rue Nationale', '37000', 'Tours', 'France'),
(16, 'lea.fournier@example.com', 'hashed_password_16', 'Léa', 'Fournier', 1, 'Place Royale', '44000', 'Nantes', 'France'),
(17, 'arthur.girard@example.com', 'hashed_password_17', 'Arthur', 'Girard', 5, 'Rue du Gros Horloge', '76000', 'Rouen', 'France'),
(18, 'manon.bonnet@example.com', 'hashed_password_18', 'Manon', 'Bonnet', 78, 'Avenue Jean Médecin', '06000', 'Nice', 'France'),
(19, 'jules.david@example.com', 'hashed_password_19', 'Jules', 'David', 4, 'Place de Jaude', '63000', 'Clermont-Ferrand', 'France'),
(20, 'anna.morel@example.com', 'hashed_password_20', 'Anna', 'Morel', 88, 'Rue du Faubourg de Roubaix', '59000', 'Lille', 'France'),
(21, 'louis.roussel@example.com', 'hashed_password_21', 'Louis', 'Roussel', 21, 'Rue de la Soif', '35000', 'Rennes', 'France'),
(22, 'eva.blanc@example.com', 'hashed_password_22', 'Eva', 'Blanc', 3, 'Place Stanislas', '54000', 'Nancy', 'France'),
(23, 'tom.guerin@example.com', 'hashed_password_23', 'Tom', 'Guerin', 19, 'Rue des Arts', '31000', 'Toulouse', 'France'),
(24, 'zoe.vincent@example.com', 'hashed_password_24', 'Zoé', 'Vincent', 50, 'Promenade des Anglais', '06200', 'Nice', 'France'),
(25, 'theo.muller@example.com', 'hashed_password_25', 'Théo', 'Muller', 11, 'Rue de la Loge', '13002', 'Marseille', 'France'),
(26, 'clara.faure@example.com', 'hashed_password_26', 'Clara', 'Faure', 6, 'Rue du Bœuf', '69005', 'Lyon', 'France'),
(27, 'maxime.legrand@example.com', 'hashed_password_27', 'Maxime', 'Legrand', 30, 'Allée de la Robertsau', '67000', 'Strasbourg', 'France'),
(28, 'jade.gaillard@example.com', 'hashed_password_28', 'Jade', 'Gaillard', 16, 'Rue des Carmes', '45000', 'Orléans', 'France'),
(29, 'alexandre.brunet@example.com', 'hashed_password_29', 'Alexandre', 'Brunet', 99, 'Boulevard de la Croix-Rousse', '69004', 'Lyon', 'France'),
(30, 'lina.gauthier@example.com', 'hashed_password_30', 'Lina', 'Gauthier', 25, 'Rue du Cherche-Midi', '75006', 'Paris', 'France');

INSERT INTO `group` (`id`, `name`, `cover_photo`, `description`, `rules`, `can_publish`, `can_create_event`, `visibility`, `created_by`) VALUES
(1, 'Randonneurs du Dimanche', 'https://picsum.photos/seed/group1/1200/400', 'Un groupe pour organiser des randonnées conviviales tous les week-ends.', 'Être respectueux et apporter sa bonne humeur.', 1, 1, 1, 1),
(2, 'Club de Lecture de Paris', 'https://picsum.photos/seed/group2/1200/400', 'Discussions mensuelles sur des œuvres littéraires classiques et contemporaines.', 'Avoir lu le livre avant la réunion.', 1, 0, 1, 2),
(3, 'Cuisine du Monde - Lyon', 'https://picsum.photos/seed/group3/1200/400', 'Partage de recettes, astuces et organisation d\'ateliers culinaires.', 'Pas de publicité. Partage uniquement.', 1, 1, 1, 4),
(4, 'Cinéphiles de Lille', 'https://picsum.photos/seed/group4/1200/400', 'Pour tous les amoureux du 7ème art. Sorties ciné, débats et analyses.', NULL, 1, 1, 0, 3),
(5, 'Art & Musées Bordeaux', 'https://picsum.photos/seed/group5/1200/400', 'Visites de musées, galeries et expositions sur Bordeaux et ses environs.', 'Inscription obligatoire aux événements.', 0, 1, 1, 8),
(6, 'Développeurs Web France', 'https://picsum.photos/seed/group6/1200/400', 'Entraide, veille technologique et apéros dev.', 'Langage correct exigé, pas de spam.', 1, 1, 1, 11),
(7, 'Yoga en Plein Air - Marseille', 'https://picsum.photos/seed/group7/1200/400', 'Sessions de yoga gratuites dans les parcs de Marseille.', 'Apporter son propre tapis.', 1, 1, 1, 5),
(8, 'Photographes Amateurs Strasbourg', 'https://picsum.photos/seed/group8/1200/400', 'Sorties photo pour capturer la beauté de l\'Alsace.', 'Critiques constructives uniquement.', 1, 1, 1, 9),
(9, 'Jeux de Société & Rôles', 'https://picsum.photos/seed/group9/1200/400', 'Organisation de soirées jeux de société, de plateau et JDR.', 'Tous niveaux acceptés.', 1, 1, 1, 7),
(10, 'Parents de Rennes', 'https://picsum.photos/seed/group10/1200/400', 'Groupe privé pour les parents de Rennes. Partage de bons plans et sorties.', 'Validation par un admin requise.', 1, 0, 0, 21),
(11, 'Amoureux de l\'Italie', 'https://picsum.photos/seed/group11/1200/400', 'Voyages, culture, langue et gastronomie italienne.', 'Parler de l\'Italie avec passion.', 1, 1, 1, 6),
(12, 'Basket 3x3 Toulouse', 'https://picsum.photos/seed/group12/1200/400', 'Organisation de matchs de basket en 3 contre 3.', 'Fair-play avant tout.', 1, 1, 1, 13),
(13, 'Écologie & Zéro Déchet', 'https://picsum.photos/seed/group13/1200/400', 'Discussions et actions pour un mode de vie plus durable.', 'Bienveillance et non-jugement.', 1, 1, 1, 26),
(14, 'Passionnés de Bricolage', 'https://picsum.photos/seed/group14/1200/400', 'Partage de projets, conseils et astuces de bricolage.', NULL, 1, 1, 1, 29),
(15, 'Concerts & Festivals', 'https://picsum.photos/seed/group15/1200/400', 'Ne manquez plus aucun concert. Organisation de co-voiturages.', NULL, 1, 1, 1, 18),
(16, 'Club d\'Échecs de Nancy', 'https://picsum.photos/seed/group16/1200/400', 'Tournois et parties amicales pour tous les niveaux.', 'Respect de l\'adversaire.', 0, 1, 1, 22),
(17, 'Entrepreneurs de Nantes', 'https://picsum.photos/seed/group17/1200/400', 'Réseautage, partage d\'expériences et soutien pour les entrepreneurs nantais.', 'Pas d\'auto-promotion excessive.', 1, 1, 1, 16),
(18, 'Pêche en Rivière - Auvergne', 'https://picsum.photos/seed/group18/1200/400', 'Les meilleurs spots et techniques de pêche dans la région.', 'Respect de la nature et des réglementations.', 1, 1, 1, 19),
(19, 'Salsa & Bachata Nice', 'https://picsum.photos/seed/group19/1200/400', 'Trouver des partenaires et des soirées pour danser la salsa et la bachata.', NULL, 1, 1, 1, 24),
(20, 'Histoire & Patrimoine', 'https://picsum.photos/seed/group20/1200/400', 'Visites de châteaux, monuments et sites historiques.', NULL, 0, 1, 1, 15),
(21, 'Jardinage Urbain', 'https://picsum.photos/seed/group21/1200/400', 'Conseils pour faire pousser ses légumes sur son balcon ou en ville.', 'Partage de graines et de plants encouragé.', 1, 1, 1, 12),
(22, 'Running Club du Matin', 'https://picsum.photos/seed/group22/1200/400', 'Sessions de course à pied avant le travail.', 'Tous les rythmes sont les bienvenus.', 1, 1, 1, 10),
(23, 'Fans de Star Wars', 'https://picsum.photos/seed/group23/1200/400', 'Discussions, théories et visionnages de la saga.', 'Attention aux spoilers !', 1, 0, 1, 17),
(24, 'Observateurs d\'Étoiles', 'https://picsum.photos/seed/group24/1200/400', 'Nuits d\'observation astronomique, loin de la pollution lumineuse.', NULL, 1, 1, 1, 25),
(25, 'Volley-ball de Plage', 'https://picsum.photos/seed/group25/1200/400', 'Organisation de matchs sur les plages de la région.', 'Bonne ambiance et crème solaire obligatoires.', 1, 1, 1, 20),
(26, 'Amis des Animaux', 'https://picsum.photos/seed/group26/1200/400', 'Partage de photos de nos compagnons et conseils vétérinaires.', 'Pas d\'annonces de vente.', 1, 0, 1, 14),
(27, 'Groupe de Soutien aux Étudiants', 'https://picsum.photos/seed/group27/1200/400', 'Groupe privé pour s\'entraider pendant les études.', 'Confidentialité et respect.', 1, 0, 0, 27),
(28, 'Karaoké Addicts', 'https://picsum.photos/seed/group28/1200/400', 'Toutes les bonnes adresses pour des soirées karaoké endiablées.', 'Chanter faux est autorisé !', 1, 1, 1, 23),
(29, 'Cyclotourisme en France', 'https://picsum.photos/seed/group29/1200/400', 'Planification de voyages à vélo sur plusieurs jours.', 'Partage d\'itinéraires et de conseils matériel.', 1, 1, 1, 28),
(30, 'Apprentissage de l\'Espagnol', 'https://picsum.photos/seed/group30/1200/400', 'Tandems linguistiques et pratique de la langue espagnole.', 'Todos los niveles son bienvenidos.', 1, 1, 1, 30);

INSERT INTO `event` (`id`, `name`, `description`, `is_ticketed`, `visibility`, `start_date`, `end_date`, `location`, `cover_photo`, `carpooling`, `created_by`) VALUES
(1, 'Randonnée au Lac Blanc', 'Une superbe randonnée de 12km avec un panorama exceptionnel. Niveau intermédiaire.', 0, 1, '2025-10-18 09:00:00', '2025-10-18 17:00:00', 'Orbey, France', 'https://picsum.photos/seed/event1/1200/600', 1, 1),
(2, 'Atelier Pâtes Fraîches', 'Apprenez à faire vos propres tagliatelles et raviolis avec un chef italien.', 1, 1, '2025-11-22 18:00:00', '2025-11-22 21:00:00', '12 Rue de la Gastronomie, Lyon', 'https://picsum.photos/seed/event2/1200/600', 0, 2),
(3, 'Projection "Blade Runner" en VOSTFR', 'Redécouvrez ce chef-d\'œuvre de la SF sur grand écran.', 1, 1, '2025-10-25 20:30:00', '2025-10-25 22:30:00', 'Cinéma Le Métropole, Lille', 'https://picsum.photos/seed/event3/1200/600', 1, 3),
(4, 'Soirée Jeux de Société', 'Ramenez vos jeux préférés et découvrez-en de nouveaux !', 0, 1, '2025-11-07 19:00:00', '2025-11-08 01:00:00', 'Bar à jeux "Le Dé Ludique"', 'https://picsum.photos/seed/event4/1200/600', 0, 4),
(5, 'Visite du Musée d\'Art Moderne', 'Exposition temporaire sur le cubisme.', 1, 1, '2025-11-15 14:30:00', '2025-11-15 16:30:00', 'Musée d\'Art Moderne, Paris', 'https://picsum.photos/seed/event5/1200/600', 0, 5),
(6, 'Apéro Dev & Tech', 'Rencontre informelle entre développeurs pour discuter des dernières technos.', 0, 1, '2025-10-30 19:00:00', '2025-10-30 22:00:00', 'Le Connecteur, Bordeaux', 'https://picsum.photos/seed/event6/1200/600', 0, 6),
(7, 'Yoga au lever du soleil', 'Session de Hatha Yoga face à la mer.', 0, 1, '2025-10-19 07:00:00', '2025-10-19 08:00:00', 'Plage des Prophètes, Marseille', 'https://picsum.photos/seed/event7/1200/600', 0, 7),
(8, 'Sortie Photo : La Petite France', 'Capturez la magie du quartier le plus pittoresque de Strasbourg.', 0, 1, '2025-11-01 15:00:00', '2025-11-01 18:00:00', 'Strasbourg, France', 'https://picsum.photos/seed/event8/1200/600', 1, 8),
(9, 'Festival de Rock Indé', 'Festival sur 2 jours avec des groupes de la scène locale et nationale.', 1, 1, '2026-06-12 18:00:00', '2026-06-13 23:59:00', 'Plein Air, Rennes', 'https://picsum.photos/seed/event9/1200/600', 1, 9),
(10, 'Nettoyage de Plage', 'Action citoyenne pour nettoyer la plage du Prado. Sacs et gants fournis.', 0, 1, '2025-11-08 10:00:00', '2025-11-08 12:00:00', 'Plage du Prado, Marseille', 'https://picsum.photos/seed/event10/1200/600', 1, 10),
(11, 'Match de Basket au City Stade', 'Match amical en 3x3, ouvert à tous.', 0, 1, '2025-10-26 14:00:00', '2025-10-26 16:00:00', 'City Stade des Ponts Jumeaux, Toulouse', 'https://picsum.photos/seed/event11/1200/600', 0, 11),
(12, 'Tournoi d\'Échecs', 'Tournoi amical pour tous niveaux.', 1, 0, '2025-11-23 13:00:00', '2025-11-23 18:00:00', 'Maison des Associations, Nancy', 'https://picsum.photos/seed/event12/1200/600', 0, 12),
(13, 'Conférence sur l\'IA', 'L\'impact de l\'intelligence artificielle sur nos sociétés.', 1, 1, '2025-11-19 19:30:00', '2025-11-19 21:00:00', 'Université de Paris-Saclay', 'https://picsum.photos/seed/event13/1200/600', 1, 13),
(14, 'Pique-nique Géant au Parc', 'Chacun amène quelque chose à partager !', 0, 1, '2026-07-04 12:00:00', '2026-07-04 16:00:00', 'Parc de la Tête d\'Or, Lyon', 'https://picsum.photos/seed/event14/1200/600', 0, 14),
(15, 'Soirée Salsa en plein air', 'Initiation gratuite puis soirée dansante.', 0, 1, '2026-07-18 20:00:00', '2026-07-19 00:00:00', 'Quais de la Garonne, Bordeaux', 'https://picsum.photos/seed/event15/1200/600', 0, 15),
(16, 'Brocante Geek', 'Vendez et achetez des jeux vidéo, mangas, figurines...', 0, 1, '2025-11-30 09:00:00', '2025-11-30 17:00:00', 'Espace Événementiel, Toulouse', 'https://picsum.photos/seed/event16/1200/600', 1, 16),
(17, 'Weekend Vélo le long de la Loire', 'Un parcours de 150km sur 2 jours, de Tours à Angers.', 0, 1, '2026-05-22 09:00:00', '2026-05-24 18:00:00', 'Départ de Tours', 'https://picsum.photos/seed/event17/1200/600', 1, 17),
(18, 'Nuit des Étoiles', 'Observation des Perséides avec des télescopes à disposition.', 0, 1, '2026-08-12 22:00:00', '2026-08-13 02:00:00', 'Observatoire de Haute-Provence', 'https://picsum.photos/seed/event18/1200/600', 1, 18),
(19, 'Initiation à l\'Escalade en salle', 'Séance découverte avec un moniteur diplômé.', 1, 1, '2025-12-06 11:00:00', '2025-12-06 13:00:00', 'Block\'Out, Paris', 'https://picsum.photos/seed/event19/1200/600', 0, 19),
(20, 'Marathon Star Wars (Trilogie Originale)', 'Que la Force soit avec vous pour cette nuit de cinéma.', 1, 1, '2025-12-13 21:00:00', '2025-12-14 04:00:00', 'Cinéma Le Grand Rex, Paris', 'https://picsum.photos/seed/event20/1200/600', 1, 20),
(21, 'Marché de Noël de Strasbourg', 'Visite groupée du célèbre marché de Noël.', 0, 1, '2025-12-07 16:00:00', '2025-12-07 20:00:00', 'Strasbourg Centre', 'https://picsum.photos/seed/event21/1200/600', 1, 21),
(22, 'Concours de Soupe', 'Préparez votre meilleure soupe et faites-la déguster !', 0, 1, '2025-11-16 12:00:00', '2025-11-16 14:00:00', 'Salle des fêtes de quartier, Rennes', 'https://picsum.photos/seed/event22/1200/600', 0, 22),
(23, 'Atelier DIY : Créez vos cosmétiques', 'Apprenez à fabriquer votre propre déodorant et dentifrice solides.', 1, 1, '2025-11-29 10:00:00', '2025-11-29 12:00:00', 'Boutique "Green Life", Nantes', 'https://picsum.photos/seed/event23/1200/600', 0, 23),
(24, 'Tournoi de Beach Volley', 'Tournoi 2x2 amical, inscriptions en binôme.', 0, 1, '2026-08-08 13:00:00', '2026-08-08 19:00:00', 'Plage de la Grande Motte', 'https://picsum.photos/seed/event24/1200/600', 1, 24),
(25, 'Karaoké Géant', 'Scène ouverte pour toutes les stars d\'un soir.', 0, 1, '2025-11-14 21:00:00', '2025-11-15 02:00:00', 'Le BAM Karaoké Box, Bordeaux', 'https://picsum.photos/seed/event25/1200/600', 0, 25),
(26, 'Visite du Château de Versailles', 'Journée complète pour explorer le château et ses jardins.', 1, 1, '2026-05-16 10:00:00', '2026-05-16 17:00:00', 'Versailles, France', 'https://picsum.photos/seed/event26/1200/600', 1, 26),
(27, 'Cours de dessin : Modèle vivant', 'Session de 2h pour pratiquer le dessin d\'après modèle.', 1, 0, '2025-11-25 19:00:00', '2025-11-25 21:00:00', 'Atelier des Beaux-Arts, Paris', 'https://picsum.photos/seed/event27/1200/600', 0, 27),
(28, 'Dégustation de Vins de Bourgogne', 'Découverte de 5 cépages de la région avec un sommelier.', 1, 1, '2025-12-05 19:00:00', '2025-12-05 21:00:00', 'Cave "Le Vin Cœur", Dijon', 'https://picsum.photos/seed/event28/1200/600', 0, 28),
(29, 'Sortie VTT en Forêt', 'Parcours de 25km en forêt de Fontainebleau. Niveau confirmé.', 0, 1, '2025-10-26 09:30:00', '2025-10-26 13:00:00', 'Forêt de Fontainebleau', 'https://picsum.photos/seed/event29/1200/600', 1, 29),
(30, 'Tandem Linguistique Franco-Espagnol', 'Pratiquez votre espagnol et aidez les autres à apprendre le français.', 0, 1, '2025-11-06 19:00:00', '2025-11-06 20:30:00', 'Café "El Idioma", Lyon', 'https://picsum.photos/seed/event30/1200/600', 0, 30);

INSERT INTO `thread` (`id`, `thread_name`, `group_id`, `event_id`, `created_by`) VALUES
(1, 'Prochaine Rando - Idées ?', 1, NULL, 1),
(2, 'Livre du mois de Novembre', 2, NULL, 2),
(3, 'Partage de recette : Tiramisu', 3, NULL, 3),
(4, 'Débat sur le dernier Nolan', 4, NULL, 4),
(5, 'Qui vient à l\'expo du CAPC ?', 5, NULL, 5),
(6, 'React vs Vue vs Svelte', 6, NULL, 6),
(7, 'Meilleur spot de yoga ?', 7, NULL, 7),
(8, 'Conseils pour photo de nuit', 8, NULL, 8),
(9, 'Recherche Maître du Jeu', 9, NULL, 9),
(10, 'Bons plans garde d\'enfants', 10, NULL, 10),
(11, 'Organisation voyage en Sicile', 11, NULL, 11),
(12, 'Où jouer au basket ce weekend ?', 12, NULL, 12),
(13, 'Astuces pour réduire ses déchets', 13, NULL, 13),
(14, 'Quel outil pour couper du chêne ?', 14, NULL, 14),
(15, 'Qui va au Hellfest l\'an prochain ?', 15, NULL, 15),
(16, 'Météo pour la rando de samedi', NULL, 1, 16),
(17, 'Allergies alimentaires à signaler', NULL, 2, 17),
(18, 'Qui veut manger un bout avant le film ?', NULL, 3, 18),
(19, 'Covoiturage depuis le centre-ville', NULL, 8, 19),
(20, 'Point de RDV pour le festival', NULL, 9, 20),
(21, 'Photos du nettoyage de plage', NULL, 10, 21),
(22, 'Besoin d\'un 6ème joueur !', NULL, 11, 22),
(23, 'Questions pour le conférencier', NULL, 13, 23),
(24, 'Qu\'est-ce que vous amenez au pique-nique ?', NULL, 14, 24),
(25, 'Playlist pour la soirée salsa', NULL, 15, 25),
(26, 'Infos pratiques pour le weekend vélo', NULL, 17, 26),
(27, 'Matériel à prévoir pour l\'escalade', NULL, 19, 27),
(28, 'Meilleur costume pour le marathon SW ?', NULL, 20, 28),
(29, 'Vin chaud après le marché de Noël ?', NULL, 21, 29),
(30, 'Covoiturage depuis Fontainebleau-Avon', NULL, 29, 30);

INSERT INTO `message` (`id`, `thread_id`, `message_id`, `content`, `created_by`) VALUES
(1, 1, 1, 'Je propose le sentier des douaniers en Bretagne !', 1),
(2, 1, 2, 'Bonne idée ! Mais un peu loin non ? Restons dans les Vosges pour celle-ci.', 2),
(3, 2, 3, '"La Promesse de l\'aube" de Romain Gary, ça vous dit ?', 3),
(4, 2, 4, 'Oh oui, un classique ! Je vote pour.', 4),
(5, 3, 5, 'Le secret, c\'est le mascarpone de bonne qualité !', 5),
(6, 3, 6, 'Et des biscuits cuillère faits maison !', 6),
(7, 4, 7, 'J\'ai trouvé la fin un peu confuse, mais la photo est incroyable.', 7),
(8, 4, 8, 'Totalement d\'accord, la BO est magistrale aussi.', 8),
(9, 5, 9, 'Je suis dispo samedi après-midi.', 9),
(10, 5, 10, 'Moi aussi, on se retrouve devant à 14h ?', 10),
(11, 6, 11, 'Svelte est génial pour les petits projets, mais pour du lourd, je reste sur React.', 11),
(12, 6, 12, 'Vue a le meilleur des deux mondes je trouve.', 12),
(13, 7, 13, 'Le Parc Borély est parfait le matin.', 13),
(14, 7, 14, 'Oui, et les Calanques pour le coucher du soleil !', 14),
(15, 8, 15, 'N\'oubliez pas le trépied, c\'est indispensable.', 15),
(16, 8, 16, 'Et une télécommande pour éviter le flou de bougé.', 16),
(17, 9, 17, 'Je peux maîtriser une campagne de "L\'Appel de Cthulhu" si vous voulez.', 17),
(18, 9, 18, 'Génial ! Je suis partant !', 18),
(19, 10, 19, 'J\'ai une super baby-sitter à recommander en message privé.', 19),
(20, 10, 20, 'Merci, je suis preneuse !', 20),
(21, 11, 21, 'Il faut absolument visiter les îles Éoliennes.', 21),
(22, 11, 22, 'Et goûter les arancini à Palerme !', 22),
(23, 12, 23, 'Je suis chaud pour un match dimanche !', 23),
(24, 12, 24, 'Moi aussi, on se retrouve au terrain vers 15h ?', 24),
(25, 13, 25, 'J\'ai commencé à faire mes propres produits ménagers, c\'est super simple !', 25),
(26, 13, 26, 'Tu aurais des recettes à partager ?', 26),
(27, 14, 27, 'Une scie japonaise (ryoba) serait parfaite pour ça.', 27),
(28, 14, 28, 'Super, merci du conseil !', 28),
(29, 15, 29, 'J\'ai mes billets ! Hâte d\'y être !', 29),
(30, 15, 30, 'On se retrouve sur place !', 30),
(31, 16, 31, 'Météo France annonce des nuages mais pas de pluie. On maintient !', 1),
(32, 16, 32, 'Parfait, merci pour l\'info.', 2),
(33, 17, 33, 'Je suis intolérante au gluten, est-ce que ce sera pris en compte ?', 3),
(34, 17, 34, 'Oui bien sûr, merci de nous le signaler !', 4),
(35, 18, 35, 'Ça me dit bien, on se retrouve où ?', 5),
(36, 18, 36, 'Devant le ciné à 19h30 pour aller à la pizzeria d\'à côté ?', 6),
(37, 19, 37, 'Je pars de la Place de la République à 14h, j\'ai 3 places.', 7),
(38, 19, 38, 'Super, je t\'en réserve une !', 8),
(39, 20, 39, 'On se retrouve devant la grande scène à 18h ?', 9),
(40, 20, 40, 'Ok, je porterai un chapeau rouge pour être reconnaissable.', 10),
(41, 21, 41, 'Voilà quelques photos de notre belle action ! Bravo à tous.', 11),
(42, 21, 42, 'Incroyable la quantité de déchets... Heureusement qu\'on était là.', 12),
(43, 22, 43, 'On est 5, il manque une personne pour faire 2 équipes !', 13),
(44, 22, 44, 'J\'arrive, je suis là dans 15 minutes !', 14),
(45, 23, 45, 'Peut-on poser des questions à la fin de la conférence ?', 15),
(46, 23, 46, 'Oui, une session de Q&A de 30 minutes est prévue.', 16),
(47, 24, 47, 'J\'amène une quiche lorraine et du houmous !', 17),
(48, 24, 48, 'Génial, moi je m\'occupe des boissons.', 18),
(49, 25, 49, 'Il faut absolument mettre "La Macarena" !', 19),
(50, 25, 50, 'Et du Buena Vista Social Club !', 20),
(51, 26, 51, 'N\'oubliez pas de réserver vos billets en ligne pour éviter la queue.', 21),
(52, 26, 52, 'Le train de 8h15 au départ de Montparnasse est le plus pratique.', 22),
(53, 27, 53, 'Faut-il apporter son propre baudrier ?', 23),
(54, 27, 54, 'Non, tout le matériel est fourni, y compris les chaussons.', 24),
(55, 28, 55, 'Je viens en Chewbacca, et vous ?', 25),
(56, 28, 56, 'Princesse Leia, évidemment !', 26),
(57, 29, 57, 'Ok pour le vin chaud ! RDV devant la cathédrale à 20h ?', 27),
(58, 29, 58, 'Ça marche pour moi !', 28),
(59, 30, 59, 'Je pars de la gare, j\'ai 2 places dans ma voiture.', 29),
(60, 30, 60, 'Je veux bien en être, merci !', 30);

INSERT INTO `carpooling` (`id`, `event_id`, `car_type`, `insured_drive`, `price`, `number_place`, `departure_datetime`, `address`, `street_number`, `street_name`, `zip_code`, `city`, `country`, `created_by`) VALUES
(1, 1, 'SUV', 1, 5, 3, '2025-10-18 07:30:00', '10 Place Kléber, 67000 Strasbourg', 10, 'Place Kléber', '67000', 'Strasbourg', 'France', 1),
(2, 3, 'Citadine', 1, 3, 2, '2025-10-25 19:45:00', 'Gare de Lille Flandres', NULL, 'Place des Buisses', '59000', 'Lille', 'France', 2),
(3, 8, 'Berline', 1, 0, 4, '2025-11-01 14:00:00', '25 Rue des Hallebardes, Strasbourg', 25, 'Rue des Hallebardes', '67000', 'Strasbourg', 'France', 3),
(4, 9, 'Monospace', 1, 8, 4, '2026-06-12 16:00:00', 'Place de la Mairie, Rennes', NULL, 'Place de la Mairie', '35000', 'Rennes', 'France', 4),
(5, 10, 'Citadine', 0, 2, 3, '2025-11-08 09:30:00', 'Vieux-Port, Marseille', NULL, 'Quai des Belges', '13001', 'Marseille', 'France', 5),
(6, 13, 'Électrique', 1, 10, 2, '2025-11-19 18:00:00', 'Châtelet-Les Halles, Paris', NULL, NULL, '75001', 'Paris', 'France', 6),
(7, 16, 'Break', 1, 4, 3, '2025-11-30 08:00:00', 'Place du Capitole, Toulouse', 1, 'Place du Capitole', '31000', 'Toulouse', 'France', 7),
(8, 17, 'Utilitaire', 1, 15, 2, '2026-05-22 07:00:00', 'Gare de Tours', NULL, NULL, '37000', 'Tours', 'France', 8),
(9, 18, 'SUV', 1, 20, 3, '2026-08-12 19:00:00', 'Aix-en-Provence Centre', NULL, 'Cours Mirabeau', '13100', 'Aix-en-Provence', 'France', 9),
(10, 20, 'Citadine', 1, 3, 3, '2025-12-13 20:00:00', 'Place de la Bastille, Paris', NULL, NULL, '75004', 'Paris', 'France', 10),
(11, 21, 'Berline', 1, 0, 2, '2025-12-07 15:00:00', 'Gare de Colmar', NULL, NULL, '68000', 'Colmar', 'France', 11),
(12, 24, 'Cabriolet', 1, 7, 1, '2026-08-08 12:00:00', 'Place de la Comédie, Montpellier', 1, 'Place de la Comédie', '34000', 'Montpellier', 'France', 12),
(13, 26, 'Monospace', 1, 5, 4, '2026-05-16 08:30:00', 'Gare Montparnasse, Paris', NULL, NULL, '75014', 'Paris', 'France', 13),
(14, 29, 'Break', 1, 5, 2, '2025-10-26 08:00:00', 'Gare de Lyon, Paris', NULL, NULL, '75012', 'Paris', 'France', 14),
(15, 1, 'Berline', 1, 5, 2, '2025-10-18 07:15:00', 'Gare de Strasbourg', NULL, NULL, '67000', 'Strasbourg', 'France', 15);

INSERT INTO `ticket` (`id`, `event_id`, `ticket_id`, `pricing`, `free_quantity`, `created_by`) VALUES
(1, 2, 1, 45.00, NULL, 1),
(2, 3, 2, 8.50, NULL, 2),
(3, 5, 3, 15.00, 50, 3),
(4, 9, 4, 35.00, NULL, 4),
(5, 9, 5, 60.00, NULL, 5),
(6, 12, 6, 5.00, 10, 6),
(7, 13, 7, 20.00, NULL, 7),
(8, 19, 8, 25.00, NULL, 8),
(9, 20, 9, 22.00, NULL, 9),
(10, 23, 10, 30.00, NULL, 10),
(11, 26, 11, 27.00, 100, 11),
(12, 27, 12, 18.00, NULL, 12),
(13, 28, 13, 40.00, NULL, 13),
(14, 2, 14, 40.00, 5, 14),
(15, 5, 15, 12.00, NULL, 15);

INSERT INTO `product` (`id`, `event_id`, `product_id`, `name`, `quantity`, `arrival_time`, `created_by`) VALUES
(1, 14, 1, 'Quiches', 5, '2026-07-04 12:00:00', 1),
(2, 14, 2, 'Salades composées', 8, '2026-07-04 12:00:00', 2),
(3, 14, 3, 'Packs de bières', 10, '2026-07-04 12:00:00', 3),
(4, 14, 4, 'Bouteilles de rosé', 12, '2026-07-04 12:00:00', 4),
(5, 14, 5, 'Jus de fruits', 10, '2026-07-04 12:00:00', 5),
(6, 14, 6, 'Gâteaux au chocolat', 4, '2026-07-04 12:30:00', 6),
(7, 14, 7, 'Chips', 20, '2026-07-04 11:45:00', 7),
(8, 22, 8, 'Soupe de potimarron', 1, '2025-11-16 12:00:00', 8),
(9, 22, 9, 'Velouté de carottes au cumin', 1, '2025-11-16 12:00:00', 9),
(10, 22, 10, 'Soupe à l\'oignon', 1, '2025-11-16 12:00:00', 10),
(11, 14, 11, 'Nappes', 5, NULL, 11),
(12, 14, 12, 'Sacs poubelle', 10, NULL, 12);

INSERT INTO `album` (`id`, `album_name`, `event_id`, `group_id`, `created_by`) VALUES
(1, 'Nos plus belles randonnées', NULL, 1, 1),
(2, 'Ateliers de cuisine 2025', NULL, 3, 2),
(3, 'Sorties photo en Alsace', NULL, 8, 3),
(4, 'Soirées jeux', NULL, 9, 4),
(5, 'Voyage en Toscane', NULL, 11, 5),
(6, 'Matchs de la saison', NULL, 12, 6),
(7, 'Concerts de l\'été', NULL, 15, 7),
(8, 'Visites de Châteaux', NULL, 20, 8),
(9, 'Jardins sur balcons', NULL, 21, 9),
(10, 'Nos courses matinales', NULL, 22, 10),
(11, 'Nuits d\'observation', NULL, 24, 11),
(12, 'Tournois de volley', NULL, 25, 12),
(13, 'Nos compagnons à 4 pattes', NULL, 26, 13),
(14, 'La Grande Traversée des Alpes à vélo', NULL, 29, 14),
(15, 'Rencontres linguistiques', NULL, 30, 15),
(16, 'Souvenirs du Lac Blanc', 1, NULL, 16),
(17, 'Les mains à la pâte', 2, NULL, 17),
(18, 'Yoga au soleil', 7, NULL, 18),
(19, 'Festival Rock Indé 2026', 9, NULL, 19),
(20, 'Opération Plage Propre', 10, NULL, 20),
(21, 'Pique-nique à la Tête d\'Or', 14, NULL, 21),
(22, 'Soirée Salsa', 15, NULL, 22),
(23, 'Weekend sur la Loire', 17, NULL, 23),
(24, 'La Nuit des Étoiles', 18, NULL, 24),
(25, 'Marathon Star Wars', 20, NULL, 25),
(26, 'Magie de Noël à Strasbourg', 21, NULL, 26),
(27, 'Tournoi de Beach Volley', 24, NULL, 27),
(28, 'Karaoké', 25, NULL, 28),
(29, 'Une journée à Versailles', 26, NULL, 29),
(30, 'VTT en forêt', 29, NULL, 30);

INSERT INTO `photo` (`id`, `album_id`, `photo_id`, `picture_link`, `created_by`) VALUES
(1, 1, 'rando_1_1', 'https://picsum.photos/seed/photo1/800/600', 1),
(2, 1, 'rando_1_2', 'https://picsum.photos/seed/photo2/800/600', 2),
(3, 2, 'cuisine_2_1', 'https://picsum.photos/seed/photo3/800/600', 3),
(4, 2, 'cuisine_2_2', 'https://picsum.photos/seed/photo4/800/600', 4),
(5, 3, 'alsace_3_1', 'https://picsum.photos/seed/photo5/800/600', 5),
(6, 3, 'alsace_3_2', 'https://picsum.photos/seed/photo6/800/600', 6),
(7, 4, 'jeux_4_1', 'https://picsum.photos/seed/photo7/800/600', 7),
(8, 4, 'jeux_4_2', 'https://picsum.photos/seed/photo8/800/600', 8),
(9, 5, 'toscane_5_1', 'https://picsum.photos/seed/photo9/800/600', 9),
(10, 5, 'toscane_5_2', 'https://picsum.photos/seed/photo10/800/600', 10),
(11, 6, 'basket_6_1', 'https://picsum.photos/seed/photo11/800/600', 11),
(12, 6, 'basket_6_2', 'https://picsum.photos/seed/photo12/800/600', 12),
(13, 7, 'concerts_7_1', 'https://picsum.photos/seed/photo13/800/600', 13),
(14, 7, 'concerts_7_2', 'https://picsum.photos/seed/photo14/800/600', 14),
(15, 8, 'chateaux_8_1', 'https://picsum.photos/seed/photo15/800/600', 15),
(16, 8, 'chateaux_8_2', 'https://picsum.photos/seed/photo16/800/600', 16),
(17, 9, 'jardins_9_1', 'https://picsum.photos/seed/photo17/800/600', 17),
(18, 9, 'jardins_9_2', 'https://picsum.photos/seed/photo18/800/600', 18),
(19, 10, 'running_10_1', 'https://picsum.photos/seed/photo19/800/600', 19),
(20, 10, 'running_10_2', 'https://picsum.photos/seed/photo20/800/600', 20),
(21, 11, 'etoiles_11_1', 'https://picsum.photos/seed/photo21/800/600', 21),
(22, 11, 'etoiles_11_2', 'https://picsum.photos/seed/photo22/800/600', 22),
(23, 12, 'volley_12_1', 'https://picsum.photos/seed/photo23/800/600', 23),
(24, 12, 'volley_12_2', 'https://picsum.photos/seed/photo24/800/600', 24),
(25, 13, 'animaux_13_1', 'https://picsum.photos/seed/photo25/800/600', 25),
(26, 13, 'animaux_13_2', 'https://picsum.photos/seed/photo26/800/600', 26),
(27, 14, 'velo_14_1', 'https://picsum.photos/seed/photo27/800/600', 27),
(28, 14, 'velo_14_2', 'https://picsum.photos/seed/photo28/800/600', 28),
(29, 15, 'tandem_15_1', 'https://picsum.photos/seed/photo29/800/600', 29),
(30, 15, 'tandem_15_2', 'https://picsum.photos/seed/photo30/800/600', 30),
(31, 16, 'lacblanc_16_1', 'https://picsum.photos/seed/photo31/800/600', 1),
(32, 16, 'lacblanc_16_2', 'https://picsum.photos/seed/photo32/800/600', 2),
(33, 17, 'pates_17_1', 'https://picsum.photos/seed/photo33/800/600', 3),
(34, 17, 'pates_17_2', 'https://picsum.photos/seed/photo34/800/600', 4),
(35, 18, 'yoga_18_1', 'https://picsum.photos/seed/photo35/800/600', 5),
(36, 18, 'yoga_18_2', 'https://picsum.photos/seed/photo36/800/600', 6),
(37, 19, 'festival_19_1', 'https://picsum.photos/seed/photo37/800/600', 7),
(38, 19, 'festival_19_2', 'https://picsum.photos/seed/photo38/800/600', 8),
(39, 20, 'nettoyage_20_1', 'https://picsum.photos/seed/photo39/800/600', 9),
(40, 20, 'nettoyage_20_2', 'https://picsum.photos/seed/photo40/800/600', 10),
(41, 21, 'pique-nique_21_1', 'https://picsum.photos/seed/photo41/800/600', 11),
(42, 21, 'pique-nique_21_2', 'https://picsum.photos/seed/photo42/800/600', 12),
(43, 22, 'salsa_22_1', 'https://picsum.photos/seed/photo43/800/600', 13),
(44, 22, 'salsa_22_2', 'https://picsum.photos/seed/photo44/800/600', 14),
(45, 23, 'loire_23_1', 'https://picsum.photos/seed/photo45/800/600', 15),
(46, 23, 'loire_23_2', 'https://picsum.photos/seed/photo46/800/600', 16),
(47, 24, 'nuitetoiles_24_1', 'https://picsum.photos/seed/photo47/800/600', 17),
(48, 24, 'nuitetoiles_24_2', 'https://picsum.photos/seed/photo48/800/600', 18),
(49, 25, 'marathon_25_1', 'https://picsum.photos/seed/photo49/800/600', 19),
(50, 25, 'marathon_25_2', 'https://picsum.photos/seed/photo50/800/600', 20),
(51, 26, 'noel_26_1', 'https://picsum.photos/seed/photo51/800/600', 21),
(52, 26, 'noel_26_2', 'https://picsum.photos/seed/photo52/800/600', 22),
(53, 27, 'beachvolley_27_1', 'https://picsum.photos/seed/photo53/800/600', 23),
(54, 27, 'beachvolley_27_2', 'https://picsum.photos/seed/photo54/800/600', 24),
(55, 28, 'karaoke_28_1', 'https://picsum.photos/seed/photo55/800/600', 25),
(56, 28, 'karaoke_28_2', 'https://picsum.photos/seed/photo56/800/600', 26),
(57, 29, 'versailles_29_1', 'https://picsum.photos/seed/photo57/800/600', 27),
(58, 29, 'versailles_29_2', 'https://picsum.photos/seed/photo58/800/600', 28),
(59, 30, 'vtt_30_1', 'https://picsum.photos/seed/photo59/800/600', 29),
(60, 30, 'vtt_30_2', 'https://picsum.photos/seed/photo60/800/600', 30);

INSERT INTO `poll` (`id`, `poll_id`, `title`, `description`, `start_date`, `end_date`, `is_active`, `created_by`) VALUES
(1, 1, 'Destination de la prochaine grande randonnée', 'Choisissez notre destination pour le weekend de 3 jours en mai.', '2025-10-10 10:00:00', '2025-11-10 10:00:00', 1, 1),
(2, 2, 'Thème du prochain atelier cuisine', 'Qu\'aimeriez-vous apprendre à cuisiner le mois prochain ?', '2025-10-15 18:00:00', '2025-10-30 18:00:00', 1, 2),
(3, 3, 'Film pour la soirée ciné en plein air', 'Quel film projetons-nous pour notre grand événement de l\'été ?', '2026-04-01 12:00:00', '2026-05-01 12:00:00', 1, 3),
(4, 4, 'Meilleur jour pour les soirées jeux', 'Quel soir de la semaine vous arrange le plus ?', '2025-10-09 12:00:00', '2025-10-20 12:00:00', 1, 4),
(5, 5, 'Prochain framework JS à aborder', 'Sur quelle technologie devrions-nous organiser notre prochain meetup ?', '2025-11-01 09:00:00', '2025-11-15 09:00:00', 1, 5),
(6, 6, 'Date pour le weekend vélo', 'Quel weekend de mai préférez-vous pour notre sortie le long de la Loire ?', '2026-02-01 00:00:00', '2026-02-28 23:59:00', 1, 6),
(7, 7, 'Vote pour le livre de Décembre', 'Lisons un classique pour les fêtes !', '2025-11-05 00:00:00', '2025-11-20 00:00:00', 1, 7),
(8, 8, 'Améliorations pour le groupe', 'Que pouvons-nous faire pour améliorer la vie du groupe ? (sondage anonyme)', '2025-10-01 00:00:00', '2025-12-31 00:00:00', 1, 8),
(9, 9, 'T-shirt du club de basket', 'Choisissez le design de notre futur maillot.', '2025-10-20 00:00:00', '2025-11-05 00:00:00', 0, 9),
(10, 10, 'Activité pour le team building', 'Quelle activité pour notre sortie d\'entreprise ?', '2025-09-01 00:00:00', '2025-09-15 00:00:00', 0, 10);

-- ** Readability Improvement: Grouped INSERTs for poll questions and answers **
INSERT INTO `poll_question` (`id`, `poll_id`, `question_id`, `content`, `created_by`) VALUES 
(1, 1, 1, 'Quelle chaîne de montagnes préférez-vous ?', 1),
(2, 2, 2, 'Quelle cuisine vous tente le plus ?', 2),
(3, 4, 3, 'Quel jour vous convient le mieux ?', 4);

INSERT INTO `poll_answer` (`id`, `question_id`, `answer_id`, `answer_content`) VALUES
(1, 1, 1, 'Les Alpes (Vercors)'),
(2, 1, 2, 'Les Pyrénées (GR10)'),
(3, 1, 3, 'Le Massif Central (Auvergne)'),
(4, 1, 4, 'Le Jura'),
(5, 2, 5, 'Cuisine vietnamienne (Bo bun, Nems)'),
(6, 2, 6, 'Cuisine mexicaine (Tacos, Guacamole)'),
(7, 2, 7, 'Cuisine libanaise (Mezze)'),
(8, 2, 8, 'Cuisine indienne (Curry, Naan)'),
(9, 3, 9, 'Mercredi soir'),
(10, 3, 10, 'Jeudi soir'),
(11, 3, 11, 'Vendredi soir'),
(12, 3, 12, 'Samedi soir');

INSERT INTO `user_group_membership` (`user_id`, `group_id`, `role`, `join_date`) VALUES
(1, 1, 'admin', '2024-01-15'), (1, 2, 'member', '2024-03-22'),
(2, 2, 'admin', '2024-02-01'), (2, 5, 'member', '2024-05-10'),
(3, 3, 'admin', '2024-01-20'), (3, 1, 'member', '2024-06-01'),
(4, 4, 'admin', '2024-03-05'),
(5, 5, 'admin', '2024-02-18'), (5, 20, 'member', '2024-07-11'),
(6, 6, 'admin', '2024-04-12'),
(7, 7, 'admin', '2024-05-01'), (7, 25, 'member', '2024-08-03'),
(8, 8, 'admin', '2024-03-16'),
(9, 9, 'admin', '2024-02-25'), (9, 23, 'member', '2024-09-09'),
(10, 10, 'admin', '2024-06-10'),
(11, 3, 'member', '2024-07-15'), (12, 7, 'member', '2024-08-20'),
(13, 12, 'member', '2024-09-01'), (14, 8, 'member', '2024-10-05'),
(15, 1, 'member', '2024-11-10'), (16, 17, 'member', '2025-01-12'),
(17, 29, 'member', '2025-02-20'), (18, 19, 'member', '2025-03-18'),
(19, 9, 'member', '2025-04-01'), (20, 4, 'member', '2025-05-05'),
(21, 15, 'member', '2025-06-11'), (22, 16, 'member', '2025-07-23'),
(23, 13, 'member', '2025-08-08'), (24, 24, 'member', '2025-09-14'),
(25, 25, 'member', '2025-10-02'), (26, 26, 'admin', '2024-01-01'),
(27, 27, 'admin', '2024-09-15'), (28, 28, 'admin', '2024-10-30'),
(29, 29, 'admin', '2024-11-20'), (30, 30, 'admin', '2025-01-05');

INSERT INTO `user_event_participation` (`user_id`, `event_id`, `joined_at`) VALUES
(1, 1, '2025-10-01'), (1, 14, '2026-06-20'),
(2, 5, '2025-11-01'), (2, 26, '2026-04-15'),
(3, 2, '2025-11-10'), (3, 14, '2026-06-22'),
(4, 3, '2025-10-15'), (4, 20, '2025-12-01'),
(5, 7, '2025-10-10'), (5, 10, '2025-11-01'),
(6, 6, '2025-10-20'), (6, 13, '2025-11-05'),
(7, 7, '2025-10-11'), (8, 8, '2025-10-25'),
(9, 4, '2025-11-01'), (9, 9, '2026-05-15'),
(10, 22, '2025-11-10'), (11, 2, '2025-11-12'),
(12, 10, '2025-11-02'), (13, 11, '2025-10-20'),
(14, 21, '2025-12-01'), (15, 1, '2025-10-05'),
(16, 23, '2025-11-15'), (17, 29, '2025-10-18'),
(18, 15, '2026-07-10'), (19, 19, '2025-11-28'),
(20, 3, '2025-10-16'), (21, 9, '2026-05-20'),
(22, 12, '2025-11-15'), (23, 16, '2025-11-20'),
(24, 24, '2026-07-30'), (25, 10, '2025-11-03'),
(26, 14, '2026-06-25'), (27, 27, '2025-11-18'),
(28, 28, '2025-11-25'), (29, 17, '2026-04-01'),
(30, 30, '2025-11-01');

INSERT INTO `user_event_organizer` (`user_id`, `event_id`) VALUES
(1, 1), (3, 2), (4, 3), (9, 4), (2, 5), (6, 6), (7, 7), (8, 8), (21, 9), (5, 10);

INSERT INTO `driver_carpooling` (`user_id`, `carpooling_id`) VALUES
(8, 1), (4, 2), (14, 3), (21, 4), (12, 5), (6, 6), (13, 7), (29, 8), (24, 9), (1, 10);

INSERT INTO `passenger_carpooling` (`user_id`, `carpooling_id`) VALUES
(1, 1), (15, 1), (20, 2), (1, 3), (9, 4), (25, 5), (2, 6), (19, 7), (2, 8), (4, 10);

INSERT INTO `user_ticket_purchase` (`user_id`, `ticket_id`) VALUES
(3, 1), (11, 1), (4, 2), (2, 3), (9, 4), (21, 4), (22, 6), (6, 7), (19, 8), (4, 9), (16, 10), (2, 11), (27, 12), (28, 13);

INSERT INTO `user_product_contribution` (`user_id`, `product_id`) VALUES
(1, 1), (3, 2), (26, 3), (1, 4), (11, 5), (3, 6), (26, 7), (10, 8), (1, 9), (3, 10);

INSERT INTO `user_poll_creation` (`user_id`, `poll_id`) VALUES
(1, 1), (3, 2), (4, 3), (9, 4), (6, 5), (29, 6), (2, 7), (1, 8), (13, 9), (1, 10);

INSERT INTO `user_photo_upload` (`user_id`, `photo_id`) VALUES
(1, 1), (1, 2), (3, 3), (3, 4), (8, 5), (8, 6), (9, 7), (9, 8), (1, 31), (3, 33), (7, 35), (21, 37);

INSERT INTO `user_album_contribution` (`user_id`, `album_id`) VALUES
(1, 1), (3, 2), (8, 3), (9, 4), (1, 16), (3, 17), (7, 18), (21, 19);

INSERT INTO `user_thread_creation` (`user_id`, `thread_id`) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (1, 16), (3, 17), (4, 18);

INSERT INTO `user_message_authorship` (`user_id`, `message_id`) VALUES
(15, 1), (1, 2), (2, 3), (5, 4), (3, 5), (11, 6), (1, 31), (1, 32), (3, 33), (2, 34);

INSERT INTO `user_poll_answer` (`user_id`, `poll_answer_id`) VALUES
(3, 1), (5, 1), (8, 1), (15, 1),
(1, 2), (14, 2),
(4, 5), (9, 5), (11, 5), 
(1, 6), (3, 6), (12, 6), (25, 6),
(9, 11), (19, 11), (1, 11),
(4, 12), (20, 12);

INSERT INTO `api_key_user` (`id`, `username`, `password_hash`, `api_key`, `role`, `permissions`, `created_at`) VALUES
(1, 'admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'APIKEY-ADMIN-12345', 'admin', '[\"get-token\", \"view_users\"]', '2025-10-07 16:57:53'),
(2, 'editor', 'ef5e5a1fb95055e0e56cccf98a41e784a132c14e7f6e1ba244302f0e72b29baf', 'APIKEY-EDITOR-55555', 'editor', '[\"get-token\", \"view_users\"]', '2025-10-07 16:57:53'),
(3, 'viewer', '65375049b9e4d7cad6c9ba286fdeb9394b28135a3e84136404cfccfdcc438894', 'APIKEY-VIEWER-67890', 'viewer', '[\"get-token\", \"view_users\"]', '2025-10-07 16:57:53');