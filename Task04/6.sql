SELECT
    substr(u.name, instr(u.name, ' ') + 1) || ' ' ||
    substr(u.name, 1, instr(u.name, ' ') - 1) || '|' ||
    u.register_date AS "Фамилия Имя|Дата регистрации"
FROM users u
ORDER BY u.register_date DESC
LIMIT 10;