-- SQL retail sales analysis - P1

CREATE DATABASE sql_project_p1;
USE sql_project_p1;

-- Create Table

DROP TABLE IF EXISTS Retail_Sales;
CREATE TABLE Retail_Sales (
transactions_id INT PRIMARY KEY,	
sale_date DATE,	
sale_time TIME,	
customer_id INT,
gender VARCHAR(10), 	
age INT,
category VARCHAR(50),	
quantity INT,
price_per_unit FLOAT,	
cogs FLOAT,
total_sale FLOAT
);

-- Data Cleaning --

SELECT 
* 
FROM retail_sales
WHERE
	transactions_id IS NULL
    OR
    sale_date IS NULL
    OR
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR 
    total_sale IS NULL;
    
-- Data Exploration --

-- How many sales we have --

SELECT 
COUNT(*) AS total_sale 
FROM retail_sales;

-- How many unique customers do we have? --

SELECT 
COUNT(DISTINCT customer_id) AS total_sale 
FROM retail_sales;

SELECT 
DISTINCT category 
FROM retail_sales;

-- Data Analysis & Business Key problems --

# Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT 
* 
FROM retail_sales
WHERE sale_date = '2022-11-05';

# Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

SELECT 
*
FROM retail_sales
WHERE category = 'Clothing' 
AND DATE_FORMAT(sale_date, 'YYYY-MM') = '2022-11'
AND quantity > 10;


# Q.3 Write a SQL query to calculate the total sales (total_sale) for each category)

SELECT 
category, 
SUM(total_sale) as net_sale, 
COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;

# Q.4 Write a SQL query to find the average age of cutomers who purchased items from the 'Beauty' category

SELECT 
category, 
ROUND(AVG(age),2) AS Average_Age
FROM retail_sales
WHERE category = 'Beauty';

# Q.5 Write a SQL query to find all the transactions where the total_sale is greater than 1000.

SELECT 
* 
FROM retail_sales
WHERE total_sale > 1000;

# Q.6 Write a SQL query to find the total number of transactions (transactions_id) made by each gender in each category

SELECT 
category, 
gender, 
COUNT(*) as total_trans
FROM retail_sales
GROUP BY category, gender;

# Q.7 Write a SQL query to  calculate the average sale for each month. Find out best seeling month in each year

SELECT
	Year,
    Month,
    average_sales
FROM
(
SELECT 
YEAR(sale_date) as Year, 
MONTH(sale_date) as Month, 
ROUND(AVG(total_sale),2) as average_sales, 
RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) as ranking
FROM retail_sales
GROUP BY Year, Month
) as t1
WHERE ranking = 1;

# Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

SELECT 
customer_id, 
SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

# Q.9 Write a SQL query to  find the number of unique customers who purchased items from each category

SELECT 
category, COUNT(DISTINCT customer_id) as Unique_Customers
FROM retail_sales
GROUP BY category
;

# Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH sales_by_shift
AS
(
SELECT
*,
CASE 
	WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening' 
END as shift
FROM retail_sales
)

SELECT 
COUNT(transactions_id) as total_orders, shift
FROM sales_by_shift
GROUP BY shift
;