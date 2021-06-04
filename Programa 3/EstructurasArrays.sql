#ARRAYS
#standardSQL
WITH fruits AS(
SELECT ['raspberry','blackberry', 'strawberry', 'cherry'] AS fruit_array
)
#Count

SELECT ARRAY_LENGTH(fruit_array) AS array_size
FROM fruits

SELECT ['apple', 'pear', 'plum'] AS item,
'Jacob' AS customer

#UNNEST : A query that flattens an array and returns a row for each element in the array.

SELECT items, customer_name
FROM 
UNNEST(['apple', 'pear', 'peach']) As items
CROSS JOIN 
(SELECT 'Jacob' AS customer_name)
#Flatten using a CROSS JOIN

#Aggregate into an array with ARRAY_AGG
#{Row:[1,2,3], ['apple', 'pear', 'peach']}
WITH fruits AS 
(SELECT "apple" AS fruit
UNION ALL
SELECT "pear" AS fruit
UNION ALL 
SELECT "banana" AS fruit)

/*SELECT ARRAY_AGG(fruit) AS 
fruit_basket
FROM fruits;
*/
#Sort Array Output with ORDER BY

SELECT ARRAY_AGG(fruit ORDER BY fruit)
AS fruit_basket
FROM fruits;

#Filter Arrays using WHERE IN , Row:1 = [apple, pear, banana]
#Row 2: [carrot, apple], Row 3: [water, wine]
WITH groceries AS 
(SELECT ['apple', 'pear', 'banana'] AS list
UNION ALL 
SELECT ['carrot', 'apple'] AS list
UNION ALL 
SELECT ['water', 'wine'] AS list)


SELECT 
ARRAY(
    SELECT items FROM UNNEST(list) AS items
    WHERE  'apple' in UNNEST(list)

) AS contains_apple
FROM groceries

#Structs

#standardSQL
SELECT STRUCT (35 AS age, 'JACOB' AS name) as customers;

SELECT 
STRUCT (35 AS age, 'Jacob' AS name, ['apple', 'pear', 'peach'] AS items) AS customers;

#Array can contain structs as values
SELECT[ 
STRUCT (35 AS age, 'Jacob' AS name, ['apple', 'pear', 'peach'] AS items),
STRUCT(33 AS age, 'Miranda' AS name, ['water', 'pineapple', 'ice cream'] AS items) 
]


WITH orders AS (
    SELECT 
    [
        STRUCT(35 AS age, 'Jacob' AS name, ['apple', 'pear', 'peach'] AS items),
        STRUCT(33 AS age, 'Miranda' AS name, ['water', 'pineapple', 'ice cream'] AS items)

    ] AS customers
)

SELECT 
customers 
FROM orders AS o
CROSS JOIN UNNEST(o.customers) AS customers
WHERE 'ice cream' IN UNNEST(customers.items)