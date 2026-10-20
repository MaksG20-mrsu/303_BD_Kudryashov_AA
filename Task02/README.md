# Лабораторная работа 2
## Структура файлов данных
dataset/movies.csv — фильмы (movieId, title с годом, genres).
dataset/ratings.csv — оценки (userId, movieId, rating, timestamp).
dataset/tags.csv — теги (userId, movieId, tag, timestamp).
dataset/users.txt — пользователи (id|name|email|gender|register_date|occupation).
dataset/genres.txt — справочник жанров (в БД не загружается).
dataset/occupation.txt — справочник профессий (в БД не загружается).

## make_db_init.py
Генерирует SQL-скрипт db_init.sql: DROP TABLE IF EXISTS, CREATE TABLE, INSERT INTO.

## db_init.bat
#!/bin/bash
python make_db_init.py
sqlite3 movies_rating.db < db_init.sql

## movies_rating.db
movies  — id (PK), title, year, genres.
ratings — id (PK, автоинкремент), user_id, movie_id, rating, timestamp.
tags    — id (PK, автоинкремент), user_id, movie_id, tag, timestamp.
users   — id (PK), name, email, gender, register_date, occupation.

## Требования к окружению
Python 3 (команда python или python3 в PATH).
SQLite 3 (команда sqlite3 в PATH).
bash (на Windows — Git Bash).

## Проверка
sqlite3 movies_rating.db ".tables"
sqlite3 movies_rating.db "SELECT COUNT(*) FROM movies;"   -- 9742
sqlite3 movies_rating.db "SELECT COUNT(*) FROM ratings;"  -- 18773
sqlite3 movies_rating.db "SELECT COUNT(*) FROM tags;"     -- 3683
sqlite3 movies_rating.db "SELECT COUNT(*) FROM users;"    -- 943