CREATE TABLE IF NOT EXISTS users (
    "id" INTEGER PRIMARY KEY,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "password" TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS schools (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "type" TEXT CHECK("type" IN ('Elementary School', 'Middle School', 'High School', 'Lower School', 'Upper School', 'College', 'University')),
    "location" TEXT NOT NULL,
    "year_founded" INTEGER
);

CREATE TABLE IF NOT EXISTS companies (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "industry" TEXT NOT NULL,
    "location" TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS people_connections (
    "id" INTEGER PRIMARY KEY,
    "following_id" INTEGER NOT NULL,
    "follower_id" INTEGER NOT NULL,
    "date" TEXT NOT NULL CHECK ("date" GLOB '????-??-??'),
    FOREIGN KEY ("following_id") REFERENCES "users"("id"),
    FOREIGN KEY ("follower_id") REFERENCES "users"("id")
);

CREATE TABLE IF NOT EXISTS school_connections (
    "id" INTEGER PRIMARY KEY,
    "user_id" INTEGER NOT NULL,
    "school_id" INTEGER NOT NULL,
    "degree_earned" TEXT NOT NULL,
    "start_date" TEXT NOT NULL,
    "end_date" TEXT NOT NULL,
    FOREIGN KEY ("user_id") REFERENCES "users"("id"),
    FOREIGN KEY ("school_id") REFERENCES "schools"("id")
);

CREATE TABLE IF NOT EXISTS company_connections (
    "id" INTEGER PRIMARY KEY,
    "user_id" INTEGER NOT NULL,
    "company_id" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "start_date" TEXT NOT NULL,
    "end_date" TEXT NOT NULL,
    FOREIGN KEY ("user_id") REFERENCES "users"("id"),
    FOREIGN KEY ("company_id") REFERENCES "companies"("id")
);