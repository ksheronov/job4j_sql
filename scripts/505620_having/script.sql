/*- вывести статусы заказов, по которым количество заказов не меньше 3.

Колонки результата:

status
orders_count
Требования:

использовать таблицу orders;
отфильтровать результат именно после группировки.*/

SELECT
	status,
	COUNT(*)
FROM orders
GROUP BY status
HAVING COUNT(*) >3;


/*
- для каждого пользователя вывести суммарную стоимость всех его заказов, но оставить только тех пользователей, у которых общая сумма заказов больше 10000.

Колонки результата:

user_id
user_name
total_spent
Требования:

использовать таблицы users, orders, order_items;
сумма строки заказа считается как quantity * unit_price;
в результате должны остаться только пользователи, удовлетворяющие условию по сумме.
*/
SELECT
	u.id AS user_id,
	u.name AS user_name,
	SUM(oi.quantity * oi.unit_price) AS total_spent
FROM users u
JOIN orders o ON o.user_id = u.id
JOIN order_items oi ON oi.order_id = o.id
GROUP BY u.id , u.name
HAVING SUM(oi.quantity * oi.unit_price) > 10000;


/*- вывести товары, по которым суммарно продано от 5 единиц и больше, но учитывать только те строки заказа, где unit_price >= 1000.

Колонки результата:

product_id
product_name
total_quantity*/

SELECT
	p.id AS product_id,
	p.name AS product_name,
	SUM(oi.quantity) AS total_quantity
FROM products p
JOIN order_items oi ON oi.product_id = p.id
WHERE oi.unit_price >= 1000
GROUP BY p.id, p.name
HAVING SUM(oi.quantity) >= 5

/*- для каждого пользователя и каждого статуса заказа вывести количество заказов, но оставить только те группы, где количество заказов больше 1.

Колонки результата:

user_id
user_name
status
orders_count*/

SELECT
	u.id AS user_id,
	u.name AS user_name,
	o.status,
	COUNT(*)
FROM users u
JOIN orders o ON o.user_id = u.id
GROUP BY u.id, u.name, o.status
HAVING COUNT(*) > 1;

/*- вывести заказы, в которых суммарно куплено не меньше 4 единиц товара.

Колонки результата:

order_id
total_quantity
Требования:

использовать таблицу order_items;
считать именно суммарное количество единиц в заказе, а не число строк заказа.*/

SELECT
	order_id,
	SUM(quantity) AS total_quantity
FROM order_items
GROUP BY order_id
HAVING SUM(quantity) >= 4;

/*- вывести пользователей, у которых есть хотя бы 2 заказа со статусом PAID.

Колонки результата:

user_id
user_name
paid_orders_count
Требования:

сначала учитывать только заказы со статусом PAID;
затем отфильтровать пользователей по количеству таких заказов.*/

SELECT
	u.id AS USER_id,
	u.name AS user_name,
	COUNT(*) AS paid_orders_count
FROM users u
JOIN orders o ON o.user_id = u.id
WHERE o.status = 'PAID'
GROUP BY u.id , u.name
HAVING COUNT(*) >2


/*- для каждого товара вывести минимальную и максимальную цену продажи из order_items,
 * но оставить только те товары, у которых максимальная цена продажи больше 5000.

Колонки результата:

product_id
product_name
min_unit_price
max_unit_price*/

SELECT
	p.id AS product_id,
	p.name AS product_name,
	MIN(oi.unit_price )AS min_unit_price,
	MAX(oi.unit_price ) AS max_unit_price
FROM products p
JOIN order_items oi ON oi.product_id = p.id
GROUP BY p.id, p.name
HAVING MAX(oi.unit_price ) > 5000;

/*
- вывести статусы заказов, для которых средняя сумма строки заказа больше 2000, но учитывать только заказы, созданные начиная с 1 января 2025 года.

Колонки результата:

status
avg_line_total
Требования:

использовать таблицы orders и order_items;
фильтрацию по дате сделать до группировки;
фильтрацию по среднему значению - после группировки.
*/

SELECT
	o.status,
	AVG(oi.quantity * oi.unit_price) AS avg_line_total
FROM orders o
JOIN order_items oi ON oi.order_id = o.id
WHERE o.created_at >= DATE '2025-01-01'
GROUP BY o.status
HAVING AVG(oi.quantity * oi.unit_price) > 2000;
