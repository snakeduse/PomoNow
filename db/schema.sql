-- таблица пользователей
CREATE TABLE users ( id SERIAL PRIMARY KEY, email VARCHAR(255) NOT NULL, password VARCHAR(255) NOT NULL, created_at TIMESTAMP NOT NULL DEFAULT now());

-- таблица с карточками
CREATE TABLE cards ( id SERIAL PRIMARY KEY, title VARCHAR(255) NOT NULL, created_at TIMESTAMP NOT NULL, updated_at TIMESTAMP);

-- таблица связей пользователя с карточками
CREATE TABLE cards_users (id SERIAL PRIMARY KEY, card_id INTEGER REFERENCES cards(id) NOT NULL, user_id INTEGER REFERENCES users(id) NOT NULL);
