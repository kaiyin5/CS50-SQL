CREATE TABLE IF NOT EXISTS passengers (
    "id" INTEGER PRIMARY KEY,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "age" INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS airlines (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "concourse" TEXT NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS flights (
    "id" INTEGER,
    "flight_number" TEXT NOT NULL,
    "airline_id" INTEGER NOT NULL,
    "depart_airport" TEXT NOT NULL,
    "head_airport" TEXT NOT NULL,
    "depart_datetime" TEXT NOT NULL CHECK ("depart_datetime" GLOB '????-??-?? ??:??:??'),
    "arrival_datetime" TEXT NOT NULL CHECK ("arrival_datetime" GLOB '????-??-?? ??:??:??'),
    PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS check_ins (
    "id" INTEGER,
    "datetime" TEXT NOT NULL CHECK ("datetime" GLOB '????-??-?? ??:??:??'),
    "passenger_id" INTEGER NOT NULL,
    "flight_id" INTEGER NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("passenger_id") REFERENCES "passengers"("id"),
    FOREIGN KEY ("flight_id") REFERENCES "flights"("id")
);

