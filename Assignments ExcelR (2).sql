SELECT * FROM employees;

/*Q1 SELECT clause with WHERE, AND, DISTINCT, Wild Card (LIKE).a  */

SELECT employeeNumber, 
firstName,
lastName
FROM employees
WHERE reportsTo = 1102 AND jobTitle = 'Sales Rep ';

/*Q1.a  */
 use classicmodels;

SELECT * FROM products;
/*Q1.b  */

SELECT  
Distinct(productLine) FROM products
WHERE productLine LIKE '%cars';

/* Q1.b  */


SELECT * FROM customers;

/*Q2. CASE STATEMENTS for Segmentation  */

SELECT customerNumber,customerName,
CASE
WHEN  country = 'USA'  OR country='canada' THEN 'North America'
WHEN country = 'UK' OR country ='France' OR country ='Germany' THEN 'Europe'
ELSE 'other'
END AS CustomerSegment
FROM Customers;
/*Q2  */

SELECT * FROM OrderDetails;

/*Q3a.*/
SELECT * FROM OrderDetails ;

SELECT  productCode,SUM(quantityOrdered)total_Ordered
FROM OrderDetails
GROUP BY productCode
ORDER BY total_Ordered DESC
LIMIT 10;

/*Q3a.  */


/*Q3.b*/
SELECT * FROM Payments;



SELECT MONTHNAME(paymentDate) payment_Month, 
count(amount) amount
FROM payments
group by payment_Month
having amount>20
order by amount DESC;

/*Q3.b*/


/*Q4 */


CREATE DATABASE Customers_Orders ;
USE Customers_Orders ;


CREATE TABLE customers(
customer_id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
email_id VARCHAR(255) UNIQUE,
phone_number VARCHAR(20)
);


CREATE TABLE orders(
order_id INT PRIMARY KEY AUTO_INCREMENT,
customer_id int,
order_date DATE,
total_amount DECIMAL(10,2) CHECK(total_amount>0),
FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
);
 
 /*Q4   */
 
 /*Q5 */
 
 
 select * from customers;
 
SELECT * FROM ORDERS; 

SELECT C.country, COUNT(O.orderNumber) AS order_count
FROM Customers C
JOIN Orders O ON C.customerNumber = O.customerNumber
GROUP BY C.country
ORDER BY order_count DESC
Limit 5;
 /*Q5   */
 
 
 /*Q6  */
 CREATE TABLE project (
 EmployeeID INT primary key auto_increment,
 FullName VARCHAR(50),
 Gender VARCHAR(10) CHECK (Gender IN ('Male', 'Female')),
 MangerID INT
 );
 
INSERT INTO Project Values(1,'Pranaya','Male',3),
 (2,'Priyanka','Female',1),
 (3,'Preety','Female',NULL),
 (4,'Anurag','Male',1),
 (5,'Sambit','Male',1),
 (6,'Rajesh','Male',3),
 (7,'Hina','Female',3);
 
 SELECT * FROM project;
 
select  m.FullName ManagerName  , e.FullName EmpName
FROM  project e 
JOIN 
project m ON e.MangerID = m.EmployeeID;

/*Q6  */

/*Q7  */

CREATE TABLE facility(
Facility_ID INT NOT NULL,
Name VARCHAR(100),
State VARCHAR(100),
Country VARCHAR(100)
);


ALTER TABLE facility
ADD COLUMN City VARCHAR(100) NOT NULL;


ALTER TABLE facility
MODIFY COLUMN Facility_ID INT PRIMARY KEY auto_increment;

DESC facility;

/*Q7  */




/*Q8  */

SELECT * FROM orders;
SELECT * FROM Products;
SELECT * FROM orderdetails;
SELECT * FROM productlines;


CREATE VIEW product_category_sales AS
SELECT 
    pl.productLine,
    SUM(od.quantityOrdered * od.priceEach) AS total_sales,
    COUNT(DISTINCT o.orderNumber) AS number_of_orders
FROM 
    productlines pl
JOIN 
    products p ON pl.productLine = p.productLine
JOIN 
    orderdetails od ON p.productCode = od.productCode
JOIN 
    orders o ON od.orderNumber = o.orderNumber
GROUP BY 
    pl.productLine;


SELECT * FROM product_category_sales;

/*Q8  */

/*Q9  */
DELIMITER //
CREATE PROCEDURE Get_country_payments(IN input_year INT, IN input_country VARCHAR(50))
BEGIN
    SELECT 
        YEAR(p.paymentDate) AS Year, 
        c.country AS Country, 
        FORMAT(SUM(p.amount) / 1000, 0) AS TotalAmountK
    FROM 
        customers c
    JOIN 
        payments p ON c.customerNumber = p.customerNumber
    WHERE 
        YEAR(p.paymentDate) = input_year
        AND c.country = input_country 
    GROUP BY 
        YEAR(p.paymentDate), c.country;
END //
DELIMITER ;

CALL Get_country_payments(2003, 'France');


/*Q9  */


/*Q10 */

SELECT 
    c.customerName,
    COUNT(o.orderNumber) AS order_count,
    RANK() OVER (ORDER BY COUNT(o.orderNumber) DESC) AS order_frequency_rnk
FROM 
    customers c
LEFT JOIN 
    orders o ON c.customerNumber = o.customerNumber
GROUP BY 
    c.customerName
ORDER BY 
    order_frequency_rnk;
    
/*Q10 */

WITH MonthOrders AS (
    SELECT 
        YEAR(orderDate) AS Year,
        MONTH(orderDate) AS MonthNumber,
        MONTHNAME(orderDate) AS Month,
        COUNT(*) AS TotalOrders
    FROM Orders
    GROUP BY YEAR(orderDate), MONTH(orderDate)
)

SELECT 
    Year,
    Month,
    TotalOrders,
 
    CASE 
        WHEN LAG(TotalOrders) OVER (ORDER BY Year, MonthNumber) IS NULL THEN '0%'  -- Show 0% for first month in data
        ELSE 
            CONCAT(ROUND(((TotalOrders - LAG(TotalOrders) OVER (ORDER BY Year, MonthNumber)) / LAG(TotalOrders) OVER (ORDER BY Year, MonthNumber)) * 100, 0), '%')
    END AS YoY_Percentage_Change
FROM MonthOrders
ORDER BY Year, MonthNumber;

/* 10*/ 

/* 11*/

SELECT 
    productLine,
    COUNT(*) AS ProductCount
FROM products
WHERE buyPrice > (SELECT AVG(buyPrice) FROM products)
GROUP BY productLine
ORDER BY ProductCount DESC;

/* 11*/
/* 12*/
CREATE TABLE Emp_EH (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(100),
    EmailAddress VARCHAR(100)
);

DELIMITER $$

CREATE PROCEDURE InsertEmpDetails(
    IN p_EmpID INT,
    IN p_EmpName VARCHAR(100),
    IN p_EmailAddress VARCHAR(100)
)
BEGIN
   
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
     
        SELECT 'Error occurred' AS ErrorMessage;
    
  
    INSERT INTO Emp_EH (EmpID, EmpName, EmailAddress)
    VALUES (p_EmpID, p_EmpName, p_EmailAddress);
    

    SELECT 'Employee added successfully' AS SuccessMessage;
END $$

DELIMITER ;



CALL InsertEmpDetails(475634756, 'Ayush', 'Ayushsnwn1202@gmail.com');
/* 12*/
/* 13*/

CREATE TABLE Emp_BIT (
    Name VARCHAR(100),
    Occupation VARCHAR(100),
    Working_date DATE,
    Working_hours INT
);
INSERT INTO Emp_BIT (Name, Occupation, Working_date, Working_hours) VALUES
('Robin', 'Scientist', '2020-10-04', 12),
('Warner', 'Engineer', '2020-10-04', 10),
('Peter', 'Actor', '2020-10-04', 13),
('Marco', 'Doctor', '2020-10-04', 14),
('Brayden', 'Teacher', '2020-10-04', 12),
('Antonio', 'Business', '2020-10-04', 11);

DELIMITER $$

CREATE TRIGGER BeforeInsert_WorkingHours
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN
    -- If Working_hours is negative, convert it to positive
    IF NEW.Working_hours < 0 THEN
        SET NEW.Working_hours = ABS(NEW.Working_hours);
    END IF;
END $$

DELIMITER ;

SELECT * FROM Emp_BIT;


