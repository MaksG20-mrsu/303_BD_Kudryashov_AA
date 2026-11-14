SELECT
    u1.name AS user1,
    u2.name AS user2,
    m.title AS movie
FROM ratings r1
JOIN ratings r2
    ON r1.movie_id = r2.movie_id
   AND r1.user_id < r2.user_id
JOIN users  u1 ON u1.id = r1.user_id
JOIN users  u2 ON u2.id = r2.user_id
JOIN movies m  ON m.id  = r1.movie_id
ORDER BY u1.name, u2.name, m.title
LIMIT 100;