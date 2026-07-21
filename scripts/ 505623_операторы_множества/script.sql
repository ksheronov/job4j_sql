/*- получить общий список идентификаторов пользователей, которые:

либо делали заказы со статусом PAID;
либо делали заказы со статусом NEW.
Колонки результата:

user_id
Требования:

использовать UNION;
дубликаты пользователей должны быть удалены.*/

SELECT
	user_id
FROM orders
WHERE status = 'PAID'

UNION

SELECT
	user_id
FROM	orders
WHERE status = 'NEW' ;

/*
- получить общий список событий из таблиц users, products, orders.

Колонки результата:

entity_type
entity_id
created_at
Требования:

entity_type должен принимать значения: user, product, order
использовать UNION ALL;
результат отсортировать по created_at по убыванию.
*/

SELECT
	'user' AS entity_type,
	id AS entity_id,
	created_at
FROM users

UNION ALL

SELECT
	'product' AS entity_type,
	id AS entity_id,
	created_at
FROM products

UNION ALL

SELECT
	'order' AS entity_type,
	id AS entity_id,
	created_at
FROM orders

ORDER BY created_at DESC;


/*- найти товары, которые:

активны;
и хотя бы раз встречались в заказах.
Колонки результата:

product_id
product_name
Требования:

использовать INTERSECT;
один из запросов должен выбирать активные товары;
второй - товары из order_items.*/

SELECT
	p.id AS product_id,
	p.name AS product_name
FROM products p
WHERE is_active = TRUE

INTERSECT

SELECT
	p.id AS product_id,
	p.name AS product_name
FROM products p
JOIN order_items oi ON oi.product_id = p.id

ORDER BY product_id;

/*- найти активные товары, которые ни разу не встречались в заказах.

Колонки результата:

product_id
product_name
Требования:

использовать EXCEPT;
первый запрос должен возвращать активные товары;
второй - товары, которые есть в order_items.*/

SELECT
	id AS product_id,
	name AS product_name
FROM products
WHERE is_active = TRUE

EXCEPT

SELECT
	p.id AS product_id,
	p.name AS product_name
FROM products p
JOIN order_items oi ON oi.product_id = p.id;

/*- получить общий список пользователей, которые:

либо вообще делали заказы;
либо были созданы после 2025-01-01.
Колонки результата:

user_id
user_name
Требования:

использовать UNION;
не должно быть дублей.*/

SELECT
	u.id AS user_id,
	u.name AS user_name
FROM users u
JOIN orders o ON o.user_id = u.id

UNION

SELECT
	id,
	name
FROM users
WHERE created_at > '2025-01-01'

/*- получить список товаров, которые:

дороже средней цены товаров;
и при этом встречались в заказах.
Колонки результата:

product_id
product_name
price
Требования:

использовать INTERSECT;
в одном из запросов применить подзапрос для средней цены.*/

SELECT
	id AS product_id ,
	name AS product_name,
	price
FROM products
WHERE price > (
	SELECT AVG(price)
    FROM products
)

INTERSECT

SELECT
	p.id,
	p.name,
	p.price
FROM products p
JOIN order_items oi ON oi.product_id = p.id

ORDER BY product_id;

/*- получить список пользователей, которые делали заказы, но не делали заказов со статусом CANCELLED.

Колонки результата:

user_id
user_name
Требования:

использовать EXCEPT;
первый запрос должен вернуть пользователей с любыми заказами;
второй - пользователей с отмененными заказами.*/

SELECT
	u.id,
	u.name
FROM users u
JOIN orders o ON o.user_id = u.id

EXCEPT

SELECT
	u.id,
	u.name
FROM users u
JOIN orders o ON o.user_id = u.id
WHERE o.status = 'CANCELLED'


/*- получить общий список объектов для поиска по названию/имени из таблиц users и products.

Колонки результата:

entity_type
entity_id
display_name
Требования:

для пользователей брать users.name;
для товаров брать products.name;
использовать UNION ALL;
entity_type должен быть user или product.*/

SELECT
	'users' AS entity_type,
	id AS entity_id,
	name AS display_name
FROM users

UNION ALL

SELECT
	'products' AS entity_type,
	id AS entity_id,
	name AS display_name
FROM products
