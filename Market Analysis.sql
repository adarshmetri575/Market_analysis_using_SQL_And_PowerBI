use project_orders;

-- Q.1. What are the top 10 aisles with the highest number of products?
SELECT
    a.aisle_id,
    a.aisle,
    COUNT(p.product_id) AS total_products
FROM products AS p
INNER JOIN aisles AS a
    ON p.aisle_id = a.aisle_id
GROUP BY
    a.aisle_id,
    a.aisle
ORDER BY
    total_products DESC
LIMIT 10;

-- Q.2.	How many unique departments are there in the dataset?
SELECT COUNT(*) AS unique_departments
FROM departments;

-- Q.3.	What is the distribution of products across departments?
SELECT
    d.department_id,
    d.department,
    COUNT(p.product_id) AS total_products
FROM products p
JOIN departments d
    ON p.department_id = d.department_id
GROUP BY d.department_id, d.department
ORDER BY total_products DESC;

-- Q.4.	What are the top 10 products with the highest reorder rates?
SHOW TABLES;
DESCRIBE order_products_train;
SELECT
    p.product_id,
    p.product_name,
    COUNT(*) AS total_orders,
    SUM(op.reordered) AS total_reorders,
    ROUND(AVG(op.reordered) * 100, 2) AS reorder_rate
FROM order_products_train AS op
INNER JOIN products AS p
    ON op.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY
    reorder_rate DESC
LIMIT 10;

-- Q.5.	How many unique users have placed orders in the dataset?
SELECT COUNT(DISTINCT user_id)
AS unique_users
FROM orders;

-- Q.6.	What is the average number of days between orders for each user?
SELECT
    user_id,
    ROUND(AVG(days_since_prior_order), 2)
    AS avg_days_between_orders
FROM orders
WHERE days_since_prior_order IS NOT NULL
GROUP BY user_id
ORDER BY user_id;

-- Q.7.	What are the peak hours of order placement during the day?
SELECT
    order_hour_of_day,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_hour_of_day
ORDER BY total_orders DESC;

-- Q.8.	How does order volume vary by day of the week?
SELECT
    order_dow,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_dow
ORDER BY order_dow;

-- Q.9.	What are the top 10 most ordered products?
SELECT
    p.product_id,
    p.product_name,
    COUNT(*) AS total_orders
FROM order_products_train AS op
INNER JOIN products AS p
    ON op.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY
    total_orders DESC
LIMIT 10;

-- Q.10. How many users have placed orders in each department?
show tables;
SELECT * FROM departments;
SELECT
    d.department_id,
    d.department,
    COUNT(DISTINCT o.user_id) AS unique_users
FROM orders AS o
INNER JOIN order_products_train AS op
    ON o.order_id = op.order_id
INNER JOIN products AS p
    ON op.product_id = p.product_id
INNER JOIN departments AS d
    ON p.department_id = d.department_id
GROUP BY
    d.department_id,
    d.department
ORDER BY
    unique_users DESC;

-- 	Q.11. What is the average number of products per order?
SELECT
    ROUND(AVG(product_count), 2) AS avg_products_per_order
FROM (
    SELECT
        order_id,
        COUNT(product_id) AS product_count
    FROM order_products_train
    GROUP BY order_id
)
AS order_summary;

-- Q.12. What are the most reordered products in each department?
SELECT
    d.department_id,
    d.department,
    p.product_id,
    p.product_name,
    COUNT(*) AS total_reorders
FROM order_products_train AS op
INNER JOIN products AS p
    ON op.product_id = p.product_id
INNER JOIN departments AS d
    ON p.department_id = d.department_id
WHERE op.reordered = 1
GROUP BY
    d.department_id,
    d.department,
    p.product_id,
    p.product_name
ORDER BY
    d.department_id,
    total_reorders DESC;

-- Q.13. How many products have been reordered more than once?
SELECT COUNT(*) AS products_reordered_more_than_once
FROM (
    SELECT
        product_id,
        SUM(reordered) AS total_reorders
    FROM order_products_train
    WHERE reordered = 1
    GROUP BY product_id
    HAVING SUM(reordered) > 1
) AS reordered_products;

-- Q.14. What is the average number of products added to the cart per order?
SELECT
    ROUND(AVG(product_count), 2) AS avg_products_added_per_order
FROM (
    SELECT
        order_id,
        COUNT(product_id) AS product_count
    FROM order_products_train
    GROUP BY order_id
) AS order_summary;

-- Q.15. How does the number of orders vary by hour of the day?
SELECT
    order_hour_of_day,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_hour_of_day
ORDER BY order_hour_of_day;

-- Q.16. What is the distribution of order sizes (number of products per order)?
SELECT
    products_per_order,
    COUNT(*) AS number_of_orders
FROM (
    SELECT
        order_id,
        COUNT(product_id) AS products_per_order
    FROM order_products_train
    GROUP BY order_id
) AS order_sizes
GROUP BY products_per_order
ORDER BY products_per_order;

-- Q.17. What is the average reorder rate for products in each aisle?
SELECT
    a.aisle_id,
    a.aisle,
    ROUND(AVG(op.reordered) * 100, 2) AS avg_reorder_rate
FROM order_products_train AS op
INNER JOIN products AS p
    ON op.product_id = p.product_id
INNER JOIN aisles AS a
    ON p.aisle_id = a.aisle_id
GROUP BY
    a.aisle_id,
    a.aisle
ORDER BY
    avg_reorder_rate DESC;
    
-- Q.18. How does the average order size vary by day of the week?
SELECT
    order_dow,
    ROUND(AVG(order_size), 2) AS avg_order_size
FROM (
    SELECT
        o.order_id,
        o.order_dow,
        COUNT(op.product_id) AS order_size
    FROM orders AS o
    INNER JOIN order_products_train AS op
        ON o.order_id = op.order_id
    GROUP BY
        o.order_id,
        o.order_dow
) AS order_summary
GROUP BY
    order_dow
ORDER BY
    order_dow;
    
-- Q.19. What are the top 10 users with the highest number of orders?
SELECT
    user_id,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY user_id
ORDER BY total_orders DESC
LIMIT 10;

-- Q.20. How many products belong to each aisle and department?
SELECT
    a.aisle_id,
    a.aisle,
    d.department_id,
    d.department,
    COUNT(DISTINCT p.product_id) AS total_products
FROM products AS p
INNER JOIN aisles AS a
    ON p.aisle_id = a.aisle_id
INNER JOIN departments AS d
    ON p.department_id = d.department_id
GROUP BY
    a.aisle_id,
    a.aisle,
    d.department_id,
    d.department
ORDER BY
    d.department_id,
    a.aisle_id;