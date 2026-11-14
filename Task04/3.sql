WITH avg_ratings AS (
    SELECT
        m.id,
        m.title,
        m.year,
        AVG(r.rating) AS avg_rating
    FROM movies m
    JOIN ratings r ON r.movie_id = m.id
    GROUP BY m.id, m.title, m.year
),
bounds AS (
    SELECT
        MAX(avg_rating) AS max_avg,
        MIN(avg_rating) AS min_avg
    FROM avg_ratings
)
SELECT
    a.title,
    a.year,
    a.avg_rating,
    CASE
        WHEN a.avg_rating = b.max_avg THEN 'Да'
        ELSE 'Нет'
    END AS "Рекомендуем"
FROM avg_ratings a
CROSS JOIN bounds b
WHERE a.avg_rating = b.max_avg
   OR a.avg_rating = b.min_avg
ORDER BY a.year, a.title;