-- ***********************
-- Student1 Name: Samik Kumar Chaudhary Student1 ID: 167045236
-- Student2 Name: Vishnu Dutt Ramachandran ID: 
-- Student3 Name: Ashan Napit Student3 ID: 
-- Date: 2025-03-03
-- Purpose: Assignment 1 - DBS311
-- ***********************
-- Question 1 – To shows the employees who were hired after the last employee hired in August 2016 but two months before the first employee hired in December 2016.

-- Q1 SOLUTION --

SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, HIRE_DATE
FROM EMPLOYEES
WHERE HIRE_DATE > (
    SELECT MAX(HIRE_DATE) 
    FROM EMPLOYEES 
    WHERE HIRE_DATE BETWEEN TO_DATE('2016-08-01', 'YYYY-MM-DD') 
                      AND TO_DATE('2016-08-31', 'YYYY-MM-DD')
)
AND HIRE_DATE < (
    SELECT ADD_MONTHS(MIN(HIRE_DATE), -2)
    FROM EMPLOYEES
    WHERE HIRE_DATE BETWEEN TO_DATE('2016-12-01', 'YYYY-MM-DD') 
                      AND TO_DATE('2016-12-31', 'YYYY-MM-DD')
)
ORDER BY HIRE_DATE, EMPLOYEE_ID;

/****   Output\
EMPLOYEE_ID FIRST_NAME LAST_NAME HIRE_DATE
----------- ---------- --------- ----------
101	Annabelle	Dunn	17-SEP-16
2	Jude	Rivera	21-SEP-16
11	Tyler	Ramirez	28-SEP-16
27	Kai	Long	28-SEP-16
12	Elliott	James	30-SEP-16
46	Ava	Sullivan	01-OCT-16

**/

---------------------------------------------
-- Question 2 – To shows manager ID for managers with more than one employee

-- Q2 SOLUTION --


SELECT DISTINCT e1.MANAGER_ID
FROM EMPLOYEES e1
WHERE EXISTS (
    SELECT 1 
    FROM EMPLOYEES e2 
    WHERE e1.MANAGER_ID = e2.MANAGER_ID 
    AND e1.EMPLOYEE_ID <> e2.EMPLOYEE_ID
)
ORDER BY e1.MANAGER_ID;

/** Output

Manager ID
----------
1
2
4
9
15
21
22
23
24
25
46
47
48
49
50

*/
-------------------------------------------------------------------------

-- Question 3 – To shows manager ID for managers who have only one employee.

-- Q3 SOLUTION --
-- Retrieve managers who have at least one employee

SELECT DISTINCT MANAGER_ID
FROM EMPLOYEES
WHERE MANAGER_ID IS NOT NULL

MINUS

-- Retrieve managers who have more than one employee
SELECT DISTINCT e1.MANAGER_ID
FROM EMPLOYEES e1
WHERE EXISTS (
    SELECT 1 
    FROM EMPLOYEES e2 
    WHERE e1.MANAGER_ID = e2.MANAGER_ID 
    AND e1.EMPLOYEE_ID <> e2.EMPLOYEE_ID
)
ORDER BY MANAGER_ID;

/* Output

Manager ID
----------
3
102
106

*/
--------------------------------------------------------------------------------
-- Question 4 – To  display products ordered multiple times in one day in 2016

-- Q4 SOLUTION --


SELECT 
    OI.PRODUCT_ID AS "Product ID", 
    TRUNC(O.ORDER_DATE) AS "Order Date", 
    COUNT(*) AS "Number of orders"
FROM 
    ORDERS O
JOIN 
    ORDER_ITEMS OI ON O.ORDER_ID = OI.ORDER_ID
WHERE 
    EXTRACT(YEAR FROM O.ORDER_DATE) = 2016
GROUP BY 
    OI.PRODUCT_ID, TRUNC(O.ORDER_DATE)
HAVING 
    COUNT(*) > 1
ORDER BY 
    "Order Date", "Product ID";


/*  Output
Product ID Order Date Number of orders
---------- ---------- ----------------
163	13-JUN-16	2
71	16-AUG-16	2
93	16-AUG-16	2
62	24-AUG-16	2
1	29-NOV-16	2
96	29-NOV-16	2

*/


/* ANOTHER WAY 
SELECT 
    OI.PRODUCT_ID AS "Product ID", 
    TRUNC(O.ORDER_DATE) AS "Order Date", 
    COUNT(*) AS "Number of orders"
FROM 
    ORDERS O
JOIN 
    ORDER_ITEMS OI ON O.ORDER_ID = OI.ORDER_ID
WHERE 
    EXTRACT(YEAR FROM O.ORDER_DATE) = 2016
GROUP BY 
    OI.PRODUCT_ID, TRUNC(O.ORDER_DATE)
HAVING 
    COUNT(*) > 1
ORDER BY 
    "Order Date", "Product ID"
FETCH FIRST 6 ROWS ONLY; */

--------------------------------------------------------------------------------
-- Question 5 – To  display customer ID and customer name for customers who have purchased all these three products WITH ID 7, 40, 94

-- Q5 SOLUTION --

SELECT 
    C.CUSTOMER_ID AS "CUSTOMER ID", 
    C.NAME AS "NAME"
FROM 
    CUSTOMERS C
JOIN 
    ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID
JOIN 
    ORDER_ITEMS OI ON O.ORDER_ID = OI.ORDER_ID
WHERE 
    OI.PRODUCT_ID IN (7, 40, 94)
GROUP BY 
    C.CUSTOMER_ID, C.NAME
HAVING 
    COUNT(DISTINCT OI.PRODUCT_ID) = 3
ORDER BY 
    C.CUSTOMER_ID;

/* Output

CUSTOMER ID NAME
----------- ----
6	Community Health Systems 

*/

--------------------------------------------------------------------------------
-- Question 6 – To  display employee ID and the number of orders for employees with the maximum number of orders (sales)

-- Q6 SOLUTION --

SELECT 
    SALESMAN_ID AS "Employee ID", 
    COUNT(ORDER_ID) AS "Number of Orders"
FROM 
    ORDERS
WHERE 
    SALESMAN_ID IS NOT NULL
GROUP BY 
    SALESMAN_ID
HAVING 
    COUNT(ORDER_ID) = (
        SELECT MAX(ORDER_COUNT)
        FROM (
            SELECT COUNT(ORDER_ID) AS ORDER_COUNT
            FROM ORDERS
            WHERE SALESMAN_ID IS NOT NULL
            GROUP BY SALESMAN_ID
        )
    )
ORDER BY 
    SALESMAN_ID;


/* Output

Employee ID Number of Orders
----------- ----------------
62	13

*/


--------------------------------------------------------------------------------
-- Question 7 – To  display the month number, month name, year, total number of orders, and total sales amount for each month in 2017

-- Q7 SOLUTION --
SELECT 
    EXTRACT(MONTH FROM O.ORDER_DATE) AS "Month Number",
    TO_CHAR(O.ORDER_DATE, 'Month') AS "Month Name",
    EXTRACT(YEAR FROM O.ORDER_DATE) AS "Year",
    COUNT(O.ORDER_ID) AS "Total Number of Orders",
    SUM(OI.QUANTITY * OI.UNIT_PRICE) AS "Total Sales Amount"
FROM 
    ORDERS O
JOIN 
    ORDER_ITEMS OI ON O.ORDER_ID = OI.ORDER_ID
WHERE 
    EXTRACT(YEAR FROM O.ORDER_DATE) = 2017
GROUP BY 
    EXTRACT(MONTH FROM O.ORDER_DATE), 
    TO_CHAR(O.ORDER_DATE, 'Month'), 
    EXTRACT(YEAR FROM O.ORDER_DATE)
ORDER BY 
    "Month Number";

/* Output

Month Number Month Year Total Number of Orders Sales Amount
------------ ----- ---- ---------------------- ------------

1	January  	2017	31	2281459.09
2	February 	2017	85	7919446.52
3	March    	2017	25	2246625.47
4	April    	2017	13	609150.35
5	May      	2017	26	1367115.47
6	June     	2017	7	926416.51
8	August   	2017	38	2539537.86
9	September	2017	25	1675983.52
10	October  	2017	22	2040864.95
11	November 	2017	2	307842.27

*/

--------------------------------------------------------------------------------
-- Question 8 – To  display month number, month name, and average sales amount for months with the average sales amount greater than average sales amount in 2017

-- Q8 SOLUTION --

SELECT 
    EXTRACT(MONTH FROM O.ORDER_DATE) AS "Month Number",
    TO_CHAR(O.ORDER_DATE, 'Month') AS "Month Name",
    ROUND(AVG(OI.QUANTITY * OI.UNIT_PRICE), 2) AS "Average Sales Amount"
FROM 
    ORDERS O
JOIN 
    ORDER_ITEMS OI ON O.ORDER_ID = OI.ORDER_ID
WHERE 
    EXTRACT(YEAR FROM O.ORDER_DATE) = 2017
GROUP BY 
    EXTRACT(MONTH FROM O.ORDER_DATE), 
    TO_CHAR(O.ORDER_DATE, 'Month')
HAVING 
    AVG(OI.QUANTITY * OI.UNIT_PRICE) > (
        SELECT AVG(OI2.QUANTITY * OI2.UNIT_PRICE)
        FROM ORDERS O2
        JOIN ORDER_ITEMS OI2 ON O2.ORDER_ID = OI2.ORDER_ID
        WHERE EXTRACT(YEAR FROM O2.ORDER_DATE) = 2017
    )
ORDER BY 
    "Month Number";

/* Output

Month Number Month Average Sales Amount
------------ ----- --------------------
2	February 	93169.96
3	March    	89865.02
6	June     	132345.22
10	October  	92766.59
11	November 	153921.14

*/

--------------------------------------------------------------------------------
-- Question 9 – To  display  first names in EMPLOYEES that start with letter B but do not exist in CONTACTS.

-- Q9 SOLUTION --

SELECT 
    E.FIRST_NAME
FROM 
    EMPLOYEES E
WHERE 
    E.FIRST_NAME LIKE 'B%'
    AND NOT EXISTS (
        SELECT 1
        FROM CONTACTS C
        WHERE C.FIRST_NAME = E.FIRST_NAME
    )
ORDER BY 
    E.FIRST_NAME;

/*  Output

First Name 
-----------
Bella
Blake

*/

  /*Another way using left join

  SELECT 
    E.FIRST_NAME
FROM 
    EMPLOYEES E
LEFT JOIN 
    CONTACTS C ON E.FIRST_NAME = C.FIRST_NAME
WHERE 
    E.FIRST_NAME LIKE 'B%'
    AND C.FIRST_NAME IS NULL
ORDER BY 
    E.FIRST_NAME;


  */


  --------------------------------------------------------------------------------
-- Question 10 – To  calculate the number of he number of employees with total order amount over average order amount, employees with total number of orders greater than 10, employees with no order, and employees with orders.
-- Q10 SOLUTION --

WITH EmployeeOrderStats AS (
    SELECT 
        E.EMPLOYEE_ID,
        COUNT(O.ORDER_ID) AS TotalOrders,
        SUM(OI.QUANTITY * OI.UNIT_PRICE) AS TotalOrderAmount
    FROM 
        EMPLOYEES E
    LEFT JOIN 
        ORDERS O ON E.EMPLOYEE_ID = O.SALESMAN_ID
    LEFT JOIN 
        ORDER_ITEMS OI ON O.ORDER_ID = OI.ORDER_ID
    GROUP BY 
        E.EMPLOYEE_ID
),
AverageOrderAmount AS (
    SELECT 
        AVG(OI.QUANTITY * OI.UNIT_PRICE) AS AvgOrderAmount
    FROM 
        ORDER_ITEMS OI
)
SELECT 
    (SELECT COUNT(*) 
     FROM EmployeeOrderStats 
     WHERE TotalOrderAmount > (SELECT AvgOrderAmount FROM AverageOrderAmount)
    ) AS Emp_Over_Avg_Amt,
    
    (SELECT COUNT(*) 
     FROM EmployeeOrderStats 
     WHERE TotalOrders > 10
    ) AS Emp_Orders_GT_10,
    
    (SELECT COUNT(*) 
     FROM EmployeeOrderStats 
     WHERE TotalOrders = 0
    ) AS Emp_No_Orders,
    
    (SELECT COUNT(*) 
     FROM EmployeeOrderStats 
     WHERE TotalOrders > 0
    ) AS Emp_With_Orders
FROM 
    DUAL;

/* Output

EMP_OVER_AVG_AMT    EMP_ORDERS <10    EMP_NO_ORDERS   EMP_WITH_ORDERS
----------------    --------------    -------------   ---------------
9	                    9	                98	            9

*/


-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------