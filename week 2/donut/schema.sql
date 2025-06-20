CREATE TABLE IF NOT EXISTS ingredients (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "price" REAL NOT NULL,
    "per_unit" TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS donuts (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "gluten_free" INTEGER CHECK("gluten_free" IN (0, 1)),
    "price" REAL NOT NULL
);

CREATE TABLE IF NOT EXISTS donut_ingredients (
    "id" INTEGER PRIMARY KEY,
    "donut_id" INTEGER NOT NULL,
    "ingredient_id" INTEGER NOT NULL,
    FOREIGN KEY ("donut_id") REFERENCES "donuts"("id"),
    FOREIGN KEY ("ingredient_id") REFERENCES "ingredients"("id")
);

CREATE TABLE IF NOT EXISTS customers (
    "id" INTEGER PRIMARY KEY,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS customer_orders (
    "id" INTEGER PRIMARY KEY,
    "customer_id" INTEGER NOT NULL,
    "order_id" INTEGER NOT NULL UNIQUE,
    FOREIGN KEY ("customer_id") REFERENCES "customers"("id"),
    FOREIGN KEY ("order_id") REFERENCES "orders"("id")
);

CREATE TABLE IF NOT EXISTS orders (
    "id" INTEGER PRIMARY KEY,
    "customer_id" INTEGER NOT NULL,
    "donut_order_id" INTEGER NOT NULL UNIQUE,
    FOREIGN KEY ("customer_id") REFERENCES "customers"("id"),
    FOREIGN KEY ("donut_order_id") REFERENCES "donut_order"("id")
);

CREATE TABLE IF NOT EXISTS donut_order (
    "id" INTEGER PRIMARY KEY,
    "order_id" INTEGER NOT NULL,
    "donut_id" INTEGER NOT NULL,
    "number" INTEGER NOT NULL CHECK("number" > 0),
    FOREIGN KEY ("donut_id") REFERENCES "donuts"("id"),
    FOREIGN KEY ("order_id") REFERENCES "orders"("id")
);
