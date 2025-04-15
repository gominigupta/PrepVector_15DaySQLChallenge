create database day_13;
use day_13;

-- Given two tables, search_events and users, write a query to find the three age groups (bucketed by decade: 0-9, 10-19, 20-29, …,80-89, 90-99, with the end point included) 
-- with the highest clickthrough rate in 2021. 
-- If two or more groups have the same clickthrough rate, the older group should have priority.
-- Hint: if a user that clicked the link on 1/1/2021 who is 29 years old on that day and has a birthday tomorrow on 2/1/2021, they fall into the [20-29] category. 
-- If the same user clicked on another link on 2/1/2021, he turned 30 and will fall into the [30-39] category.

CREATE TABLE users (
id INTEGER PRIMARY KEY,
name VARCHAR(100),
birthdate DATETIME
);

INSERT INTO users (id, name, birthdate) VALUES
(1, 'Alice', '1995-05-15'),
(2, 'Bob', '1985-03-20'),
(3, 'Charlie', '2005-07-10'),
(4, 'David', '1955-11-30'),
(5, 'Eve', '2015-09-25'),
(6, 'Frank', '1935-02-14'),
(7, 'Grace', '1975-12-01');

CREATE TABLE search_events (
search_id INTEGER PRIMARY KEY,
query VARCHAR(255),
has_clicked BOOLEAN,
user_id INTEGER,
search_time DATETIME,
FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO search_events (search_id, query, has_clicked, user_id, search_time) VALUES

(1, 'travel', TRUE, 1, '2021-03-15 10:00:00'),
(2, 'books', FALSE, 1, '2021-03-15 11:00:00'),
(3, 'cars', TRUE, 2, '2021-05-20 14:30:00'),
(4, 'tech', TRUE, 2, '2021-05-20 15:00:00'),
(5, 'games', FALSE, 3, '2021-07-10 16:45:00'),
(6, 'music', FALSE, 3, '2021-07-10 17:00:00'),
(7, 'retirement', TRUE, 4, '2021-09-05 09:15:00'),
(8, 'health', FALSE, 4, '2021-09-05 10:00:00'),
(9, 'toys', FALSE, 5, '2021-11-25 13:20:00'),
(10, 'genealogy', TRUE, 6, '2021-12-01 11:30:00'),
(11, 'history', TRUE, 6, '2021-12-01 12:00:00'),
(12, 'finance', TRUE, 7, '2021-02-15 08:45:00'),
(13, 'investing', FALSE, 7, '2021-02-15 09:00:00');

-- Do not modify the schema or data definitions above

-- Implement your SQL query below, utilizing the provided schema
-- Step 1: Calculate each user's age at the time of search, only for searches in 2021
WITH age_data_2021 AS (
  SELECT 
    search_id, 
    has_clicked, 
    user_id, 
    search_time,
    birthdate,
    -- Calculate age by subtracting birth year from search year,
    -- and subtracting 1 if the birthday hasn't occurred yet that year
   TIMESTAMPDIFF(YEAR, birthdate, search_time) 
    - (DATE_FORMAT(search_time, '%m-%d') < DATE_FORMAT(birthdate, '%m-%d')) AS age
  FROM search_events se 
  JOIN users u ON se.user_id = u.id
  WHERE YEAR(search_time) = 2021
),

-- Step 2: Bucket users into age groups based on their age at time of search
age_buckets AS (
  SELECT *, 
    CASE 
      WHEN age BETWEEN 0 AND 9 THEN '0-9'
      WHEN age BETWEEN 10 AND 19 THEN '10-19'
      WHEN age BETWEEN 20 AND 29 THEN '20-29'
      WHEN age BETWEEN 30 AND 39 THEN '30-39'
      WHEN age BETWEEN 40 AND 49 THEN '40-49'
      WHEN age BETWEEN 50 AND 59 THEN '50-59'
      WHEN age BETWEEN 60 AND 69 THEN '60-69'
      WHEN age BETWEEN 70 AND 79 THEN '70-79'
      WHEN age BETWEEN 80 AND 89 THEN '80-89'
      WHEN age BETWEEN 90 AND 99 THEN '90-99'
      ELSE 'Invalid age'
    END AS age_group
  FROM age_data_2021
)

-- Step 3: Calculate CTR for each age group and return the top 3
SELECT 
  age_group, 
  ROUND(SUM(has_clicked) * 1.0 / COUNT(*), 2) AS ctr
FROM age_buckets 
GROUP BY age_group
ORDER BY ctr DESC, age_group DESC
LIMIT 3;
