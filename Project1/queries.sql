INSERT INTO "customers" ("name", "number", "email") 
VALUES 
('Alice Johnson', '+233256789012', 'alice.johnson@example.com'),
('Bob Smith', '+233543210987', 'bob.smith@example.com'),
('Charlie Brown', '+233207465091', 'charlie.brown@example.com');

INSERT INTO "products" ("product_name", "stock", "price") 
VALUES 
('Laptop', 50, 1200.99),
('Smartphone', 200, 799.49),
('Tablet', 100, 450.00),
('Headphones', 300, 89.99);

INSERT INTO "orders" ("customer_id", "product_id", "date_expected", "date_delivered", "quantity", "status") 
VALUES 
(1, 1, '2024-12-25', null, 2, 'in progress'),
(2, 2, '2024-12-20', null, 1, 'in progress'),
(3, 3, '2024-12-22', '2024-12-22', 3, 'completed');

INSERT INTO "shipping" ("order_id", "date_expected", "date_delivered", "status") 
VALUES 
(1, '2024-12-25', null, 'in progress'),
(2, '2024-12-20', null, 'in progress'),
(3, '2024-12-22', '2024-12-22', 'completed'),
(4, '2024-12-23', null, 'cancelled');


SELECT * FROM "Shipping Details";
SELECT * FROM "order details";

SELECT * FROM "customers";
SELECT * FROM "orders";
SELECT * FROM "products";
SELECT * FROM "shipping";
