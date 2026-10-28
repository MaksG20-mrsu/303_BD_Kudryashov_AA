SELECT DISTINCT m.id, m.title, m.year
FROM movies m
JOIN ratings r ON r.movie_id = m.id
ORDER BY m.year, m.title
LIMIT 10;