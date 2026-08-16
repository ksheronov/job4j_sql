/*- создайте курсор products_cursor, который будет читать список товаров из таблицы products.

Из курсора необходимо получать следующие поля:

id;
name;
price.
После создания курсора:

получите первые три строки;
затем получите следующие две строки;
закройте курсор.*/

BEGIN;

DECLARE products_cursor CURSOR FOR
SELECT
    id,
    name,
    price
FROM products;

FETCH 3 FROM products_cursor;

FETCH 2 FROM products_cursor;

CLOSE products_cursor;

COMMIT;

/*- используя курсор, прочитайте данные из таблицы orders небольшими порциями.

Необходимо:

создать курсор для списка заказов;
получить первые пять строк;
затем получить еще пять строк;
завершить работу с курсором.*/

BEGIN;

DECLARE orders_cursor CURSOR FOR
SELECT id, user_id,status
FROM orders;

FETCH 5 FROM orders_cursor;
FETCH 5 FROM orders_cursor;
CLOSE orders_cursor;
COMMIT;

/*- создайте курсор с поддержкой перемещения в обоих направлениях.

После этого:

получите первые три строки;
переместите курсор назад на две строки;
снова получите две строки.*/

BEGIN;

DECLARE orders_cursor SCROLL CURSOR FOR
SELECT id, user_id,status
FROM orders;

FETCH 3 FROM orders_cursor;
MOVE BACKWARD 2 orders_cursor;
FETCH 2 FROM orders_cursor;
CLOSE orders_cursor;
COMMIT;

