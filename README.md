# bookstore-sql-analysis
SQL project analyzing a bookstore database - inventory, sales trends, and customer behavior using PostgreSQL

Bookstore Database Analysis
A SQL project built around a fictional bookstore — three tables, real business questions.
I put this together to practice writing queries that go beyond just selecting data. The goal was to think about what a business would actually want to know from this kind of dataset — things like which genres sell the most, who the repeat customers are, and whether stock levels are keeping up with orders.
________________________________________
Database Structure
Three tables — Books, Customers, and Orders.
Books       → Book_ID, Title, Author, Genre, Published_Year, Price, Stock
Customers   → Customer_ID, Name, Email, Phone, City, Country
Orders      → Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount
________________________________________
What I Worked On
Basic Retrieval
•	Filtering by genre, publication year, and country
•	Pulling orders within a specific date range
•	Sorting by price and stock levels
•	Aggregating total stock and total revenue
Business Analysis
•	Which genres are selling the most units
•	Authors ranked by total copies sold
•	Customers who have placed repeat orders
•	The highest-spending customer by lifetime value
•	Cities where high-value orders are coming from
•	Stock reconciliation after fulfilling all orders
________________________________________
Tools Used
•	PostgreSQL
•	pgAdmin
________________________________________
Files
File	Description
bookstore_portfolio.sql	All 20 queries with business context, organized into basic and advanced sections
Books.csv	Raw book catalog data — title, author, genre, publication year, price, and stock
Customers.csv	Customer records including name, contact details, city, and country
Orders.csv	Transaction data capturing order date, quantity, and total amount
________________________________________
How to Run
1.	Create a database called bookstore in pgAdmin
2.	Open the Query Tool and run bookstore_portfolio.sql
3.	Download the CSV files from this repo, note the folder path where you saved them, and update the COPY statements in the SQL file to match that path
________________________________________
Why I Built This
I am working toward a Business Analyst role and wanted to get comfortable using SQL to answer the kind of questions that actually come up in that work — not just writing queries, but thinking about what the data is saying and why someone would need it.
This is one of a few projects I am building out as I look for my first role.

