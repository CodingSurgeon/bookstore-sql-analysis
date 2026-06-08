-- ================================================================
--  Bookstore Database Analysis
--  Tools  : PostgreSQL
--  Author  : Prikshit kumar
--  GitHub  : github.com/CodingSurgeon
-- ================================================================

-- ================================================================
-- DATABASE SETUP
-- ================================================================

DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Books (
    Book_ID        SERIAL PRIMARY KEY,
    Title          VARCHAR(100),
    Author         VARCHAR(100),
    Genre          VARCHAR(50),
    Published_Year INT,
    Price          NUMERIC(10, 2),
    Stock          INT
);

CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name        VARCHAR(100),
    Email       VARCHAR(100),
    Phone       VARCHAR(15),
    City        VARCHAR(50),
    Country     VARCHAR(150)
);

CREATE TABLE Orders (
    Order_ID     SERIAL PRIMARY KEY,
    Customer_ID  INT REFERENCES Customers(Customer_ID),
    Book_ID      INT REFERENCES Books(Book_ID),
    Order_Date   DATE,
    Quantity     INT,
    Total_Amount NUMERIC(10, 2)
);


-- ================================================================
-- DATA IMPORT
-- ================================================================

COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
FROM 'D:\SQL.EXCEL\Books.csv' CSV HEADER;

COPY Customers(Customer_ID, Name, Email, Phone, City, Country)
FROM 'D:\SQL.EXCEL\Customers.csv' CSV HEADER;

COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM 'D:\SQL.EXCEL\Orders.csv' CSV HEADER;


-- ================================================================
-- SECTION 1: BASIC DATA RETRIEVAL
-- ================================================================

-- Q1. The marketing team wants a list of all Fiction books
--     to plan an upcoming genre-based promotion.

SELECT * FROM Books
WHERE Genre = 'Fiction';


-- Q2. The acquisitions team is reviewing the catalog for
--     modern titles. Retrieve all books published after 1950.

SELECT * FROM Books
WHERE Published_Year > 1950;


-- Q3. The sales team is planning a Canada-specific campaign.
--     Pull all customers based in Canada.

SELECT * FROM Customers
WHERE Country = 'Canada';


-- Q4. Finance needs to audit transactions from November 2023.
--     Show all orders placed during that month.

SELECT * FROM Orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';


-- Q5. The warehouse team needs to know the total number
--     of books currently available across all titles.

SELECT SUM(Stock) AS Total_Stock
FROM Books;


-- Q6. Identify the highest-priced book in the catalog
--     for a premium pricing review.

SELECT * FROM Books
ORDER BY Price DESC
LIMIT 1;


-- Q7. Find all orders where a customer purchased more
--     than one copy, to study bulk buying behavior.

SELECT * FROM Orders
WHERE Quantity > 1;


-- Q8. Retrieve orders where the transaction value exceeded $20
--     to segment high-value purchases.

SELECT * FROM Orders
WHERE Total_Amount > 20;


-- Q9. Get a clean list of all unique genres currently
--     available in the bookstore catalog.

SELECT DISTINCT Genre FROM Books;


-- Q10. Flag the book with the lowest stock level
--      so the inventory team can prioritize restocking.

SELECT * FROM Books
ORDER BY Stock
LIMIT 1;


-- Q11. Calculate the total revenue generated from
--      all customer orders to date.

SELECT SUM(Total_Amount) AS Total_Revenue
FROM Orders;


-- ================================================================
-- SECTION 2: BUSINESS INTELLIGENCE & ADVANCED ANALYSIS
-- ================================================================

-- Q1. Which genres are driving the most sales volume?
--     Aggregate total units sold by genre.

SELECT b.Genre,
       SUM(o.Quantity) AS Total_Units_Sold
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Genre
ORDER BY Total_Units_Sold DESC;


-- Q2. The buyer wants to understand Fantasy book pricing.
--     Calculate the average price within that genre.

SELECT AVG(Price) AS Avg_Fantasy_Price
FROM Books
WHERE Genre = 'Fantasy';


-- Q3. Identify repeat customers — those who have placed
--     two or more orders. These are high-retention customers.

SELECT c.Customer_ID,
       c.Name,
       COUNT(o.Order_ID) AS Total_Orders
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Name
HAVING COUNT(o.Order_ID) >= 2
ORDER BY Total_Orders DESC;


-- Q4. Which book title appears most frequently in orders?
--     This reveals the store's best-performing product.

SELECT b.Title,
       COUNT(o.Order_ID) AS Times_Ordered
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY o.Book_ID, b.Title
ORDER BY Times_Ordered DESC
LIMIT 1;


-- Q5. For a Fantasy genre spotlight, pull the three
--     most premium-priced titles in that category.

SELECT Title, Author, Price
FROM Books
WHERE Genre = 'Fantasy'
ORDER BY Price DESC
LIMIT 3;


-- Q6. Which authors have moved the most copies overall?
--     Rank authors by total quantity sold across all orders.

SELECT b.Author,
       SUM(o.Quantity) AS Total_Copies_Sold
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Author
ORDER BY Total_Copies_Sold DESC;


-- Q7. Where are our high-spending customers located?
--     List distinct cities from orders exceeding $30.

SELECT DISTINCT c.City
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
WHERE o.Total_Amount > 30
ORDER BY c.City;


-- Q8. Who is the store's top customer by total spend?
--     Useful for loyalty programs or personalized outreach.

SELECT c.Customer_ID,
       c.Name,
       SUM(o.Total_Amount) AS Lifetime_Value
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Name
ORDER BY Lifetime_Value DESC
LIMIT 1;


-- Q9. After processing all orders, how many copies of each
--     book remain in stock? Flags any titles going negative.

SELECT b.Book_ID,
       b.Title,
       b.Stock                                    AS Original_Stock,
       COALESCE(SUM(o.Quantity), 0)               AS Units_Sold,
       b.Stock - COALESCE(SUM(o.Quantity), 0)     AS Remaining_Stock
FROM Books b
LEFT JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title, b.Stock
ORDER BY Remaining_Stock ASC;