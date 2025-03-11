--Lab 03
--Group 1
--Date: 2025-01-28
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--Qn. 1

SELECT last_name, hire_date
FROM employees
WHERE hire_date < (SELECT hire_Date FROM employees WHERE employee_id = 107)
  AND hire_date > TO_DATE('2016-03-31', 'YYYY-MM-DD')
ORDER BY hire_date, employee_id;


--method 2:

SELECT last_name, hire_date
FROM employees
WHERE hire_date < (SELECT hire_date FROM employees WHERE employee_id = 107)
  AND TRUNC(hire_date) > TO_DATE('2016-03-31', 'YYYY-MM-DD')
ORDER BY hire_date, employee_id;

--------------------------------------------------------------------------------
--Qn. 2

SELECT name, credit_limit
FROM customers
WHERE credit_limit = (SELECT MIN(credit_limit) FROM customers)
ORDER BY customer_id;

--------------------------------------------------------------------------------
--Qn. 3

SELECT 
    p.category_id, 
    p.product_id, 
    p.product_name, 
    p.list_price
FROM 
    products p
WHERE 
    p.list_price = (
        SELECT MAX(sub_p.list_price) 
        FROM products sub_p 
        WHERE sub_p.category_id = p.category_id
    )
ORDER BY 
    p.category_id, 
    p.product_id;
---------------------------------------------------------------------

--Qn. 4

SELECT 
    c.category_id, 
    c.category_name
FROM 
    product_categories c
WHERE 
    c.category_id = (
        SELECT p.category_id
        FROM products p
        WHERE p.list_price = (
            SELECT MAX(list_price) 
            FROM products
        )
    );

----------------------------------------------------------------------------------------
--Qn. 5
SELECT
   product_name,
   list_price 
FROM
   products 
WHERE
   list_price < ANY ( SELECT MIN(list_price) 
   FROM products 
   GROUP BY
      category_id) 
      AND category_id IN 1 
   ORDER BY
      list_price DESC,
      product_id;



------------------------------------------------------------------------------
--Qn. 6

SELECT MAX(list_Price) AS "MAX(LIST_PRICE)"
FROM products
WHERE category_id = (
    SELECT category_id
    FROM products
    WHERE list_Price = (SELECT MIN(list_Price) FROM products)
)
GROUP BY category_id;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

WITH LowestPrice AS (
    SELECT MIN(list_price) AS min_price
    FROM products
),
CategoryWithLowestPrice AS (
    SELECT category_id
    FROM products
    WHERE list_price = (SELECT min_price FROM LowestPrice)
)
SELECT MAX(list_price) AS max_price
FROM products
WHERE category_id IN (SELECT category_id FROM CategoryWithLowestPrice);





