
-- *** The Lost Letter ***
SELECT * FROM "packages" WHERE "from_address_id" = (
    SELECT "id" FROM "addresses" WHERE "address" = '900 Somerville Avenue'
);

SELECT * FROM "addresses" WHERE "id" = 854;

-- *** The Devious Delivery ***
SELECT * FROM "packages" WHERE "from_address_id" IS NULL;

SELECT * FROM "scans" WHERE "package_id" = 5098;

SELECT * FROM "addresses" WHERE "id" = 348;

-- *** The Forgotten Gift ***
SELECT * FROM "packages" WHERE "from_address_id" = (
    SELECT "id" FROM "addresses" WHERE "address" = '109 Tileston Street'
) AND "to_address_id" = (
    SELECT "id" FROM "addresses" WHERE "address" = '728 Maple Place'
);

SELECT * FROM "scans" WHERE "package_id" = 9523;

SELECT * FROM "drivers" WHERE "id" = 17;