/*
- вывести список заказов в виде:

order_id
статус заказа
email пользователя, который оформил заказ
Результат должен быть отсортирован по order_id.
*/

SELECT
	o.id AS order_id,
	o.status AS статус_заказа,
	u.email AS email_пользователя
FROM orders AS o
	JOIN users AS u ON u.id = o.user_id
ORDER BY o.id;

/* - вывести все строки заказов, в которых количество товара больше 1, и показать:
 *
order_item_id
order_id
название товара
количество */
SELECT
	oi.id AS order_item_id,
	oi.order_id AS order_id,
	p.name AS название_товара,
	oi.quantity AS количество
FROM order_items AS oi
	JOIN products AS p ON p.id = oi.product_id
WHERE oi.quantity > 1;


/*- показать все товары, которые встречаются в заказах пользователя с id = 1. В результате вывести:

order_id
название товара
количество
цену на момент покупки */
SELECT
	o.id AS order_id,
	p.name AS название_товара,
	oi.quantity AS количество,
	oi.unit_price AS цена_на_момент_покупки
FROM orders AS o
	JOIN order_items AS oi ON o.id = oi.order_id
	JOIN products AS p ON p.id = oi.product_id
WHERE o.user_id  = 1;



/* - вывести все заказы со статусом NEW вместе с именем пользователя, который их оформил. В результате нужны:

order_id
status
user_name */

SELECT
	o.id AS order_id,
	o.status,
	u.name AS user_name
FROM orders AS o
 	JOIN users AS u ON u.id = o.user_id
 WHERE o.status = 'NEW'
ORDER BY o.id;


/* - для каждой строки заказа вывести:

order_item_id
название товара
количество
line_total, то есть quantity * unit_price */

SELECT
	oi.id AS order_item_id,
	p.name AS название_товара,
	oi.quantity AS количество,
	oi.quantity  * oi.unit_price AS line_total
FROM order_items AS oi
	JOIN	products AS p ON p.id = oi.product_id
ORDER BY oi.id ;