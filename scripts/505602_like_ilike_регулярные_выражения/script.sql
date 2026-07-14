/*
 * создание и заполнение данными таблицы vacansies
 */
CREATE TABLE vacancies
(
    id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title       TEXT        NOT NULL,
    company     TEXT        NOT NULL,
    description TEXT,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

INSERT INTO vacancies (title, company, description)
VALUES
('Java Developer', 'Sber', 'Разработка backend-сервисов на Java'),
('GoLang Developer', 'Sber', 'Разработка backend-сервисов на Go'),
('SQL Analyst', 'DataSQL', 'Анализ данных и написание SQL-запросов'),
('Frontend Developer', 'DevTeam', 'Разработка фронтэнда логики'),
('Backend Developer', 'DevTeam', 'Разработка серверной логики'),
('QA Engineer', 'TestLab', 'Тестирование веб-приложений');


/*
 * - вывести всех пользователей, у которых email содержит mail.
 * В результатах отражаем колонки: id, name, email;
 */
SELECT id, name, email
FROM users
WHERE	email ILIKE	'%mail%';

/*
 * - вывести все товары, название которых содержит air.
 *  В результатах отражаем колонки: id, name, price;
 */
SELECT id, name, price
FROM products
WHERE name ILIKE '%air%';


/*
 * - вывести все товары, название которых начинается с i.
 * В результатах отражаем колонки: id, name, price;
 */

SELECT id, name, price
FROM products
WHERE name LIKE 'i%';


/*
 * - вывести все товары, название которых заканчивается на pro.
 * В результатах отражаем колонки: id, name, price;
 */
SELECT id, name, price
FROM products
WHERE name LIKE '%pro';


/*
 * - вывести всех пользователей, у которых имя начинается на A или I,
 * регистр не важен. В результатах отражаем колонки: id, name, email;
 */
SELECT id, name, email
FROM users
WHERE	name ILIKE	'A%' OR name ILIKE	'I%';


/*
 * - вывести все вакансии, где в названии или описании встречается java, go или postgres.
 * В результатах отражаем колонки:  id, title, company, description;
 * сделано в 2х вариантах через ILIKE и REGEX
 */
SELECT id, title, company, description
FROM	vacancies
WHERE title ~* '(java|go|postgres)' OR description ~* '(java|go|postgres)';

SELECT id, title, company, description
FROM vacancies
WHERE title ILIKE '%java%'
   OR title ILIKE '%go%'
   OR title ILIKE '%postgres%'
   OR description ILIKE '%java%'
   OR description ILIKE '%go%'
   OR description ILIKE '%postgres%';


/*
 * - через regex найти товары, название которых начинается с iPhone,
 *  а затем содержит номер модели. В результатах отражаем колонки: id, name, price.
 */
SELECT id, name
FROM products
WHERE name ~* '^iPhone\s*\d+';