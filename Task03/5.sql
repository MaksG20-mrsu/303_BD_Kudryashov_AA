SELECT id, title, year
FROM movies
WHERE year = (SELECT MAX(year) FROM movies)
ORDER BY title;