SELECT
    u.name                                   AS expert,
    m.title                                  AS movie,
    m.year                                   AS year,
    r.rating                                 AS rating,
    date(r.timestamp, 'unixepoch')           AS rating_date
FROM ratings r
JOIN users  u ON u.id = r.user_id
JOIN movies m ON m.id = r.movie_id
ORDER BY u.name, m.title, r.rating
LIMIT 50;