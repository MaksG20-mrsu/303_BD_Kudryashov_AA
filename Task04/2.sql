WITH latest AS (
    SELECT
        r.user_id,
        r.movie_id,
        r.rating,
        r.timestamp,
        ROW_NUMBER() OVER (
            PARTITION BY r.user_id
            ORDER BY r.timestamp DESC
        ) AS rn
    FROM ratings r
)
SELECT
    u.name                       AS user_name,
    m.title                      AS movie,
    l.rating                     AS rating,
    date(l.timestamp, 'unixepoch') AS rating_date
FROM latest l
JOIN users  u ON u.id = l.user_id
JOIN movies m ON m.id = l.movie_id
WHERE l.rn = 1
ORDER BY l.timestamp DESC
LIMIT 10;