create database day_2;
use day_2;

-- Given a table of transactions and a table of users, 
-- write a query to determine if users tend to order more to their primary address versus other addresses.
-- Note: Return the percentage of transactions ordered to their home address as home_address_percent.

CREATE TABLE transactions (
id INT PRIMARY KEY,
user_id INT,
created_at DATETIME,
shipping_address VARCHAR(255)
);

-- Transactions sample data
INSERT INTO transactions (id, user_id, created_at, shipping_address) VALUES
(1, 1, '2025-01-15 10:30:00', '123 Main St'), 
(2, 1, '2025-01-16 11:45:00', '789 Oak Ave'), 
(3, 2, '2025-01-17 14:20:00', '456 Elm St'), 
(4, 2, '2025-01-18 15:10:00', '123 Pine Rd'), 
(5, 3, '2025-01-19 16:05:00', '789 Oak Ave'), 
(6, 3, '2025-01-20 17:40:00', '123 Main St'),
(7, 3, '2025-01-21 17:45:00', '123 Main St');

CREATE TABLE users (
id INT PRIMARY KEY,
name VARCHAR(255),
address VARCHAR(255)
);

-- Users sample data
INSERT INTO users (id, name, address) VALUES
(1, 'John Doe', '123 Main St'),
(2, 'Jane Smith', '456 Elm St'),
(3, 'Alice Johnson', '789 Oak Ave');

-- Do not modify the schema or data definitions above

-- Implement your SQL query below, utilizing the provided schema

WITH flag_cte AS (
 SELECT t.id, t.user_id, 
 CASE WHEN t.shipping_address = u.address THEN 1 ELSE 0 END AS flag_col
 FROM transactions t 
 JOIN users u ON t.user_id = u.id
)
SELECT 
 (SUM(flag_col)*100 / COUNT(*)) AS home_address_percent 
FROM flag_cte;



