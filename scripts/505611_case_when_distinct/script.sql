/*
 * - Вывести товары и добавить колонку price_label:

если цена меньше 5000 - 'cheap'
если от 5000 до 50000 -'regular'
иначе 'premium'
В результатах отражаем колонки: id, name, price,
 price_label.
 */

SELECT
	id,
	name,
	price,
	CASE
		WHEN price < 5000 THEN 'cheap'
		WHEN price <= 50000 THEN 'regular'
		ELSE 'premium'
	END AS price_lable
FROM
	products;

/*
 * - Вывести пользователей и колонку phone_status:
если телефон NULL - 'not specified'
иначе specified
В результатах отражаем колонки: id, name,
phone, phone_status;

 */
SELECT
	id,
	name,
	phone,
	CASE
		WHEN phone IS NULL THEN 'not specified'
		ELSE 'specified'
	END AS phone_status
FROM
	users;

/*
 * - Получить список уникальных статусов заказов.
 * В результатах отражаем колонки: status
 */
SELECT	DISTINCT status
FROM
	orders;

/*
 * - Получить список уникальных пользователей,
 * которые оформляли заказы. В результатах отражаем колонки: user_id.
 */
SELECT	DISTINCT user_id
FROM
	orders;

/*
 * - Получить по одному самому новому заказу для каждого пользователя.
 *  В результатах отражаем колонки: id, user_id, status, created_at.
 */
SELECT	DISTINCT ON(user_id)
    id,
	user_id,
	status,
	created_at
FROM
	orders
ORDER BY
	user_id,
	created_at DESC;

/*
 * - Получить по одному самому дорогому товару для каждого имени товара,
 * если в таблице встречаются несколько строк с одинаковым name.
 * В результатах отражаем колонки: id, name, price.
*/

SELECT DISTINCT ON(name)
id,
	name,
	price
FROM
	products
ORDER BY
	name,
	price DESC,
	id;
