/* Используя таблицы orders и order_items, для каждого заказа выведите:

идентификатор пользователя;
идентификатор заказа;
дату заказа;
стоимость заказа;
стоимость первого заказа пользователя;
стоимость последнего заказа пользователя;
стоимость второго заказа пользователя.
Стоимость заказа вычислите с помощью выражения:

SUM(quantity * unit_price)
Результирующая таблица должна содержать следующие столбцы:

user_id
order_id
created_at
order_amount
first_order_amount
last_order_amount
second_order_amount*/


WITH order_costs AS (
    SELECT
        o.id AS order_id,
        o.user_id,
        o.created_at,
        SUM(oi.quantity * oi.unit_price) AS order_amount
    FROM orders o
    JOIN order_items oi ON o.id = oi.order_id
    GROUP BY o.id, o.user_id, o.created_at
)

SELECT
    user_id,
    order_id,
    created_at,
    order_amount,
    FIRST_VALUE(order_amount) OVER (
        PARTITION BY user_id
        ORDER BY created_at
    ) AS first_order_amount,
    LAST_VALUE(order_amount) OVER w AS last_order_amount,
    NTH_VALUE(order_amount, 2) OVER w AS second_order_amount
FROM order_costs
WINDOW w AS (
    PARTITION BY user_id
    ORDER BY created_at
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
ORDER BY user_id, created_at;