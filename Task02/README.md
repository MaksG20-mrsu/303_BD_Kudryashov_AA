# Лабораторная работа 2. Подготовка скриптов для создания таблиц и добавления данных

## Структура файлов данных

- `dataset/movies.csv` — фильмы: `movieId, title, genres` (год хранится внутри `title` в виде `(YYYY)`).
- `dataset/ratings.csv` — оценки: `userId, movieId, rating, timestamp`.
- `dataset/tags.csv` — теги: `userId, movieId, tag, timestamp`.
- `dataset/users.txt` — пользователи, разделитель `|`: `id|name|email|gender|register_date|occupation`.
- `dataset/genres.txt` — справочник жанров (в БД не загружается).
- `dataset/occupation.txt` — справочник профессий (в БД не загружается).

## Требования к окружению

Для корректной работы `db_init.bat` должны быть установлены:

- **Python 3** — интерпретатор `python` (или `python3`) в `PATH`;
- **SQLite 3** — CLI-утилита `sqlite3` в `PATH`;
- **bash** — на Windows используется **Git Bash** (идёт с Git for Windows).

Проверка:

```bash
python --version
sqlite3 --version
```

## make_db_init.py

Утилита генерирует SQL-скрипт `db_init.sql`:

1. удаляет существующие таблицы (`DROP TABLE IF EXISTS`);
2. создаёт таблицы (`CREATE TABLE`);
3. вставляет данные (`INSERT INTO`) из файлов `dataset/`.

Для `movies` год извлекается из `title` регуляркой `\((\d{4})\)` в отдельное поле `year`.
Для `ratings` и `tags` поле `id` — суррогатное (`AUTOINCREMENT`), а `userId`/`movieId`
из CSV отображаются в `user_id`/`movie_id`.

## db_init.bat

```
#!/bin/bash
python3 make_db_init.py
sqlite3 movies_rating.db < db_init.sql
```

Запуск из каталога `Task02`:

```bash
bash db_init.bat
```

После выполнения создаётся заполненная база **`movies_rating.db`**.

## Схема базы данных `movies_rating.db`

- `movies`  — `id` (PK), `title`, `year`, `genres`;
- `ratings` — `id` (PK, автоинкремент), `user_id`, `movie_id`, `rating`, `timestamp`;
- `tags`    — `id` (PK, автоинкремент), `user_id`, `movie_id`, `tag`, `timestamp`;
- `users`   — `id` (PK), `name`, `email`, `gender`, `register_date`, `occupation`.

## Проверка результата

```bash
sqlite3 movies_rating.db ".tables"
sqlite3 movies_rating.db "SELECT COUNT(*) FROM movies;"    -- 9742
sqlite3 movies_rating.db "SELECT COUNT(*) FROM ratings;"   -- 18773
sqlite3 movies_rating.db "SELECT COUNT(*) FROM tags;"      -- 3683
sqlite3 movies_rating.db "SELECT COUNT(*) FROM users;"     -- 943
sqlite3 movies_rating.db "SELECT * FROM movies LIMIT 3;"
```

## Генерируемые файлы

- `db_init.sql` — SQL-скрипт инициализации БД;
- `movies_rating.db` — база SQLite с загруженными данными.
