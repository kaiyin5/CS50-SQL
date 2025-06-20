SELECT "title" AS "hey_title", "air_date" AS "hey_date" FROM "episodes"
WHERE ("air_date" BETWEEN '2002-01-01' AND '2007-12-31'
OR "air_date" BETWEEN '2018-01-01' AND '2023-12-31')
AND "title" LIKE "%Z%";