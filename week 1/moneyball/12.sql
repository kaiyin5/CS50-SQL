SELECT "first_name", "last_name" FROM "players"
WHERE "id" IN
(
    SELECT "players"."id" FROM "players"
    JOIN "salaries" ON "salaries"."player_id" = "players"."id"
    JOIN "performances" ON "performances"."player_id" = "players"."id"
    AND "performances"."year" = "salaries"."year"
    WHERE "RBI" IS NOT NULL AND "RBI" != 0
    AND "performances"."year" = 2001
    ORDER BY "salary" / "RBI"
    LIMIT 10
)
AND "id" IN
(
    SELECT "players"."id" FROM "players"
    JOIN "salaries" ON "salaries"."player_id" = "players"."id"
    JOIN "performances" ON "performances"."player_id" = "players"."id"
    AND "performances"."year" = "salaries"."year"
    WHERE "H" IS NOT NULL AND "H" != 0
    AND "performances"."year" = 2001
    ORDER BY "salary" / "H"
    LIMIT 10
)
ORDER BY "players"."id";