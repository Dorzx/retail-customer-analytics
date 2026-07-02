
-- 03 SQL Business Metrics
-- This file contains reusable SQL queries for retail business reporting.

-- 1. Overall KPI Metrics

SELECT
    ROUND(SUM(revenue), 2) AS product_sales_revenue,
    COUNT(DISTINCT invoice) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(SUM(revenue) / COUNT(DISTINCT invoice), 2) AS average_order_value,
    SUM(quantity) AS total_quantity_sold
FROM clean_product_sales;


-- 2. Monthly Product Sales Metrics

SELECT
    invoice_month,
    ROUND(SUM(revenue), 2) AS product_sales_revenue,
    COUNT(DISTINCT invoice) AS orders,
    COUNT(DISTINCT customer_id) AS customers,
    SUM(quantity) AS quantity_sold,
    ROUND(SUM(revenue) / COUNT(DISTINCT invoice), 2) AS average_order_value
FROM clean_product_sales
GROUP BY invoice_month
ORDER BY invoice_month;


-- 3. Country Performance Metrics

SELECT
    country,
    Round(sum(revenue), 2) AS product_sales_revenue,
    COUNT(DISTINCT invoice) AS orders,
    COUNT(DISTINCT customer_id) AS customers,
    SUM(quantity) AS quantity_sold,
    ROUND(SUM(revenue) / COUNT(DISTINCT invoice), 2) AS average_order_value
FROM clean_product_sales
GROUP BY country
ORDER BY product_sales_revenue DESC;


-- 4. Product-Level Sales Metrics

SELECT
    stockcode,
    description,
    ROUND(SUM(revenue), 2) AS product_sales_revenue,
    SUM(quantity) AS quantity_sold,
    COUNT(DISTINCT invoice) AS orders,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(AVG(price), 2) AS average_unit_price
FROM clean_product_sales
GROUP BY stockcode, description
ORDER BY product_sales_revenue DESC, stockcode ASC, description ASC;

