/*
  - вывести кузова, которые не используются ни в одной машине.

В результатах отражаем колонки:

id
название кузова.
 */
SELECT
	cb.id,
	cb.name AS body_name
FROM car_bodies cb
LEFT JOIN cars c ON  cb.id = c.body_id
WHERE c.id IS NULL
ORDER BY cb.id;

/*
  вывести двигатели, которые не используются ни в одной машине.

В результатах отражаем колонки:

id
название двигателя.
 */
SELECT
	ce.id,
	ce.name AS engine_name
FROM car_engines ce
LEFT JOIN cars c ON c.engine_id = ce.id
WHERE c.id IS NULL
ORDER BY ce.id;

/*
 - вывести коробки передач, которые не используются ни в одной машине.

В результатах отражаем колонки:

id
название коробки передач.
 */
SELECT
	ct.id,
	ct.name AS transmisiion_name
FROM car_transmissions ct
LEFT JOIN cars c ON c.transmission_id = ct.id
WHERE c.id IS NULL
ORDER BY ct.id;

/*
 - вывести список всех машин и название кузова, если оно указано.

Колонки результата:

id
car_name
body_name
Требования:

в результат должны попасть все машины;
если кузов у машины отсутствует, в body_name должно быть NULL.
 */
SELECT
	c.id,
	c.name AS car_name,
	cb.name AS body_name
FROM cars c
LEFT JOIN car_bodies cb ON cb.id=c.body_id
ORDER BY c.id;

/*
 - вывести только те машины, у которых одновременно указаны:

кузов;
двигатель;
коробка передач.
Колонки результата:

id
car_name
body_name
engine_name
transmission_name
Требования:

машины, у которых хотя бы одна из деталей отсутствует, в результат попасть не должны.
 */
SELECT
	c.id,
	c.name AS can_name,
	cb.name AS body_name,
	ce.name AS engine_name,
	ct.name AS transmission_name
FROM cars c
	JOIN car_bodies cb ON cb.id = c.body_id
	JOIN car_engines ce ON ce.id = c.engine_id
	JOIN car_transmissions ct ON ct.id = c.transmission_id
ORDER BY c.id;


/*
- вывести машины, у которых есть двигатель, но нет кузова.

Колонки результата:

id
car_name
body_name
engine_name
Требования:

в engine_name должен быть выведен двигатель;
в body_name должно быть NULL.
 */

SELECT
	c.id,
	c.name AS can_name,
	cb.name AS body_name,
	ce.name AS engine_name
FROM cars c
 	LEFT JOIN car_bodies cb ON cb.id = c.body_id
 	JOIN car_engines ce ON ce.id = c.engine_id
 	 WHERE cb.id  IS NULL;

/*
 *- вывести все кузова и машины, которые их используют.

Колонки результата:

body_id
body_name
car_id
car_name
Требования:

в результат должны попасть все кузова, даже если они не используются;
если кузов не используется, то car_id и car_name должны быть NULL.
 */

SELECT
	cb.id AS body_id,
	cb.name AS body_name,
	c.id AS car_id,
	c.name  AS car_name
FROM car_bodies cb
	LEFT JOIN cars c ON c.body_id = cb.id
ORDER BY cb.id, c.id ;

/*
- вывести неиспользуемые двигатели.

Колонки результата:


id
engine_name
Требования:


в результат должны попасть только те двигатели, на которые не ссылается ни одна машина.
 */
SELECT
	ce.id,
	ce.name AS engine_name
	FROM car_engines ce
	LEFT JOIN cars c ON c.engine_id = ce.id
	WHERE c.engine_id IS NULL
	ORDER BY ce.id;

/*

- вывести машины и все их детали, но только для машин с автоматической коробкой передач.

Под автоматической коробкой здесь считаем все коробки, у которых название начинается с automatic.

Колонки результата:

id
car_name
body_name
engine_name
transmission_name
Требования:

в выборку должны попасть только машины с автоматической коробкой передач;
кузов и двигатель нужно тоже вывести, даже если какой-то из них отсутствует.*/

SELECT
	c.id,
	c.name AS car_name,
	cb.name AS body_name,
	ce.name AS engine_name,
	ct.name AS transmission_name
FROM cars c
	JOIN car_transmissions ct ON ct.id = c.transmission_id
	LEFT JOIN car_bodies cb ON cb.id = c.body_id
	LEFT JOIN car_engines ce ON ce.id = c.engine_id
WHERE ct.name ILIKE 'automatic%';


/*- вывести машины, у которых отсутствует хотя бы одна деталь.

Под деталями понимаются:


кузов;
двигатель;
коробка передач.
Колонки результата:

id
car_name
body_name
engine_name
transmission_name
Требования:

в результат должны попасть только те машины, у которых хотя бы одна из трех связей отсутствует.*/

SELECT
	c.id,
	c.name AS car_name,
	cb.name AS body_name,
	ce.name AS engine_name,
	ct.name AS transmission_name
FROM cars c
LEFT  JOIN car_bodies cb ON cb.id = c.body_id
LEFT  JOIN car_engines ce ON ce.id = c.engine_id
LEFT  JOIN car_transmissions ct ON ct.id = c.transmission_id
WHERE cb.id IS NULL OR
      ce.id IS NULL OR
      ct.id IS NULL;



/*
- вывести все машины с двигателями, но коробку передач подключить так,
 чтобы машины без коробки тоже попали в результат.

Колонки результата:

id
car_name
engine_name
transmission_name
Требования:

в результат должны попасть только машины, у которых двигатель указан;
если коробка передач отсутствует, машина все равно должна остаться в выборке.
*/

SELECT
	c.id,
	c.name AS car_name,
	ce.name AS engine_name,
	ct.name AS transmission_name
FROM cars c
JOIN car_engines ce ON ce.id = c.engine_id
LEFT JOIN car_transmissions ct ON ct.id = c.transmission_id;


/* - вывести все неиспользуемые детали в едином формате.

Нужно вывести одним результатом:

неиспользуемые кузова;
неиспользуемые двигатели;
неиспользуемые коробки передач.
Колонки результата:

detail_type
detail_id
detail_name
*/


SELECT
    'body' AS detail_type,
    cb.id AS detail_id,
    cb.name AS detail_name
FROM car_bodies cb
LEFT JOIN cars c ON cb.id = c.body_id
WHERE c.id IS NULL

UNION ALL

SELECT
    'engine' AS detail_type,
    ce.id AS detail_id,
    ce.name AS detail_name
FROM car_engines ce
LEFT JOIN cars c ON ce.id = c.engine_id
WHERE c.id IS NULL

UNION ALL

SELECT
    'transmission' AS detail_type,
    ct.id AS detail_id,
    ct.name AS detail_name
FROM car_transmissions ct
LEFT JOIN cars c ON ct.id = c.transmission_id
WHERE c.id IS NULL;

/*
 - вывести машины и детали только для кузовов определенных типов.

Нужно вывести машины, у которых кузов относится к одному из типов:

sedan
hatchback
suv
Колонки результата:

id
car_name
body_name
engine_name
transmission_name
Требования:

в результат должны попасть только машины указанных типов кузова;
если двигатель или коробка передач отсутствуют, машина все равно должна попасть в результат.
 */

SELECT
	c.id,
	c.name AS car_name,
	cb.name AS body_name,
	ce.name AS engine_name,
	ct.name AS transmission_name
FROM cars c
JOIN car_bodies cb ON cb.id = c.body_id
LEFT JOIN car_engines ce ON ce.id = c.engine_id
LEFT JOIN car_transmissions ct ON ct.id  = c.transmission_id
WHERE cb.name IN ('sedan','hatchback','suv');
