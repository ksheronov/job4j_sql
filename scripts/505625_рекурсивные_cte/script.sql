CREATE TABLE folders (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    parent_id BIGINT REFERENCES folders(id)
);

INSERT INTO folders (name, parent_id)
VALUES ('Projects', NULL),
       ('Backend', 1),
       ('Frontend', 1),
       ('Java', 2),
       ('Python', 2),
       ('src', 4),
       ('test', 4),
       ('React', 3),
       ('components', 8),
       ('utils', 9),
       ('images', 8);

/*- построение дерева каталогов.

Используя WITH RECURSIVE, постройте дерево каталогов, начиная с папки Projects (id = 1).

Требования:

использовать рекурсивный CTE;
вывести название папки с отступами с помощью функции repeat();
вывести уровень вложенности (level);
отсортировать результат так, чтобы дерево отображалось в правильном порядке.
Результирующая таблица должна содержать поля:

folder_name;
level.*/

WITH RECURSIVE folder_tree AS (

    SELECT
        id,
        name AS folder_name,
        parent_id,
        0 AS level,
        ARRAY[id] AS path
    FROM folders
    WHERE id = 1

    UNION ALL


    SELECT
        f.id,
        f.name AS folder_name,
        f.parent_id,
        ft.level + 1 AS level,
        ft.path || f.id AS path
    FROM folders f
    JOIN folder_tree ft ON f.parent_id = ft.id
)
SELECT
    repeat('  ', level) || folder_name AS folder_name,
    level
FROM folder_tree
ORDER BY path;

/*- построение полного пути.

Для папки utils (id = 10) постройте полный путь от корневой папки.

Ожидаемый результат имеет вид:

Projects -> Frontend -> React -> components -> utils
Требования:

использовать рекурсивный CTE;
собрать путь с помощью массива;
преобразовать массив в строку функцией array_to_string().
Результирующая таблица должна содержать поле:

full_path.*/

WITH RECURSIVE path_builder AS (
    SELECT
        id,
        name,
        parent_id,
        ARRAY[name] AS path_array
    FROM folders
    WHERE id = 10

    UNION ALL

    SELECT
        f.id,
        f.name,
        f.parent_id,
        f.name || pb.path_array AS path_array
    FROM folders f
    JOIN path_builder pb ON f.id = pb.parent_id
)
SELECT
    array_to_string(path_array, ' -> ') AS full_path
FROM path_builder
WHERE parent_id IS NULL;

/*- защита от циклов.

Модифицируйте запрос из первого задания таким образом, чтобы он корректно работал даже при наличии циклических ссылок.

Требования:

использовать конструкцию
1
CYCLE id
2
SET is_cycle
3
USING cycle_path
исключить из результата строки, образующие цикл;
сохранить правильный порядок вывода дерева.
Результирующая таблица должна содержать поля:

folder_name;
level.*/

WITH RECURSIVE folder_tree AS (
    SELECT
        id,
        name AS folder_name,
        parent_id,
        0 AS level,
        ARRAY[id] AS sort_path
    FROM folders
    WHERE id = 1

    UNION ALL

    SELECT
        f.id,
        f.name AS folder_name,
        f.parent_id,
        ft.level + 1 AS level,
        ft.sort_path || f.id AS sort_path
    FROM folders f
    JOIN folder_tree ft ON f.parent_id = ft.id
)
CYCLE id SET is_cycle USING cycle_path
SELECT
    repeat('  ', level) || folder_name AS folder_name,
    level
FROM folder_tree
WHERE NOT is_cycle
ORDER BY sort_path;