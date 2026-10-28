SELECT id, name, register_date
FROM users
WHERE substr(name, instr(name, ' ') + 1) LIKE 'A%'
ORDER BY register_date
LIMIT 5;