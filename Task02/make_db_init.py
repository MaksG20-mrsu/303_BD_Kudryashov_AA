import csv
import os
import re

DATASET_DIR = "dataset"
OUTPUT_SQL = "db_init.sql"

YEAR_RE = re.compile(r"\((\d{4})\)\s*$")

# Описание таблиц: имя, [(поле, тип)], файл-источник
TABLES = [
    ("movies", [
        ("id",     "INTEGER PRIMARY KEY"),
        ("title",  "TEXT NOT NULL"),
        ("year",   "INTEGER"),
        ("genres", "TEXT"),
    ], "movies.csv"),
    ("ratings", [
        ("id",        "INTEGER PRIMARY KEY AUTOINCREMENT"),
        ("user_id",   "INTEGER NOT NULL"),
        ("movie_id",  "INTEGER NOT NULL"),
        ("rating",    "REAL NOT NULL"),
        ("timestamp", "INTEGER NOT NULL"),
    ], "ratings.csv"),
    ("tags", [
        ("id",        "INTEGER PRIMARY KEY AUTOINCREMENT"),
        ("user_id",   "INTEGER NOT NULL"),
        ("movie_id",  "INTEGER NOT NULL"),
        ("tag",       "TEXT"),
        ("timestamp", "INTEGER NOT NULL"),
    ], "tags.csv"),
    ("users", [
        ("id",            "INTEGER PRIMARY KEY"),
        ("name",          "TEXT NOT NULL"),
        ("email",         "TEXT"),
        ("gender",        "TEXT"),
        ("register_date", "TEXT"),
        ("occupation",    "TEXT"),
    ], "users.txt"),
]


def sql_escape(value: str) -> str:
    return value.replace("'", "''")


def sql_literal(value: str, ctype: str) -> str:
    """Преобразует строку в SQL-литерал с учётом типа."""
    v = (value or "").strip()
    if v == "":
        return "NULL"
    if "INTEGER" in ctype or "REAL" in ctype:
        # числа пишем как есть (без кавычек)
        # защита: если вдруг не число — вернём NULL
        try:
            if "INTEGER" in ctype:
                int(v)
            else:
                float(v)
            return v
        except ValueError:
            return "NULL"
    return "'" + sql_escape(v) + "'"


def make_create_table(table_name: str, columns) -> str:
    cols_sql = ",\n    ".join(f"{name} {ctype}" for name, ctype in columns)
    return f"CREATE TABLE {table_name} (\n    {cols_sql}\n);\n"


def parse_movies(filepath: str) -> list:
    """movies.csv -> строки для INSERT (id, title, year, genres)."""
    rows = []
    with open(filepath, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for r in reader:
            raw_title = (r.get("title") or "").strip()
            year = None
            m = YEAR_RE.search(raw_title)
            title = raw_title
            if m:
                year = m.group(1)
                title = YEAR_RE.sub("", raw_title).strip()
            rows.append((r.get("movieId"), title, year, r.get("genres")))
    return rows


def parse_ratings(filepath: str) -> list:
    """ratings.csv -> (user_id, movie_id, rating, timestamp)."""
    rows = []
    with open(filepath, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for r in reader:
            rows.append((r.get("userId"), r.get("movieId"),
                         r.get("rating"), r.get("timestamp")))
    return rows


def parse_tags(filepath: str) -> list:
    """tags.csv -> (user_id, movie_id, tag, timestamp)."""
    rows = []
    with open(filepath, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for r in reader:
            rows.append((r.get("userId"), r.get("movieId"),
                         r.get("tag"), r.get("timestamp")))
    return rows


def parse_users(filepath: str) -> list:
    """users.txt (|) -> (id, name, email, gender, register_date, occupation)."""
    rows = []
    with open(filepath, encoding="utf-8") as f:
        for line in f:
            line = line.rstrip("\r\n")
            if not line:
                continue
            parts = line.split("|")
            if len(parts) != 6:
                continue
            rows.append(tuple(parts))
    return rows


PARSERS = {
    "movies.csv":  parse_movies,
    "ratings.csv": parse_ratings,
    "tags.csv":    parse_tags,
    "users.txt":   parse_users,
}


def generate_sql_script() -> None:
    lines = []
    lines.append("-- Автоматически сгенерированный скрипт инициализации БД")
    lines.append("BEGIN TRANSACTION;")
    lines.append("")

    for table_name, columns, filename in TABLES:
        filepath = os.path.join(DATASET_DIR, filename)
        if not os.path.isfile(filepath):
            raise FileNotFoundError(f"Не найден файл данных: {filepath}")

        lines.append(f"-- Таблица {table_name}")
        lines.append(f"DROP TABLE IF EXISTS {table_name};")
        lines.append(make_create_table(table_name, columns))

        parser = PARSERS[filename]
        data = parser(filepath)

        for row in data:
            # сопоставляем значения с колонками по позиции,
            # но пропускаем суррогатный id у ratings/tags — его даст AUTOINCREMENT
            insert_cols = []
            insert_vals = []
            row_iter = iter(row)

            for col_name, col_type in columns:
                if col_name == "id" and table_name in ("ratings", "tags"):
                    continue  # этот id генерируется SQLite
                try:
                    val = next(row_iter)
                except StopIteration:
                    val = None
                insert_cols.append(col_name)
                insert_vals.append(sql_literal(val, col_type))

            sql = "INSERT INTO {} ({}) VALUES ({});".format(
                table_name,
                ", ".join(insert_cols),
                ", ".join(insert_vals),
            )
            lines.append(sql)

        lines.append("")

    lines.append("COMMIT;")

    with open(OUTPUT_SQL, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))
    print(f"SQL-скрипт '{OUTPUT_SQL}' успешно сгенерирован.")


if __name__ == "__main__":
    generate_sql_script()