/*- создайте функцию calculate_discount, которая принимает два параметра:

цену товара;
размер скидки в процентах.
Функция должна возвращать стоимость товара после применения скидки.

Проверьте работу функции с помощью запроса:

SELECT calculate_discount(2500, 15);*/


CREATE OR REPLACE FUNCTION calculate_discount(
    price NUMERIC,
    discount_percent NUMERIC
)
RETURNS NUMERIC
LANGUAGE SQL
AS
$$
    SELECT price * (100 - discount_percent) / 100;
$$;

SELECT calculate_discount(2500, 15);


/*- создайте функцию full_name, которая принимает имя и фамилию пользователя и возвращает строку в формате:

Имя Фамилия
Например:

SELECT full_name('Иван', 'Иванов');
Результат:

full_name
Иван Иванов*/

CREATE OR REPLACE FUNCTION full_name(
	name TEXT,
	surname TEXT
	)
RETURNs TEXT
LANGUAGE SQL
AS
$$
	SELECT name || ' ' || surname;
$$;

SELECT full_name('Иван', 'Иванов');

/*- создайте процедуру increase_category_prices, которая принимает:

название категории товаров;
процент увеличения цены.
Процедура должна увеличить стоимость всех товаров указанной категории на заданный процент.

После создания процедуры проверьте ее работу с помощью команды CALL.*/

CREATE OR REPLACE PROCEDURE increase_category_prices(
	category_name text,
	persent NUMERIC
	)
LANGUAGE SQL
AS
$$
    UPDATE products
    SET price = price * (100 + percent) / 100
    WHERE category = category_name;
$$;

CALL increase_category_prices('Iphone', 15);


/*- создайте процедуру archive_old_orders.

Процедура должна перенести все заказы, созданные более года назад, из таблицы orders в таблицу orders_archive, а затем удалить их из таблицы orders.

Для выполнения задания используйте следующие таблицы.

CREATE TABLE orders (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE orders_archive (
    id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL
);*/

CREATE TABLE orders (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE orders_archive (
    id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL
);

INSERT INTO orders (user_id, created_at)
VALUES
    (1, CURRENT_TIMESTAMP - INTERVAL '2 years'),
    (2, CURRENT_TIMESTAMP - INTERVAL '6 months'),
    (3, CURRENT_TIMESTAMP - INTERVAL '400 days');

SELECT * FROM orders;

CREATE OR REPLACE PROCEDURE archive_old_orders()
AS
$$
DECLARE
    cutoff TIMESTAMP := CURRENT_TIMESTAMP - INTERVAL '1 year';
BEGIN
    INSERT INTO orders_archive (id, user_id, created_at)
    SELECT id, user_id, created_at
    FROM orders
    WHERE created_at < cutoff;

    DELETE FROM orders
    WHERE created_at < cutoff;
END;
$$
LANGUAGE plpgsql;

CALL archive_old_orders();

SELECT * FROM orders;
SELECT * FROM orders_archive;