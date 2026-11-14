WITH RECURSIVE nums(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM nums WHERE n < 10
),
pairs(a, b) AS (
    SELECT n, 1 FROM nums
    UNION ALL
    SELECT a, b + 1 FROM pairs WHERE b < 10
)
SELECT a || 'x' || b || '=' || (a * b) AS "multiplication"
FROM pairs
ORDER BY a, b;