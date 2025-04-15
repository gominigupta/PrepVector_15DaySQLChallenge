create database day_10;
use day_10;

-- A dating website’s schema is represented by a table of people that like other people. The table has three columns. 
-- One column is the user_id, another column is the liker_id which is the user_id of the user doing the liking, 
-- and the last column is the date time that the like occurred.
-- Write a query to count the number of liker’s likers (the users that like the likers) if the liker has one.

CREATE TABLE likes (
user_id VARCHAR(50),
created_at DATETIME,
liker_id VARCHAR(50)
);

INSERT INTO likes (user_id, created_at, liker_id) VALUES
('A', '2024-01-01 10:00:00', 'B'),
('B', '2024-01-01 11:00:00', 'C'),
('B', '2024-01-01 12:00:00', 'D'),
('B', '2024-01-01 13:00:00', 'E'),
('C', '2024-01-02 10:00:00', 'A'),
('D', '2024-01-02 14:00:00', 'E'),
('E', '2024-01-02 15:00:00', 'F'),
('B', '2024-01-03 09:00:00', 'G'),
('H', '2024-01-03 10:00:00', 'A'),
('B', '2024-01-03 11:00:00', 'C'),
('I', '2024-01-03 12:00:00', 'I');

-- Do not modify the schema or data definitions above

-- Implement your SQL query below, utilizing the provided schema

-- Approach 1:  Based on each *liker's* perspective — counting who liked the people *they* liked.

WITH likers_list AS (
  SELECT distinct liker_id as user_id
  FROM likes
  WHERE liker_id<>user_id
),

  likers_liker_cte AS ( 
	SELECT l1.user_id AS liker, l2.liker_id AS Likers_liker
	FROM likers_list l1
	JOIN likes l2
		ON l1.user_id=l2.user_id
	ORDER BY liker
)
SELECT liker AS user, COUNT(distinct likers_liker) AS count
  FROM likers_liker_cte
GROUP BY liker;


-- Approach 2: Based on each *user's* perspective — counting how many liked the people *who liked them*.

WITH Likers AS (
    -- First, we find the likers for each user.
    SELECT DISTINCT user_id, liker_id
    FROM likes
),
LikersLikers AS (
    -- Now, for each liker, find the users who liked them.
    SELECT l1.user_id AS user, COUNT(DISTINCT l2.liker_id) AS count
    FROM Likers l1
    LEFT JOIN likes l2
        ON l1.liker_id = l2.user_id  -- l1's liker is now l2's user_id.
    GROUP BY l1.user_id
)
-- Final result, returning the user and their liker count.
SELECT user, count
FROM LikersLikers
  WHERE count<>0;

