create database day_14;
use day_14;

-- Given a table of transactions and products, write a function to get the month_over_month change in revenue for the year 2019. 
-- Make sure to round month_over_month to 2 decimal places.

CREATE TABLE products (
id INT PRIMARY KEY,
price DECIMAL(10, 2)
);

INSERT INTO products (id, price) VALUES
(101, 20.00),
(102, 15.00),
(103, 30.00);

CREATE TABLE transactions (
id INT PRIMARY KEY,
product_id INT,
quantity INT,
created_at TIMESTAMP,
FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO transactions (id, product_id, quantity, created_at) VALUES
(1, 101, 2, '2019-01-15 10:00:00'),
(2, 102, 1, '2019-01-20 12:30:00'),
(3, 101, 3, '2019-02-10 14:00:00'),
(4, 103, 1, '2019-02-25 16:15:00'),
(5, 102, 4, '2019-03-05 09:30:00'),
(6, 101, 1, '2019-03-18 13:45:00');

-- Do not modify the schema or data definitions above

-- Implement your SQL query below, utilizing the provided schema

-- Step 1: Calculate total revenue per transaction by joining transactions with product prices
WITH transaction_revenue AS (
  SELECT 
    transactions.*, 
    products.price,
    transactions.quantity * products.price AS total_amount
  FROM transactions 
  JOIN products 
    ON transactions.product_id = products.id
  WHERE YEAR(transactions.created_at) = 2019
),

-- Step 2: Summarize revenue by month (as integer) for 2019
monthly_revenue AS (
  SELECT 
    MONTH(created_at) AS month, 
    SUM(total_amount) AS monthly_sales
  FROM transaction_revenue 
  GROUP BY MONTH(created_at)
),

-- Step 3: Use LAG to fetch previous month's revenue for month-over-month calculation
revenue_with_lag AS (
  SELECT 
    month, 
    monthly_sales, 
    LAG(monthly_sales) OVER (ORDER BY month) AS prev_month_sales
  FROM monthly_revenue
)

-- Step 4: Calculate month-over-month revenue change as percentage
SELECT 
  month, 
  ROUND(((monthly_sales - prev_month_sales) / prev_month_sales) * 100, 2) AS month_over_month
FROM revenue_with_lag
ORDER BY month;
