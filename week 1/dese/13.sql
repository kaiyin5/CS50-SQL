-- find good schools in districts with low per-pupil expenditure
SELECT "name", "graduated", "proficient", "per_pupil_expenditure" FROM "schools"
LEFT JOIN "graduation_rates" ON "graduation_rates"."school_id" = "schools"."id"
LEFT JOIN "staff_evaluations" ON "staff_evaluations"."district_id" = "schools"."district_id"
LEFT JOIN "expenditures" ON "expenditures"."district_id" = "schools"."district_id"
WHERE "graduated" > (
    SELECT AVG("graduated") FROM "graduation_rates")
AND "proficient" > (
    SELECT AVG("proficient") FROM "staff_evaluations")
AND "per_pupil_expenditure" < (
    SELECT AVG("per_pupil_expenditure") FROM "expenditures")
ORDER BY "per_pupil_expenditure", "graduated" DESC, "proficient" DESC
LIMIT 20;