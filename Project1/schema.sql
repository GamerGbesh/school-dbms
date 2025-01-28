-- Creating Database
CREATE DATABASE "Retail shop";

-- Creating the customers table
CREATE TABLE IF NOT EXISTS "customers"(
"id" SERIAL PRIMARY KEY,
"name" VARCHAR(40) NOT NULL,
"number" CHAR(13) UNIQUE,
"email" VARCHAR(50) UNIQUE
);

-- Creating the products table
CREATE TABLE IF NOT EXISTS "products"(
"id" SERIAL PRIMARY KEY,
"product_name" VARCHAR(40) NOT NULL UNIQUE,
"stock" INTEGER NOT NULL DEFAULT 0 CHECK("stock" >= 0),
"price" NUMERIC NOT NULL CHECK("price" > 0)
);

-- Creating the orders table
CREATE TABLE IF NOT EXISTS "orders"(
"id" SERIAL PRIMARY KEY,
"customer_id" INTEGER REFERENCES "customers"("id"),
"product_id" INTEGER REFERENCES "products"("id"),
"date_initiated" DATE NOT NULL DEFAULT CURRENT_DATE,
"date_expected" DATE,
"date_delivered" DATE,
"quantity" INTEGER DEFAULT 1 CHECK("quantity" > 0),
"status" VARCHAR(20) DEFAULT 'in progress' CHECK (LOWER("status") IN ('in progress', 'cancelled', 'completed'))
);

-- Creating the shipping table
CREATE TABLE IF NOT EXISTS "shipping"(
"id" SERIAL PRIMARY KEY,
"order_id" INTEGER REFERENCES "orders"("id"),
"date_initiated" DATE NOT NULL DEFAULT CURRENT_DATE,
"date_expected" DATE,
"date_delivered" DATE,
"status" VARCHAR(20) DEFAULT 'in progress' CHECK (LOWER("status") IN ('in progress', 'cancelled', 'completed'))
);

-- Creating a view for the order details
CREATE OR REPLACE VIEW "order details" AS
SELECT "customers"."name" AS "Customer", "products"."product_name" AS "Product", 
"price" AS "Price", "quantity" AS "Quantity", ("price" * "quantity") AS "Subtotal", "status"
FROM "customers"
JOIN "orders" ON "orders"."customer_id" = "customers"."id"
JOIN "products" ON "orders"."product_id" = "products"."id";

-- Creating a view for shipping details
CREATE OR REPLACE VIEW "Shipping Details" AS
SELECT "product_name" AS "Product", "quantity" AS "Quantity", "shipping"."status" AS "Status" FROM "shipping"
JOIN "orders" ON "orders"."id" = "shipping"."order_id"
JOIN "products" ON "products"."id" = "orders"."product_id";