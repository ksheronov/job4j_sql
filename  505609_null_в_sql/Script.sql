/*
 в users мы добавляем столбцы:

phone TEXT NULL
middle_name TEXT NULL
в products:

description TEXT NULL
discount_price NUMERIC(12, 2) NULL
 */
ALTER TABLE users 
ADD COLUMN phone TEXT,
ADD COLUMN middle_name TEXT;

ALTER TABLE products 
ADD COLUMN description TEXT,
ADD COLUMN discount_price NUMERIC(12, 2);

/*
 - вывести всех пользователей, у которых не заполнено отчество.
  В результатах отражаем колонки: id, name, middle_name
 */
SELECT
	id,
	name,
	middle_name
FROM
	users
WHERE
	middle_name IS NULL;

/*
 * - вывести все товары, у которых отсутствует описание. 
 * В результатах отражаем колонки: id, name, description
 */
SELECT
	id,
	name,
	description
FROM
	products
WHERE
	description IS NULL;

/*
 * - вывести все товары, у которых нет скидочной цены. 
 * В результатах отражаем колонки: id, name, price, discount_price
 */
SELECT
	id,
	name,
	price,
	discount_price
FROM
	products
WHERE
	discount_price IS NULL;

/*
 * - вывести пользователей, у которых телефон либо NULL,
 *  либо пустая строка. 
 * В результатах отражаем колонки: id, name, phone
 */

SELECT
	id,
	name,
	phone
FROM
	users
WHERE
	phone IS NULL
	OR phone = '';

/*
 * - вывести список товаров и колонку display_description, где:

если description заполнено - показать его;
иначе вывести текст 'описание отсутствует'.
В результатах отражаем колонки: id, name и display_description.
 */

SELECT
	id,
	name ,
	COALESCE(description , 'описание отсутствует') AS display_description
FROM
	products;

/*
 * - вывести список товаров и колонку final_price, где:

если есть discount_price, использовать ее;
иначе брать price.
В результатах отражаем колонки: id, name, price, discount_price и final_price.
 */
SELECT
	id,
	name,
	price,
	discount_price,
	COALESCE(discount_price, price) AS final_price
FROM
	products;
