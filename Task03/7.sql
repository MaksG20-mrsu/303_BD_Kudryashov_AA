--- Список профессий с количеством пользователей:
SELECT occupation, COUNT(*) AS cnt
FROM users
GROUP BY occupation
ORDER BY cnt DESC, occupation;

--- Самая распространённая профессия (топ-1):
SELECT occupation, COUNT(*) AS cnt
FROM users
GROUP BY occupation
ORDER BY cnt DESC, occupation
LIMIT 1;

--- Самая редкая профессия (топ-1 по возрастанию):
SELECT occupation, COUNT(*) AS cnt
FROM users
GROUP BY occupation
ORDER BY cnt ASC, occupation
LIMIT 1;
