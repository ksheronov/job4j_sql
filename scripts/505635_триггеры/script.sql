/* Создайте таблицу employees. Таблица должна содержать следующие поля:

id;
full_name;
salary;
updated_at.
Реализуйте триггер, который автоматически обновляет поле updated_at при изменении записи.*/

CREATE TABLE employees (
	id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	full_name VARCHAR(255) NOT NULL ,
	salary NUMERIC(10, 2) NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)

CREATE OR REPLACE FUNCTION change_changed_at()
RETURNS TRIGGER AS
$$
BEGIN
     NEW.updated_at = CURRENT_TIMESTAMP;
     RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER update_employees_updated_at
BEFORE UPDATE ON employees
FOR EACH ROW
EXECUTE FUNCTION change_changed_at();

INSERT INTO employees (full_name, salary)
VALUES ('Иван Иванов', 50000);
SELECT * FROM employees;

UPDATE employees
SET salary = 70000
WHERE id = 1;
SELECT * FROM employees;


/*3. Создайте таблицу orders и таблицу order_status_history.

При каждом изменении статуса заказа необходимо автоматически сохранять:

идентификатор заказа;
предыдущий статус;
новый статус;
дату изменения.
Проверьте работу триггера, несколько раз изменив статус одного и того же заказа.*/

CREATE TABLE orders (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    status TEXT NOT NULL,
    create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE order_status_history (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id BIGINT NOT NULL,
    old_status TEXT NOT NULL,
    new_status TEXT NOT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION save_order_history()
RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO order_status_history (
        order_id,
        old_status,
        new_status,
		changed_at
    )
    VALUES (
        OLD.id,
        OLD.status,
        NEW.status,
		CURRENT_TIMESTAMP
    );

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER order_history_trigger
AFTER UPDATE OF status
ON orders
FOR EACH ROW
EXECUTE FUNCTION save_order_history();


INSERT INTO orders (status) VALUES ('new');

UPDATE orders SET status = 'processing' WHERE id = 1;
UPDATE orders SET status = 'shipped' WHERE id = 1;
UPDATE orders SET status = 'delivered' WHERE id = 1;

SELECT * FROM order_status_history WHERE order_id = 1;


/*4. Используйте таблицу employees.

Необходимо запретить сохранение сотрудников с отрицательной заработной платой.

Реализуйте триггер, который будет выдавать ошибку при попытке выполнить INSERT или UPDATE с некорректным значением.*/



CREATE OR REPLACE FUNCTION check_employees_salary()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.salary < 0 THEN
        RAISE EXCEPTION 'Зарплата не может быть отрицательной.';
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER check_employees_salary_trigger
BEFORE INSERT OR UPDATE
ON employees
FOR EACH ROW
EXECUTE FUNCTION check_employees_salary();

INSERT INTO employees (full_name, salary)
VALUES ('Иван Иванов', -50000);

UPDATE employees
SET salary = -100
WHERE id = 1;

/*5. Предположим, в таблице products имеется поле name.

Реализуйте триггер, который автоматически удаляет пробелы в начале и конце названия товара перед сохранением записи.

Например,

"   Ноутбук   "
должно автоматически превратиться в

"Ноутбук"*/

CREATE TABLE products (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    price NUMERIC(12,2)
);

CREATE OR REPLACE FUNCTION trim_product_name()
RETURNS TRIGGER AS
$$
BEGIN
    NEW.name = TRIM(NEW.name);
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER trim_products_name_trigger
BEFORE INSERT OR UPDATE
ON products
FOR EACH ROW
EXECUTE FUNCTION trim_product_name();

INSERT INTO products (name, price)
VALUES ('   Ноутбук   ', 50000);

SELECT * FROM products;

/*6. В таблице products хранится поле price.

Необходимо реализовать журнал изменения цены таким образом, чтобы новая запись в журнал добавлялась только тогда, когда цена действительно изменилась.

Если обновляются другие поля товара, история цен пополняться не должна.*/

CREATE TABLE product_price_history (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id BIGINT NOT NULL REFERENCES products(id),
    old_price NUMERIC(12, 2) NOT NULL,
    new_price NUMERIC(12, 2) NOT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_product_price_change()
RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO product_price_history (
        product_id,
        old_price,
        new_price,
        changed_at
    )
    VALUES (
        OLD.id,
        OLD.price,
        NEW.price,
        CURRENT_TIMESTAMP
    );

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER product_price_history_trigger
AFTER UPDATE OF price
ON products
FOR EACH ROW
WHEN (OLD.price IS DISTINCT FROM NEW.price)
EXECUTE FUNCTION log_product_price_change();

UPDATE products
SET price = 70000
WHERE id = 1;

SELECT * FROM product_price_history;

UPDATE products
SET name = 'компьтер'
WHERE id = 5;
SELECT * FROM product_price_history;