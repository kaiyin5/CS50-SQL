SELECT "first_name", "last_name", ("salary" / "H") AS "dollars per hit" FROM "players"
JOIN "salaries" ON "salaries"."player_id" = "players"."id"
JOIN "performances" ON "performances"."player_id" = "players"."id"
AND "performances"."year" = "salaries"."year"
WHERE "H" IS NOT NULL AND "H" != 0
AND "performances"."year" = 2001
ORDER BY "dollars per hit", "first_name", "last_name"
LIMIT 10;