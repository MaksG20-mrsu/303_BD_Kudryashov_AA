SELECT
    COUNT(*)              AS cnt_ratings,
    AVG(r.rating)         AS avg_rating
FROM ratings r
JOIN users u ON u.id = r.user_id
WHERE u.gender = 'female'
  AND strftime('%Y', r.timestamp, 'unixepoch') BETWEEN '2010' AND '2012';