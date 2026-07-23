/*- используя CTE, вычислите общую стоимость каждого заказа.

Колонки результата:

order_id;
total_amount.
Требования:

первое CTE должно вычислять стоимость каждой позиции заказа (quantity * unit_price);
второе CTE должно суммировать стоимость всех позиций одного заказа.*/

WITH OrderItemCost AS (
    SELECT
        order_id,
        quantity * unit_price AS item_cost
    FROM order_items
),
OrderTotal AS (
    SELECT
        order_id,
        SUM(item_cost) AS total_amount
    FROM OrderItemCost
    GROUP BY order_id
)
SELECT
    order_id,
    total_amount
FROM OrderTotal;

/*- используя несколько CTE, найдите пользователей, общая сумма оплаченных заказов которых выше средней суммы оплаченных заказов по всем пользователям.

Используйте минимум два CTE.


Колонки результата:

user_id;
user_name;
total_amount.*/

WITH user_totals AS (
    SELECT
        o.user_id,
        SUM(oi.quantity * oi.unit_price) AS total_amount
    FROM orders o
    JOIN order_items oi
        ON oi.order_id = o.id
    WHERE o.status = 'PAID'
    GROUP BY o.user_id
),
average_total AS (
    SELECT AVG(total_amount) AS avg_total
    FROM user_totals
)
SELECT
    u.id,
    u.name,
    ut.total_amount
FROM users u
JOIN user_totals ut
    ON ut.user_id = u.id

CROSS JOIN average_total at

WHERE ut.total_amount > at.avg_total;

/*- используя CTE, найдите товары, которые ни разу не были заказаны.

Используйте CTE для получения списка заказанных товаров.


Колонки результата:

product_id;
product_name.*/

WITH order_list AS (
	SELECT
		DISTINCT  product_id
	FROM order_items
)
SELECT
	p.id AS product_id,
	p.name AS product_name
FROM products p
LEFT JOIN order_list ol ON ol.product_id = p.id
WHERE ol.product_id IS NULL;

/*- используя CTE, определите пять самых продаваемых товаров по количеству проданных единиц.

Колонки результата:

product_id;
product_name;
total_quantity.	*/

WITH order_quantity AS (
	SELECT
		product_id,
		SUM(quantity) AS total_quantity
	FROM order_items
	GROUP BY product_id
)
SELECT
	p.id,
	p.name,
	oq.total_quantity
FROM products p
JOIN order_quantity oq ON oq.product_id  = p.id
ORDER BY oq.total_quantity DESC
LIMIT 5;