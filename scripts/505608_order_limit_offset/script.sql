/* - вывести все товары, отсортированные по имени по возрастанию.
 * В результатах отражаем колонки: id, name, price:
*/
SELECT id, name, price
FROM products
ORDER BY name;

/* - вывести 5 самых дешевых активных товаров.
 * В результатах отражаем колонки: id, name, price:
*/
SELECT id, name, price
FROM products
WHERE is_active = true
ORDER BY price,id
LIMIT 5;

/* - вывести 10 последних заказов. В результатах отражаем колонки:
 * id, user_id, status, created_at;
*/
SELECT id, user_id, status, created_at
FROM orders
ORDER BY created_at DESC, id
LIMIT 10;

/*- показать вторую страницу пользователей, если на одной странице 20 строк.
Сортировать по created_at DESC, id DESC.
В результатах отражаем колонки: id, name, email;
*/
SELECT id, name, email
FROM	users
ORDER BY	created_at DESC, id DESC
LIMIT 20 OFFSET 20;

/*- вывести все строки order_items, отсортированные:
по order_id,
внутри заказа - по unit_price по убыванию,
а при равной цене - по id.
В результатах отражаем все колонки;
*/
SELECT *
FROM order_items
ORDER BY order_id, unit_price DESC, id;

/*
- показать третью страницу товаров по 3 товара на странице,
отсортированных по цене от дорогих к дешевым,
а при равной цене - по id. В результатах отражаем колонки: id, name, price
*/
SELECT id, name, price
FROM products
ORDER BY price DESC, id
LIMIT 3 OFFSET 6;