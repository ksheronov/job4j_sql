/*
- для каждого статуса заказа вывести количество заказов.

Колонки результата:

status
orders_count */

SELECT
	status,
	COUNT(*) AS order_count
FROM orders o
GROUP BY status;

/*
- для каждого пользователя вывести общую сумму всех его заказов.

Колонки результата:

user_id
user_name
total_spent
Требования:


использовать таблицы users, orders, order_items;
сумма заказа считается как quantity * unit_price;
если пользователь сделал несколько заказов, нужно суммировать их все.*/

SELECT
	u.id AS user_id,
	u.name AS user_name,
	SUM(oi.quantity * unit_price) AS total_spent
FROM users u
JOIN orders o ON o.user_id = u.id
JOIN order_items oi ON oi.order_id = o.id
GROUP BY u.id, u.name
ORDER BY u.id;

/*- для каждого товара вывести:

сколько раз этот товар встретился в строках заказа;
сколько единиц товара было продано суммарно.
Колонки результата:


product_id
product_name
order_items_count
total_quantity*/


SELECT
	p.id AS product_id,
	p.name AS product_name,
	COUNT(oi.id) AS  order_items_count,
	COALESCE(SUM(oi.quantity), 0) AS total_quantity
FROM products p
LEFT JOIN order_items AS oi ON oi.product_id = p.id
GROUP BY p.id, p.name
ORDER BY p.id;

/*- для каждого заказа вывести:

order_id
количество строк в заказе;
итоговую сумму заказа.
Колонки результата:

order_id
items_count
order_total*/

SELECT
    o.id AS order_id,
    COUNT(oi.id) AS items_count,
    COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS order_total
FROM orders o
LEFT JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id
ORDER BY o.id;

/*- для каждого пользователя и для каждого статуса его заказов вывести количество таких заказов.

Колонки результата:

user_id
user_name
status
orders_count*/

SELECT
	u.id AS user_id,
	u.name AS user_name,
	o.status,
	COUNT(o.id)
FROM users u
LEFT JOIN orders o ON o.user_id = u.id
GROUP BY u.id , u.name, o.status
ORDER BY u.id, o.status;

/*- вывести минимальную, максимальную и среднюю цену продажи по каждому товару на основании order_items.

Колонки результата:

product_id
product_name
min_unit_price
max_unit_price
avg_unit_price*/

SELECT
	p.id AS product_id,
	p.name AS product_name,
	MIN(oi.unit_price) AS min_unit_price,
	MAX(oi.unit_price) AS max_unit_price,
	AVG(oi.unit_price) AS avg_unit_price
FROM products p
JOIN order_items oi ON oi.product_id = p.id
GROUP BY p.id, p.name
ORDER BY p.id;


/*- вывести пользователей и количество их заказов, включая пользователей, у которых заказов нет.

Колонки результата:

user_id
user_name
orders_count*/

SELECT
	u.id AS user_id,
	u.name AS user_name,
	COUNT(o.id) AS orders_count
FROM users u
LEFT JOIN orders o ON o.user_id = u.id
GROUP BY u.id, u.name
ORDER BY u.id;
