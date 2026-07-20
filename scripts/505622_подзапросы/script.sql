/* вывести товары, цена которых меньше средней цены всех товаров.

Колонки результата:

product_id
product_name
price
Требования:

использовать подзапрос в WHERE;
среднюю цену получить через AVG(price).*/

SELECT
	id AS product_id,
	name AS product_name,
	price
FROM products
WHERE price < (
	 SELECT
	 	AVG(price)
	 FROM products p2
);

/*- вывести пользователей, у которых есть хотя бы один заказ со статусом PAID.

Колонки результата:

user_id
user_name
email
Требования:

использовать EXISTS;
подзапрос должен быть связан с внешним запросом по пользователю.*/

SELECT
	u.id AS user_id,
	u.name AS user_id,
	u.email
FROM	users u
WHERE EXISTS (
	SELECT 1
	FROM orders o
	WHERE u.id = o.user_id AND
	o.status = 'PAID'
);

/* вывести пользователей, у которых нет ни одного заказа.

Колонки результата:

user_id
user_name
email
Требования:

использовать NOT EXISTS;
не использовать LEFT JOIN.*/

SELECT
	u.id AS user_id,
	u.name AS user_name,
	u.email
FROM users u
WHERE NOT EXISTS (
	SELECT 1
	FROM orders o
	WHERE u.id = o.user_id
);

/*- вывести товары, которые хотя бы раз встречались в order_items.

Колонки результата:

product_id
product_name
price
Требования:

использовать IN;
подзапрос должен возвращать список product_id.*/

SELECT
	id product_id,
	name product_name,
	price
FROM products
WHERE id IN (
	SELECT
		product_id
	FROM order_items
);

/*- вывести заказы, сумма которых больше 10000.

Колонки результата:

order_id
order_total
Требования:

использовать подзапрос в FROM;
внутри подзапроса посчитать сумму заказа через SUM(quantity * unit_price).*/

SELECT
	t.order_id,
	t.order_total
FROM (
	SELECT
		order_id,
		SUM(quantity * unit_price) AS order_total
	FROM order_items
	GROUP BY order_id
) AS t
WHERE t.order_total > 10000

/*- вывести пользователей и количество их заказов через коррелированный подзапрос в SELECT.

Колонки результата:

user_id
user_name
orders_count
Требования:

не использовать JOIN;
количество заказов считать отдельным подзапросом для каждого пользователя.*/

SELECT
	u.id AS user_id,
	u.name AS user_name ,
	( SELECT COUNT(*)
	  FROM	orders o
	  WHERE	u.id = o.user_id
	) AS orders_count
FROM users u ;

/*- вывести товары, по которым суммарно продано больше, чем среднее количество продаж на товар.

Колонки результата:

product_id
total_quantity
Требования:

использовать GROUP BY;
использовать подзапрос в HAVING;
среднее количество продаж на товар посчитать во внутреннем подзапросе.*/

SELECT
	product_id,
	SUM(quantity) AS total_quantity
FROM
	order_items
GROUP BY
	product_id
HAVING
	SUM(quantity) > (
	SELECT
		AVG (total_quantity)
	FROM
		(
		SELECT
			product_id,
			SUM(quantity) AS total_quantity
		FROM
			order_items
		GROUP BY
			product_id
	   )AS product_totals
);

/*- вывести заказы, у которых сумма выше средней суммы заказа.

Колонки результата:

order_id
order_total
Требования:

использовать подзапрос в FROM для расчета сумм заказов;
использовать скалярный подзапрос для расчета средней суммы заказа.*/

SELECT
    t.order_id,
    t.order_total
FROM (
    SELECT
        order_id,
        SUM(quantity * unit_price) AS order_total
    FROM order_items
    GROUP BY order_id
) AS t
WHERE t.order_total > (
    SELECT AVG(order_total)
    FROM (
        SELECT
            order_id,
            SUM(quantity * unit_price) AS order_total
        FROM order_items
        GROUP BY order_id
    ) AS order_totals
);


