SELECT
    m.title,
    m.year,
    COUNT(*) AS cnt
FROM movies m
JOIN ratings r ON r.movie_id = m.id
JOIN users  u ON u.id = r.user_id
WHERE m.genres LIKE '%Comedy%'
  AND m.year > 2000
  AND u.gender = 'male'
  AND r.rating >= 4.5
GROUP BY m.id, m.title, m.year
ORDER BY m.year, m.title;