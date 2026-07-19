/*Задача 1. Лучшие клиенты (TOP) Выведите имена клиентов и суммарную выручку, которую они принесли.
Учтите только успешные заказы.
Отсортируйте результат по убыванию выручки и оставьте только двух самых прибыльных клиентов.
Колонки в результате: customer_name, total_revenue.*/
SELECT
o.customer_name,
SUM(oi.quantity * p.price) AS total_revenue
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE	o.status = 'completed'
GROUP BY o.customer_name
ORDER  BY total_revenue DESC
LIMIT	2;

/*Задача 2. Фильтрация категорий (HAVING) Посчитайте общее количество проданных товаров
и суммарную выручку для каждой категории (только успешные заказы).
Выведите только те категории,
суммарная выручка которых превышает 30 000 рублей.
Колонки в результате: category, total_items_sold, category_revenue.*/

SELECT
	p.category,
	SUM(oi.quantity) AS total_items_sold,
	SUM(oi.quantity * p.price) AS category_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'completed'
GROUP BY p.category
HAVING SUM(oi.quantity * p.price) > 30000


/*Задача 3. Ловушка среднего (CTE + AVG) Руководство попросило посчитать:
«какое среднее количество товарных позиций (штук) находится в одном успешном заказе?»
Важное условие: если в заказе 2 разных товара (например, 1 ноутбук и 1 мышь),
это считается как 2 позиции. Не попадитесь в ловушку прямого усреднения строк таблицы order_items!
Сначала посчитайте количество позиций для каждого заказа, а затем найдите среднее.
Колонки в результате: avg_items_per_order.*/

WITH OrderItemSold AS (
SELECT
	oi.order_id,
	SUM(oi.quantity) AS quantity_total
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status = 'completed'
GROUP BY oi.order_id
)
SELECT AVG(quantity_total) AS avg_items_per_order
FROM OrderItemSold
