SELECT m.id, m.title, m.year, t.tag
FROM tags t
JOIN movies m ON m.id = t.movie_id
ORDER BY m.year, m.title, t.tag
LIMIT 40;