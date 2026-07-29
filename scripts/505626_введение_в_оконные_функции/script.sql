/*
- для каждого заказа необходимо вывести:

идентификатор заказа;
идентификатор пользователя;
сумму заказа;
общую сумму всех заказов этого пользователя.
Используйте оконную функцию SUM().

Поля результирующей таблицы:

order_id
user_id
total_amount
user_total
*/

SELECT
    o.id AS order_id,
    o.user_id,
    SUM(oi.quantity * oi.unit_price) AS total_amount,
    SUM(SUM(oi.quantity * oi.unit_price)) OVER w AS user_total,
    AVG(SUM(oi.quantity * oi.unit_price)) OVER w AS average_order_amount,
    COUNT(*) OVER w AS orders_count
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id, o.user_id
WINDOW w AS (PARTITION BY o.user_id);

/*- для каждого заказа необходимо вывести:

идентификатор заказа;
идентификатор пользователя;
сумму заказа;
среднюю стоимость заказа данного пользователя.
Используйте оконную функцию AVG().

Поля результирующей таблицы:

order_id
user_id
total_amount
average_order_amount*/

SELECT
    o.id AS order_id,
    o.user_id,
    SUM(oi.quantity * oi.unit_price) AS total_amount,
    AVG(SUM(oi.quantity * oi.unit_price)) OVER(PARTITION BY o.user_id) AS average_order_amount
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id, o.user_id;

/*- для каждого заказа необходимо определить его порядковый номер среди заказов этого пользователя по дате оформления.

Используйте функцию ROW_NUMBER().

Поля результирующей таблицы:

order_id
user_id
created_at
row_number*/

SELECT
    o.id AS order_id,
    o.user_id,
    o.created_at,
    ROW_NUMBER() OVER(PARTITION BY o.user_id ORDER BY o.created_at) AS row_number
FROM orders o;


/*- постройте рейтинг заказов по их стоимости в порядке убывания.

Если несколько заказов имеют одинаковую стоимость, они должны иметь одинаковый ранг.

Используйте функцию RANK().

Поля результирующей таблицы:

order_id
total_amount
order_rank*/

SELECT
    o.id AS order_id,
    SUM(oi.quantity * oi.unit_price) AS total_amount,
    RANK() OVER(ORDER BY SUM(oi.quantity * oi.unit_price) DESC) AS order_rank
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id;

/*- выполните ту же задачу, что и в предыдущем задании, но используйте функцию DENSE_RANK().

Сравните полученный результат с предыдущим заданием и объясните, чем отличается работа этих двух функций.

Поля результирующей таблицы:

order_id
total_amount
order_rank*/

SELECT
    o.id AS order_id,
    SUM(oi.quantity * oi.unit_price) AS total_amount,
    DENSE_RANK() OVER(ORDER BY SUM(oi.quantity * oi.unit_price) DESC) AS order_rank
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id;

/*- разделите все заказы на четыре примерно равные группы по стоимости заказа в порядке убывания.

Используйте функцию NTILE().

Поля результирующей таблицы:

order_id
total_amount
group_number*/

SELECT
    o.id AS order_id,
    SUM(oi.quantity * oi.unit_price) AS total_amount,
    NTILE(4) OVER(ORDER BY SUM(oi.quantity * oi.unit_price) DESC) AS group_number
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id;

/*- для каждого пользователя одновременно выведите:

общую сумму его заказов;
среднюю стоимость заказа;
количество заказов.
Используйте конструкцию WINDOW, чтобы описание окна не повторялось несколько раз.

Поля результирующей таблицы:

order_id
user_id
total_amount
user_total
average_order_amount
orders_count*/

SELECT
    o.id AS order_id,
    o.user_id,
    SUM(oi.quantity * oi.unit_price) AS total_amount,
    SUM(SUM(oi.quantity * oi.unit_price)) OVER w AS user_total,
    AVG(SUM(oi.quantity * oi.unit_price)) OVER w AS average_order_amount,
    COUNT(*) OVER w AS orders_count
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id, o.user_id
WINDOW w AS (PARTITION BY o.user_id);