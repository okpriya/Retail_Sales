create database sql_project_p1;
create table retail_sales (
transaction_id INT,
sale_date DATE,
sale_time TIME,
customer_id INT,
gender VARCHAR(15),
age INT,
category VARCHAR(15),
quantiy INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
);

SELECT*FROM RETAIL_SALES;

select count(*) FROM RETAIL_SALES;

-- Data Cleaning
select *from RETAIL_SALES where sale_date is null;
SELECT * FROM retail_sales
WHERE sale_time IS NULL;

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
	
 -- Data Exploration
 -- Q1. How many sales we have?
 select count(*) as tota_sale from retail_sales;

 -- Q2.How many uniuque customers we have ?
 select count(distinct customer_id) from retail_sales;

-- Data Analysis 
  -- Q3. Write a SQL query to retrieve all columns for sales made on '2022-11-05?
  select*from retail_sales where sale_date = '2022-11-05';
 
 --Q4. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantiy >= 4;

-- Q5.Write a SQL query to calculate the total sales (total_sale) for each category.
select category,sum(total_sale) as net_sales,
  COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;

-- Q6. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),2) as avg_age from retail_sales
where category ='Beauty';

-- Q7.Write a SQL query to find all transactions where the total_sale is greater than 1000.
select*from retail_sales where total_sale > 1000;


-- Q8. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select category,count(*) as total_transactions,gender
from retail_sales group by category,gender order by 1;

-- Q9.Write a SQL query to calculate the average sale for each month. 
--Find out best selling month in each year

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1
ORDER BY 1, 3 DESC;

-- Q10.Write a SQL query to find the top 5 customers based on the highest total sales?
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--Q11. Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category;

-- Q12. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;



  