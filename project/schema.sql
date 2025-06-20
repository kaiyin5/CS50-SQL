-- CREATEING TABLES

-- stores essential user information required for the system.
-- data are used for user login, password and email modification, account delete.
CREATE TABLE `users` (
    `id` INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `username` VARCHAR(32) NOT NULL UNIQUE,
    `password` VARCHAR(128) NOT NULL,
    `email` VARCHAR(320) NOT NULL UNIQUE,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `closed` TINYINT NOT NULL DEFAULT 0,
    `closed_date` DATE DEFAULT NULL
);

-- stores interests used for friend matching.
CREATE TABLE `interests` (
    `id` INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `interest` VARCHAR(32) NOT NULL UNIQUE
);

-- stores a user's profile pictures. a user can have multiple.
CREATE TABLE `profile_pictures` (
    `id` INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `user_id` INT UNSIGNED NOT NULL,
    `photo_url` VARCHAR(512) NOT NULL,
    `uploaded_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
);

-- stores user's personal information which are displayed to the public.
CREATE TABLE `user_infos` (
    `user_id` INT UNSIGNED PRIMARY KEY,
    `name` VARCHAR(64) NOT NULL,
    `main_profile_pic_id` INT UNSIGNED DEFAULT NULL,
    `date_of_birth` DATE NOT NULL,
    `location_country` VARCHAR(64),
    `location_city` VARCHAR(64),
    `occupation` VARCHAR(64),
    `education` VARCHAR(64),
    `bio` VARCHAR(600),
    `online` TINYINT NOT NULL DEFAULT 0,
    `last_seen` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`main_profile_pic_id`) REFERENCES `profile_pictures`(`id`) ON DELETE SET NULL
);

-- stores chat information.
CREATE TABLE `chats` (
    `id` INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `user_id_1` INT UNSIGNED NOT NULL,
    `user_id_2` INT UNSIGNED NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(`user_id_1`, `user_id_2`),
    FOREIGN KEY (`user_id_1`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`user_id_2`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    CHECK (`user_id_1` < `user_id_2`) -- avoid same user-pair e.g. (1, 2) and (2, 1)
);

-- stores messages. Each message belongs to a chat.
CREATE TABLE `messages` (
    `id` INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `chat_id` INT UNSIGNED NOT NULL,
    `sender_id` INT UNSIGNED,
    `encrypted_message` TEXT NOT NULL,
    `sent_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `received_time` TIMESTAMP NULL, -- updated upon the receiver action
    FOREIGN KEY (`chat_id`) REFERENCES `chats`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`sender_id`) REFERENCES `users`(`id`) ON DELETE SET NULL
);


-- stores photos sent within chat messages.
CREATE TABLE `chat_photos` (
    `id` INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `message_id` INT UNSIGNED NOT NULL, -- Links to the specific message it's attached to
    `photo_url` VARCHAR(512) NOT NULL,
    `uploaded_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`message_id`) REFERENCES `messages`(`id`) ON DELETE CASCADE
);


-- stores user-interest pair. 
-- a user can have many interests, and an interest can be shared by many users.
CREATE TABLE `user_interest` (
    `user_id` INT UNSIGNED,
    `interest_id` INT UNSIGNED,
    PRIMARY KEY (`user_id`, `interest_id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`interest_id`) REFERENCES `interests`(`id`) ON DELETE CASCADE
);


-- CREATING TRIGGERS AND EVENT

DELIMITER //

CREATE TRIGGER `set_closed_date`
BEFORE UPDATE ON `users`
FOR EACH ROW
BEGIN
    IF NEW.`closed` <> OLD.`closed` AND NEW.`closed` = 1 THEN
            SET NEW.closed_date = NOW();
    ELSEIF NEW.`closed` <> OLD.`closed` AND NEW.`closed` = 0 THEN
            SET NEW.closed_date = NULL;
    END IF;
END //

-- set main profile picture for a user when they upload the first photo to the database
CREATE TRIGGER `set_profile_icon`
AFTER INSERT ON `profile_pictures`
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM `profile_pictures` WHERE `user_id` = NEW.`user_id` = 1) THEN
        UPDATE `user_infos`
        SET `main_profile_pic_id` = NEW.`id`
        WHERE `user_id` = NEW.`user_id` AND `main_profile_pic_id` IS NULL;
    END IF;
END //

DELIMITER ;

DELIMITER //
-- handling account removal on daily basis when pending is finished
-- SHOW VARIABLES LIKE 'event_scheduler'; -- If the result is OFF, run next line to enable event scheduler
-- SET GLOBAL event_scheduler = ON//
CREATE EVENT `delete_old_closed_users`
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP + INTERVAL 5 HOUR
COMMENT 'Deletes user rows where closed_date is more than 30 days in the past and closed = 1'
DO
BEGIN
    DELETE FROM `users`
    WHERE `closed` = 1
      AND `closed_date` IS NOT NULL
      AND NOW() > DATE_ADD(`closed_date`, INTERVAL 30 DAY);
END //

DELIMITER ;

-- CREATING VIEWS

-- only users not pending for account deletion is available in search
CREATE VIEW `searchable_users` AS
SELECT `u`.`id`, `u`.`username`, `ui`.`name` FROM `user_infos` AS `ui`
JOIN `users` AS `u` ON `u`.`id` = `ui`.`user_id`
WHERE `u`.`closed` = 0;

-- CREATING PROCEDURES

delimiter //

-- Finding user given displayed name
CREATE PROCEDURE `find_user`(IN `search_word` VARCHAR(64))
BEGIN
    SET @search_pattern = CONCAT(search_word, '%');
    SELECT `name` FROM `searchable_users`
    WHERE `name` LIKE @search_pattern
    ORDER BY `name`, `username`;
END//

-- Finding user by given interest that a user have
CREATE PROCEDURE `find_user_by_interest`(IN `searcher_id` INT UNSIGNED)
BEGIN
SELECT `name` FROM `searchable_users` AS `su`
WHERE `su`.`id` IN (
    SELECT `user_id` FROM `user_interest` AS `uint`
    WHERE `uint`.`interest_id` IN (
        SELECT `interest_id` FROM `user_interest`
        WHERE `user_id` = `searcher_id`
    )
    AND `user_id` != `searcher_id`
    GROUP BY `user_id`
);
END//
delimiter ;

-- CREATING INDEXES
-- common searchs parameters: username, email, displayed name of user, etc.
CREATE INDEX `username_index` ON `users` (`username`);
CREATE INDEX `email_index` ON `users` (`email`);
CREATE INDEX `user_display_name_index` ON `user_infos` (`name`);

-- speed up photo upload trigger
CREATE INDEX `profile_pic_user_id_index` ON `profile_pictures` (`user_id`);
CREATE INDEX `main_profile_pic_index` ON `user_infos` (`main_profile_pic_id`);

-- useful for chat and message search
CREATE INDEX `chats_users1_index` ON `chats` (`user_id_1`);
CREATE INDEX `chats_users2_index` ON `chats` (`user_id_2`);
CREATE INDEX `messages_chat_index` ON `messages` (`chat_id`);
CREATE INDEX `message_time_index` ON `messages` (`sent_time`);
CREATE INDEX `chatphotos_message_index` ON `chat_photos` (`message_id`);
CREATE INDEX `chatphotos_time_index` ON `chat_photos` (`uploaded_at`);

-- search user by region
CREATE INDEX `country_index` ON `user_infos` (`location_country`);
CREATE INDEX `city_index` ON `user_infos` (`location_city`);