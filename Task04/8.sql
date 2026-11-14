WITH RECURSIVE split(id, rest, genre) AS (
    SELECT id, genres || '|', ''
    FROM movies
    UNION ALL
    SELECT
        id,
        substr(rest, instr(rest, '|') + 1),
        substr(rest, 1, instr(rest, '|') - 1)
    FROM split
    WHERE rest <> ''
)
SELECT DISTINCT genre
FROM split
WHERE genre <> ''
ORDER BY genre;