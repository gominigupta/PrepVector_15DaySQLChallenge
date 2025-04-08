create database day_5;
use day_5;

-- Consider the events table, which contains information about the phases of writing a new social media post.
-- The action column can have values post_enter, post_submit, or post_canceled for when a user starts to write (post_enter), 
-- ends up canceling their post (post_cancel), or posts it (post_submit). Write a query to get the post-success rate 
-- for each day in the month of January 2020.

-- Note: Post Success Rate is defined as the number of posts submitted (post_submit) 
-- divided by the number of posts entered (post_enter) for each day.

CREATE TABLE events (
user_id INT,
created_at DATETIME,
action VARCHAR(20)
);

INSERT INTO events VALUES
(1, '2020-01-01 10:00:00', 'post_enter'),
(1, '2020-01-01 10:05:00', 'post_submit'),
(2, '2020-01-01 11:00:00', 'post_enter'),
(2, '2020-01-01 11:10:00', 'post_canceled'),
(3, '2020-01-01 15:00:00', 'post_enter'),
(3, '2020-01-01 15:30:00', 'post_submit'),
(4, '2020-01-02 09:00:00', 'post_enter'),
(4, '2020-01-02 09:15:00', 'post_canceled'),
(5, '2020-01-02 10:00:00', 'post_enter'),
(5, '2020-01-02 10:10:00', 'post_canceled'),
(10, '2020-01-15 14:00:00', 'post_enter'),
(10, '2020-01-15 14:30:00', 'post_submit'),
(6, '2019-12-31 23:55:00', 'post_enter'),
(6, '2020-01-01 00:05:00', 'post_submit'),
(7, '2020-02-01 00:00:00', 'post_enter'),
(7, '2020-02-01 00:10:00', 'post_submit'),
(8, '2019-01-15 10:00:00', 'post_enter'),
(8, '2019-01-15 10:30:00', 'post_submit'),
(9, '2021-01-01 09:00:00', 'post_enter'),
(9, '2021-01-01 09:10:00', 'post_canceled');

-- Do not modify the schema or data definitions above

-- Implement your SQL query below, utilizing the provided schema

WITH filtered_events AS (
    SELECT 
        user_id, 
        DATE(created_at) AS event_date, 
        action
    FROM events
    WHERE created_at BETWEEN '2020-01-01' AND '2020-01-31'
)

SELECT 
    e1.event_date, 
    COUNT(DISTINCT e1.user_id) AS total_enters,
    COUNT(DISTINCT e2.user_id) AS total_submits,
    ROUND(COUNT(DISTINCT e2.user_id) * 1.0 / COUNT(DISTINCT e1.user_id),2) AS success_rate
FROM filtered_events e1
LEFT JOIN filtered_events e2 
    ON e1.user_id = e2.user_id 
    AND e1.event_date = e2.event_date 
    AND e2.action = 'post_submit'
WHERE e1.action = 'post_enter'
GROUP BY e1.event_date
ORDER BY e1.event_date;


