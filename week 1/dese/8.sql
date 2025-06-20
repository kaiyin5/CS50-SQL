SELECT "name", "pupils" FROM "districts"
LEFT OUTER JOIN "expenditures" ON "districts"."id" = "expenditures"."district_id"
WHERE "pupils" IS NOT NULL;