UPDATE "users"
SET "password" = '982c0381c279d139fd221fce974916e7'
WHERE "username" = 'admin';

UPDATE "user_logs"
SET "new_password" = '44bf025d27eea66336e5c1133c3827f7'
WHERE "id" = (
    SELECT "id" FROM "user_logs"
    WHERE "old_username" = 'admin'
    AND "new_password" = '982c0381c279d139fd221fce974916e7'
    ORDER BY "id" DESC
    LIMIT 1
);