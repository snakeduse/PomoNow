-- таблица пользователей
CREATE TABLE users (
        id SERIAL PRIMARY KEY,
        email VARCHAR(255) NOT NULL,
        password VARCHAR(255) NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT now());

-- таблица с карточками
CREATE TABLE cards (
        id SERIAL PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        created_at TIMESTAMP NOT NULL,
        updated_at TIMESTAMP);

-- таблица связей пользователя с карточками
CREATE TABLE cards_users (
        id SERIAL PRIMARY KEY,
        card_id INTEGER REFERENCES cards(id) NOT NULL,
        user_id INTEGER REFERENCES users(id) NOT NULL);

-- таблица задач
CREATE TABLE tasks (
        id SERIAL PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        is_open BOOLEAN NOT NULL DEFAULT TRUE,
        count_pomodoros INT NOT NULL DEFAULT 0,
        created_at TIMESTAMP NOT NULL DEFAULT now(),
        updated_at TIMESTAMP);

-- таблица связей закач с карточками
CREATE TABLE cards_tasks(
        id SERIAL PRIMARY KEY,
        card_id INTEGER REFERENCES cards(id) NOT NULL,
        task_id INTEGER REFERENCES tasks(id) NOT NULL);
