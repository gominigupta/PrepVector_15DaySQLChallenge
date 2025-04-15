create database day_15;
use day_15;

-- Using the transactions table, identify any payments made at the same merchant with the same credit card for the same amount within 10 minutes of each other. Count such repeated payments.
-- Assumption: The first transaction of such payments should not be counted as a repeated payment. 
-- This means that if a merchant performs 2 transactions with the same credit card and for the same amount within 10 minutes, there will only be 1 repeated payment.

CREATE TABLE transactions (
id INT PRIMARY KEY,
credit_card VARCHAR(20),
merchant VARCHAR(50),
amount DECIMAL(10, 2),
transaction_time DATETIME
);


INSERT INTO transactions (id, credit_card, merchant, amount, transaction_time)
VALUES
(1, '1234-5678-9876', 'Amazon', 50.00, '2025-01-23 10:15:00'),
(2, '1234-5678-9876', 'Amazon', 50.00, '2025-01-23 10:20:00'),
(3, '5678-1234-8765', 'Walmart', 30.00, '2025-01-23 11:00:00'),
(4, '1234-5678-9876', 'Amazon', 50.00, '2025-01-23 10:30:00'),
(5, '5678-1234-8765', 'Walmart', 30.00, '2025-01-23 11:05:00'),
(6, '8765-4321-1234', 'BestBuy', 100.00, '2025-01-23 12:00:00'),
(7, '1234-5678-9876', 'Amazon', 50.00, '2025-01-23 12:10:00');


-- Do not modify the schema or data definitions above

-- Implement your SQL query below, utilizing the provided schema

-- Step 1: Use LAG to get previous transaction time for same card, merchant, and amount
WITH ordered_txns AS (
  SELECT *,
         LAG(transaction_time) OVER (
           PARTITION BY credit_card, merchant, amount 
           ORDER BY transaction_time
         ) AS prev_txn_time
  FROM transactions
),

-- Step 2: Calculate the time difference in minutes
txn_diff AS (
  SELECT *,
         TIMESTAMPDIFF(MINUTE, prev_txn_time, transaction_time) AS diff_in_minutes
  FROM ordered_txns
)

-- Step 3: Count transactions that occurred within 10 minutes of the previous one
SELECT COUNT(*) AS repeated_payment_count
FROM txn_diff
WHERE diff_in_minutes IS NOT NULL AND diff_in_minutes <= 10;



