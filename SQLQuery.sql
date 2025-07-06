--SQL queries
SELECT * FROM pizza_sales;

-- A. KPI's for Pizza Sales

-- 1) total revenvue of pizza sales
SELECT SUM(total_price) AS total_revenue FROM pizza_sales;

-- 2) average pizza value
SELECT SUM(total_price)/SUM(quantity) AS average_pizza_value FROM pizza_sales;

-- 3) average order value
SELECT SUM(total_price)/COUNT(DISTINCT(order_id))  AS average_order_value  FROM pizza_sales;

-- 4) Total pizza sold
SELECT SUM(quantity) AS total_pizza_sold FROM pizza_sales;

-- 5) Total orders placed
SELECT COUNT(DISTINCT(order_id)) AS total_orders_placed FROM pizza_sales;

-- 6) Average pizza per order
SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) / CAST(COUNT(DISTINCT(order_id)) AS DECIMAL(10,2)) AS DECIMAL (10,2)) AS average_pizza_per_order FROM pizza_sales;



-- B. Daily trend for orders
SELECT DATENAME(DW,order_date) AS order_day,COUNT(DISTINCT(order_id)) AS total_orders
FROM pizza_sales
GROUP BY DATENAME(DW,order_date);

-- C. Hourly Trends
SELECT DATEPART(hour,order_time) AS order_hours,COUNT(DISTINCT(order_id)) AS total_orders
FROM pizza_sales
GROUP BY DATEPART(hour,order_time)
ORDER BY DATEPART(hour,order_time);

--D. 1)Pizza Category-wise Sales Percentage 
SELECT pizza_category ,CAST(CAST(sum(quantity)*100 AS DECIMAL(10,2))/(SELECT sum(quantity) from pizza_sales) AS DECIMAL (10,2)) AS pct_per_category
FROM pizza_sales
GROUP BY pizza_category
--   2)Percentage of Sales by PIZZA Category
SELECT pizza_category,ROUND(SUM(total_price)*100/(select SUM(total_price) from pizza_sales),2) AS pct_sale
FROM pizza_sales
GROUP BY pizza_category

--E) Percentage of Sales by PIZZA Size for 1st quarter
SELECT pizza_size,CAST(sum(total_price) AS DECIMAL(10,2)) AS revenue,
ROUND(SUM(total_price)*100/(select SUM(total_price) 
							from pizza_sales 
							where DATEPART(quarter,order_date)=1),2) AS pct_sale
FROM pizza_sales
WHERE DATEPART(quarter,order_date)=1
GROUP BY pizza_size
ORDER BY pct_sale DESC;

--F) Total Pizzas Sold by Pizza Category
SELECT pizza_category,SUM(quantity) AS No_of_pizzas_sold
FROM pizza_sales
GROUP BY pizza_category


--G) Top 5 best sellers by total pizzas sold
SELECT TOP 5 pizza_name,SUM(quantity) AS no_of_pizza FROM pizza_sales
GROUP BY pizza_name
ORDER BY no_of_pizza DESC ;

--H) Bottom 5 worst sellers by total pizzas sold
SELECT TOP 5 pizza_name,SUM(quantity) AS no_of_pizza FROM pizza_sales
GROUP BY pizza_name
ORDER BY no_of_pizza  ;

--I) Day with Highest Revenue
SELECT TOP 1 order_date, SUM(total_price) AS revenue
FROM pizza_sales
GROUP BY order_date
ORDER BY revenue DESC

--J) Average Number of Orders per Day
SELECT AVG(order_count) AS avg_orders_per_day
FROM (
  SELECT order_date, COUNT(DISTINCT order_id) AS order_count
  FROM pizza_sales
  GROUP BY order_date
) AS daily_orders;