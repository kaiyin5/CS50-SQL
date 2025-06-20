-- write a SQL query to display the names of schools, their per-pupil expenditure,
-- and their graduation rate. Sort the schools from greatest per-pupil expenditure to least.
-- If two schools have the same per-pupil expenditure, sort by school name.
SELECT "name", "per_pupil_expenditure", "graduated" FROM "schools"
LEFT JOIN "expenditures" ON "schools"."district_id" = "expenditures"."district_id"
LEFT JOIN "graduation_rates" ON "schools"."id" = "graduation_rates"."school_id"
WHERE "per_pupil_expenditure" IS NOT NULL AND "graduated" IS NOT NULL
ORDER BY "per_pupil_expenditure" DESC, "name";