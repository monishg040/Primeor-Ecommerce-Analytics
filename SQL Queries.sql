CREATE DATABASE primeor_ecommerce;
USE primeor_ecommerce;

DROP TABLE IF EXISTS ecommerce_data;

CREATE TABLE ecommerce_data (
    order_id VARCHAR(30),
    order_date VARCHAR(10),
    ship_date VARCHAR(10),
    ship_mode VARCHAR(30),
    customer_name VARCHAR(100),
    segment VARCHAR(30),
    state VARCHAR(100),
    country VARCHAR(100),
    market VARCHAR(30),
    region VARCHAR(50),
    product_id VARCHAR(30),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DECIMAL(15,2),
    quantity INT,
    discount DECIMAL(10,4),
    profit DECIMAL(20,6),
    shipping_cost DECIMAL(15,4),
    order_priority VARCHAR(20),
    year INT
);

-- Data Import
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/Users/monis/Downloads/Cleaned_Dataset.csv'
INTO TABLE ecommerce_data
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Data Validation
SELECT COUNT(*) AS total_records
FROM ecommerce_data;

SELECT *
FROM ecommerce_data
LIMIT 5;


-- =====================================================
-- BUSINESS ANALYSIS
-- =====================================================

-- 1. Overall Sales, Profit and Average Discount
SELECT 
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    AVG(discount) AS average_discount
FROM ecommerce_data;


-- 2. Top 10 Most Profitable Products
SELECT
    product_name,
    SUM(profit) AS total_profit
FROM ecommerce_data
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 10;


-- 3. Top 10 Customers by Total Sales
SELECT
    customer_name,
    SUM(sales) AS total_sales
FROM ecommerce_data
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;


-- 4. Region-wise Sales
SELECT
    region,
    SUM(sales) AS total_sales
FROM ecommerce_data
GROUP BY region
ORDER BY total_sales DESC;


-- 5. Category-wise Average Profit
SELECT
    category,
    AVG(profit) AS average_profit
FROM ecommerce_data
GROUP BY category
ORDER BY average_profit DESC;


-- 6. Category with Highest Average Discount
SELECT
    category,
    AVG(discount) AS average_discount
FROM ecommerce_data
GROUP BY category
ORDER BY average_discount DESC
LIMIT 1;


-- 7. Orders with Negative Profit
SELECT
    order_id,
    customer_name,
    product_name,
    sales,
    profit
FROM ecommerce_data
WHERE profit < 0
ORDER BY profit ASC;


-- 8. Monthly Sales Trend
SELECT
    DATE_FORMAT(
        STR_TO_DATE(order_date, '%d-%m-%Y'),
        '%Y-%m'
    ) AS month,
    SUM(sales) AS total_sales
FROM ecommerce_data
GROUP BY month
ORDER BY month;


-- 9. Market-wise Revenue
SELECT
    market,
    SUM(sales) AS total_revenue
FROM ecommerce_data
GROUP BY market
ORDER BY total_revenue DESC;


-- 10. Sub-category Performance
SELECT
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM ecommerce_data
GROUP BY sub_category
ORDER BY total_sales DESC;


-- 11. Ship Mode Usage
SELECT
    ship_mode,
    COUNT(*) AS order_count
FROM ecommerce_data
GROUP BY ship_mode
ORDER BY order_count DESC;