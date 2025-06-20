-- Inserting testing data
-- Add new users
INSERT INTO `users` (`username`, `password`, `email`)
VALUES ('kaiyinng', 'KaikaiyinyiN', 'kaiyin123456789@email.com'),
    ('cs50quack', 'QuAcK!', 'cs50duck@cs50sql.com'),
    ('webdevguru', 'SecurePass123!', 'webdev.guru@example.com'),
    ('datawiz', 'DataMaster!456', 'data.wizard@example.com');

-- Add new user information
INSERT INTO `user_infos` (`user_id`, `name`, `date_of_birth`, `location_country`)
VALUES (1, 'Kai Yin Ng', '1999-01-11', 'Hong Kong'),
    (2, 'Quack Duck', '2024-02-22', 'Cambridge'),
    (3, 'Web Dev Guru', '1985-07-15', 'Somewhere Cambridge'),
    (4, 'Data Wizard', '1992-11-30', 'Cambridge Somewhere');

-- Add new chat
INSERT INTO `chats` (`user_id_1`, `user_id_2`)
VALUES (1, 2);

-- Add new message
INSERT INTO `messages` (`chat_id`, `sender_id`, `encrypted_message`)
VALUES (1, 2, 'this is encrypted'), 
    (1, 1, 'here come the photo');

-- Add new profile picture
INSERT INTO `profile_pictures` (`user_id`, `photo_url`)
VALUES (1, 'url1.jpg'), 
    (2, 'url2.png');

-- Add new chat photos
INSERT INTO `chat_photos` (`message_id`, `photo_url`)
VALUES (2, 'photo.jpeg'), 
    (2, 'anotherphoto.jpg');

-- Add new interests
INSERT INTO `interests` (`interest`)
VALUES ('Chess'),
    ('Traveling'),
    ('Music'),
    ('Football'),
    ('Reading'),
    ('Cooking'),
    ('Hiking'),
    ('Painting'),
    ('Gaming'),
    ('Dancing'),
    ('Coding');

INSERT INTO `user_interest` (`user_id`, `interest_id`)
VALUES (1, 1), (1, 2), (1, 3), (1, 4),
    (2, 1), (2, 3), (2, 5), (2, 7),
    (3, 3), (3, 5), (3, 7), (3, 9),
    (4, 2), (4, 4), (4, 6), (4, 8);

-- Testing queries

-- Finding user given email
SELECT * FROM `user_infos`
WHERE `user_id` = (
    SELECT `id` FROM `users`
    WHERE `email` = 'cs50duck@cs50sql.com'
);

-- Finding user by username or displayed name using procedure
CALL `find_user`('kai');

-- Finding user with similar interests
CALL `find_user_by_interest`(4);

-- Check if soft deletion is applicable
UPDATE `users` 
SET `closed` = 1
WHERE `id` = 4;

SELECT * FROM `searchable_users`; -- query should not show user with id 4 

SELECT * FROM `users`; -- closed status and closed date is updated

-- Check if main profile picture is set if user uploaded first photo
SELECT * FROM `user_infos`
WHERE `main_profile_pic_id` IS NOT NULL;

INSERT INTO `profile_pictures` (`user_id`, `photo_url`)
VALUES (3, 'trigger_main_profile.png'), 
       (4, 'trigger.png');

SELECT * FROM `user_infos`
WHERE `main_profile_pic_id` IS NOT NULL;

-- Finding users given searching location

SELECT `name` FROM `user_infos`
WHERE `location_country` LIKE 'Cambridge%'
OR `location_city` LIKE 'Cambridge%'
ORDER BY `last_seen` DESC, `name`;

-- Finding messages given user id, check if user acessible
-- Keep lastest messages at the bottom of the chat
SELECT `m` FROM
(
    SELECT `encrypted_message` AS `m`, `sent_time` AS `t` FROM `messages`
    WHERE `chat_id` IN (
        SELECT `id` FROM `chats`
        WHERE `user_id_1` = 1
        OR `user_id_2` = 1
    )
    UNION ALL 
    SELECT `photo_url` AS `m`, `uploaded_at` AS `t` FROM `chat_photos`
    WHERE `message_id` IN (
        SELECT `id` FROM `messages`
        WHERE `chat_id` IN (
            SELECT `id` FROM `chats`
            WHERE `user_id_1` = 1
            OR `user_id_2` = 1
        )
    )
) AS `chat_message`
ORDER BY `t`;