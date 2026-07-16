/*- вывести всех пользователей и количество их заказов, включая пользователей без заказов.

Требования к результату:


user_id
user_name
количество заказов*/
SELECT
	u.id AS user_id,
	u.name AS user_name,
	COUNT(o.id) AS количество_заказов
FROM	users AS u
LEFT JOIN orders AS o ON o.user_id = u.id
GROUP BY u.id,u.name
ORDER BY u.id;

/*
 * - найти заказы, по которым еще не было платежа.

Использовать таблицы:

orders
payments
В результате вывести:


order_id
статус заказа
время создания заказа
Если таблицы payments еще нет, используем структуру из урока и добавляем тестовые данные так, чтобы часть заказов осталась без платежей.
 */
CREATE TABLE payments
(
    id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id   BIGINT         NOT NULL REFERENCES orders (id),
    amount     NUMERIC(12, 2) NOT NULL CHECK (amount > 0),
    status     TEXT           NOT NULL,
    created_at TIMESTAMPTZ    NOT NULL DEFAULT now()
);

INSERT INTO payments (order_id, amount, status)
VALUES (1, 129990.00, 'PAID'),
       (3, 4990.00, 'FAILED');

SELECT
	o.id AS order_id,
	o.status,
	o.created_at
FROM orders AS o
LEFT JOIN payments AS p ON p.order_id = o.id
WHERE p.order_id IS NULL
ORDER BY o.id;


/*
 * - вывести товары, которые встречались хотя бы в одном заказе, и рядом показать, сколько раз они встречались в order_items.

В результате нужны:


product_id
product_name
количество строк заказа, где товар встречался
 */
SELECT
	p.id AS product_id,
	p.name AS product_name,
	COUNT (oi.id) AS количество_строк_заказа
FROM products p
JOIN order_items AS oi ON p.id= oi.product_id
GROUP BY p.id, p.name
ORDER BY p.id;

/*
 *  - вывести все роли и количество пользователей, которым назначена каждая роль.

Требования:
в результат должны попасть и роли без пользователей;
результат отсортировать по коду роли.
 */
SELECT
	r.code AS role_code,
	COUNT (ur.user_id) AS user_count
FROM roles r
LEFT JOIN user_roles ur ON r.id = ur.role_id
GROUP BY r.id, r.code
ORDER BY r.code;

-- найти пользователей, которым не назначена ни одна роль.
SELECT
	u.id,
	u.name
FROM users u
LEFT JOIN user_roles ur ON u.id = ur.user_id
WHERE ur.user_id IS NULL
ORDER BY u.id;

/*
 * - сделать сверочный запрос по ролям и назначениям ролей так, чтобы в результате были видны:

роли, назначенные пользователям;
роли без пользователей;
все пары role ↔ user, которые существуют.
 */
SELECT
    r.id AS role_id,
    r.code,
    ur.user_id
FROM roles AS r
FULL JOIN user_roles AS ur ON ur.role_id = r.id;

/*
 - построить все комбинации “роль × окружение”.

Вывести:


код роли
код окружения
 */
SELECT
    r.code AS role_code,
    e.code AS environment_code
FROM roles AS r
CROSS JOIN environments AS e;

/*

- вывести все категории вместе с именем их родительской категории.

Требования:

корневые категории тоже должны попасть в результат;
для них имя родителя будет NULL.
*/
SELECT
    c.id,
    c.name AS category_name,
    p.name AS parent_category_name
FROM categories AS c
LEFT JOIN categories AS p ON c.parent_id = p.id;
