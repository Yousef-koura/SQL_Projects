-- ============================================
-- DATABASE SETUP
-- ============================================
CREATE DATABASE retail_sales;
USE retail_sales;

-- ============================================
-- EXPLORATION
-- ============================================

-- View all records
SELECT * FROM retail_sales;

-- Count total rows
SELECT COUNT(*) AS total_rows FROM retail_sales;

-- ============================================
-- NULL CHECKING
-- ============================================

-- Check how many rows have null values
SELECT COUNT(*) AS null_rows
FROM retail_sales
WHERE 
    transactions_id IS NULL
    OR sale_time    IS NULL
    OR gender       IS NULL
    OR category     IS NULL
    OR quantiy      IS NULL
    OR cogs         IS NULL
    OR total_sale   IS NULL;

-- Preview which rows have nulls (before deleting)
SELECT * FROM retail_sales
WHERE 
    transactions_id IS NULL
    OR sale_time    IS NULL
    OR gender       IS NULL
    OR category     IS NULL
    OR quantiy      IS NULL
    OR cogs         IS NULL
    OR total_sale   IS NULL;

-- ============================================
-- DATA CLEANING
-- ============================================

-- Delete only the null rows (NOT the whole table)
DELETE FROM retail_sales
WHERE 
    transactions_id IS NULL
    OR sale_time    IS NULL
    OR gender       IS NULL
    OR category     IS NULL
    OR quantiy      IS NULL
    OR cogs         IS NULL
    OR total_sale   IS NULL;

-- Confirm rows were removed
SELECT COUNT(*) AS total_rows_after_cleaning FROM retail_sales;

-- ============================================
-- EXPLORATION
-- ============================================

-- total sales
select count(*) as total_sales from retail_sales;

-- how many customer we have (distinct) --> unique no duplicates
select count(distinct customer_id) as customer_count from retail_sales;
select count(distinct category) as category_count from retail_sales;

-- data analysis $ business key problems and answers

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * 
from retail_sales
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
    AND quantiy >= 4
    AND YEAR(sale_date)  = 2022
    AND MONTH(sale_date) = 11;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select 
    category, 
    sum(total_sale) as net_sale,
    count(*) as total_orders
from retail_sales
group by category

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select
    category = 'Beauty',
    AVG(age) as averge_age
from retail_sales
where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select *
from retail_sales
where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select 
    category,
    gender,
    count(*) as total_transactions
from retail_sales
group by category, gender
order by total_transactions desc;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select 
    year,
    month,
    avg_sale
from
(
    SELECT 
        YEAR(sale_date)             AS year,
        MONTH(sale_date)            AS month,
        ROUND(AVG(total_sale), 2)   AS avg_sale,
        RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) as rnk
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) as t1
where rnk = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT TOP 5
    customer_id,
    SUM(total_sale)     AS net_customer_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY net_customer_sales DESC;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select
    category,
    count(distinct customer_id) as unique_customer
from retail_sales
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with hourly_sales as
(
    select
        *,
        case
            when DATEPART(HOUR, sale_time) < 12 then 'morning'
            when DATEPART(HOUR, sale_time) between 12 and 17 then 'afternoon'
            else 'evening'
        end as shift
    from retail_sales
)
select
    shift,
    count(*) as total_orders
from hourly_sales
group by shift;
