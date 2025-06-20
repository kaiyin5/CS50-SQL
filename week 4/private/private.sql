CREATE TABLE cipher_data (
    "sentence_id" INTEGER,
    "char" INTEGER,
    "length" INTEGER
);

INSERT INTO "cipher_data" ("sentence_id", "char", "length") VALUES
(14, 98, 4),
(114, 3, 5),
(618, 72, 9),
(630, 7, 3),
(932, 12, 5),
(2230, 50, 7),
(2346, 44, 10),
(3041, 14, 5);

CREATE VIEW "message" AS
SELECT substr("sentence", "char", "length") AS "phrase" FROM "sentences"
JOIN "cipher_data" ON "cipher_data"."sentence_id" = "sentences"."id";
