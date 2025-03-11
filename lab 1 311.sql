--oracle ID: dbs311_251ngg05
---Samik Kumar Chaudhary

-----------------------------------------------------------
-----------------------------------------------------------
---Q.N. 1

SELECT TO_CHAR(SYSDATE + 1, 'fmMonth ddth "of year" YYYY') AS "Tomorrow"
FROM dual;

-----------------------------------------------------------

--Q.N. 2

SELECT 
    product_id,
    product_name,
    list_price,
    ROUND(list_price * 1.02) AS "New Price",
    ROUND(list_price * 1.02 - list_price, 2) AS "Price Difference"
FROM 
    products
WHERE 
    category_id IN (2, 3, 5)
ORDER BY 
    category_id, 
    product_id;
    
--I did not get decimals in price difference column
--------------------------------------------------------------

--Q.N. 3

SELECT 
    last_name || ', ' || first_name || ' is ' || job_title AS "Employee Info"
FROM 
    employees
WHERE 
    LOWER (manager_id) = 2
ORDER BY 
    employee_id;

----------------------------------------------------------------
--Q.N.4

SELECT 
    last_name,
    hire_date,
    CEIL(MONTHS_BETWEEN(SYSDATE, hire_date) / 12) AS "Years Worked"
FROM 
    employees
WHERE 
    hire_date < TO_DATE('2016-10-01', 'YYYY-MM-DD')
ORDER BY 
    hire_date ASC,
    "Years Worked" DESC;

----------------------------------------------------------------
-- Q. N 5

SELECT 
    last_name,
    hire_date,
    TO_CHAR(
        NEXT_DAY(ADD_MONTHS(hire_date, 12) - 1, 'TUESDAY'), 
        'DAY, Month "the" ddspth "of year" YYYY') AS "REVIEW DAY"
FROM 
    employees
WHERE 
    hire_date > TO_DATE('2016-01-01', 'YYYY-MM-DD')
ORDER BY 
    hire_date,
    "REVIEW DAY";

----------------------------------------------------------------
-- Q.N. 6

SELECT 
    w.warehouse_id, 
    w.warehouse_name, 
    l.city, 
    COALESCE(l.state, 'Unknown') AS State
FROM 
    warehouses w
JOIN 
    locations l ON w.location_id = l.location_id
ORDER BY 
    w.warehouse_id;

    --------------------------------------------------------------------------------
    --------------------------------------------------------------------------------



