create database day_11;
use day_11;

-- Given a table of song_plays and a table of users, write a query to extract the earliest date each user played their third unique song and order by date played.

CREATE TABLE users (
id INTEGER PRIMARY KEY,
username VARCHAR(50)
);

INSERT INTO users (id, username) VALUES
(1, 'john_doe'),
(2, 'jane_smith'),
(3, 'bob_wilson');

CREATE TABLE song_plays (
id INTEGER PRIMARY KEY,
played_at DATETIME,
user_id INTEGER,
song_id INTEGER
);

INSERT INTO song_plays (id, played_at, user_id, song_id) VALUES
(1, '2024-01-01 10:00:00', 1, 101),
(2, '2024-01-01 14:00:00', 1, 101),
(3, '2024-01-02 09:00:00', 1, 102),
(4, '2024-01-03 16:00:00', 1, 103),
(5, '2024-01-04 11:00:00', 1, 104),
(6, '2024-01-01 09:00:00', 2, 201),
(7, '2024-01-01 15:00:00', 2, 202),
(8, '2024-01-02 10:00:00', 2, 203),
(9, '2024-01-02 14:00:00', 2, 203),
(10, '2024-01-01 12:00:00', 3, 301),
(11, '2024-01-02 13:00:00', 3, 302);

-- Do not modify the schema or data definitions above

-- Implement your SQL query below, utilizing the provided schema

WITH FirstPlay AS (
    -- Step 1: Get the first play date for each user-song pair
    SELECT 
        user_id, 
        song_id, 
        MIN(played_at) AS first_play_date
    FROM song_plays
    GROUP BY user_id, song_id
),
RankedPlays AS (
    -- Step 2: Rank each user's first play of unique songs
    SELECT 
        user_id, 
        song_id, 
        first_play_date, 
        ROW_NUMBER() OVER (PARTITION BY user_id 
  ORDER BY first_play_date) AS play_rank
    FROM FirstPlay
)

-- Step 3: Extract users who played their 3rd unique song
SELECT 
    u.username, 
    rp.song_id, 
    rp.first_play_date AS played_at
FROM RankedPlays rp
  JOIN users u
  ON rp.user_id=u.id
WHERE play_rank = 3
ORDER BY played_at;
