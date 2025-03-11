--oracle ID: dbs311_251ngg05
---Samik Kumar Chaudhary
---Lab-2
-----------------------------------------------------------
-----------------------------------------------------------
---Q.N. 1

SELECT 
    job_title, 
    COUNT(*) AS employees
FROM 
    employees
GROUP BY 
    job_title
ORDER BY 
    employees;

-----------------------------------------------------------

--Q.N. 2

SELECT 
    MAX(credit_limit) AS HIGH, 
    MIN(credit_limit) AS Low, 
    ROUND(AVG(credit_limit), 2) AS Average,
    (MAX(credit_limit) - MIN(credit_limit)) AS "High Low Difference"
FROM 
    customers;

--------------------------------------------------------------

--Q.N. 3

SELECT 
    o.order_id, 
    SUM(op.quantity) AS total_items, 
    SUM(op.quantity * op.unit_price) AS total_amount
FROM 
    orders o
JOIN 
    order_items op ON o.order_id = op.order_id
GROUP BY 
    o.order_id
HAVING 
    SUM(op.quantity * op.unit_price) > 1000000
ORDER BY 
total_amount DESC;



----------------------------------------------------------------
--Q.N.4

SELECT 
    w.warehouse_id, 
    w.warehouse_name, 
    SUM(p.quantity) AS total_products
FROM 
    warehouses w
JOIN 
    inventories p ON w.warehouse_id = p.warehouse_id
GROUP BY 
    w.warehouse_id, w.warehouse_name
ORDER BY 
    w.warehouse_id;

----------------------------------------------------------------
-- Q. N 5
SELECT 
    c.customer_id,
    c.NAME AS "customer_name",
    COUNT(o.order_id) AS "total_number_of_orders"
FROM 
    customers c
LEFT JOIN 
    orders o ON c.customer_id = o.customer_id
WHERE 
    (c.name LIKE 'O%e%' OR c.name LIKE '%t')
GROUP BY 
    c.customer_id, c.name
ORDER BY 
    "total_number_of_orders" DESC;


----------------------------------------------------------------
-- Q.N. 6

SELECT 
    pc.category_id,  
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_amount, 
    ROUND(AVG(oi.quantity * oi.unit_price), 2) AS average_amount
FROM 
    product_categories pc
JOIN 
    products p ON pc.category_id = p.category_id
JOIN 
    order_items oi ON p.product_id = oi.product_id
GROUP BY 
    pc.category_id, pc.category_name;


    --------------------------------------------------------------------------------
    --------------------------------------------------------------------------------




