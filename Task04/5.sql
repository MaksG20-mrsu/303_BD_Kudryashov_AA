WITH avg_ratings AS (
    SELECT
        m.id,
        m.title,
        m.year,
        AVG(r.rating) AS avg_rating
    FROM movies m
    JOIN ratings r ON r.movie_id = m.id
    GROUP BY m.id, m.title, m.year
)
SELECT
    title,
    year,
    avg_rating,
    RANK() OVER (ORDER BY avg_rating DESC) AS rank
FROM avg_ratings
ORDER BY year, title
LIMIT 20;