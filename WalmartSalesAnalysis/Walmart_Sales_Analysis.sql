USE walmartsales;

-- Create the database 
CREATE DATABASE IF NOT EXISTS walmartsales;

-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR (30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
	VAT FLOAT(6, 4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11, 9),
    gross_income DECIMAL(12, 4) NOT NULL,
    rating FLOAT(2, 1)
);

----------------------------------------------
------------ Data Cleaning Stage---------------
SELECT
	*
FROM 
	sales
    
-- Add the time_of_day column to the table
SELECT
	time,
    (CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
	END) AS time_of_day
FROM
	sales;
    
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
	END
);

-- Add the day_name column to the table
SELECT
	date,
    DAYNAME(date)
FROM 
	sales;
    
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

-- Add the month_name column to the
SELECT
	date,
    MONTHNAME(date)
FROM
	sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);
----------------------------------------------------------

---------------------- Generic ---------------------------

-- Look at how many unique cities in the dataset
SELECT
	DISTINCT city
FROM
	sales

-- Look at how many branches in the dataset
SELECT
	DISTINCT branch
FROM
	sales
    
--------------------------------------------    
---------------- Product -------------------

-- Look at how many unique product lines in the dataset
SELECT
	COUNT(DISTINCT product_line) AS uniqe_product_lines
FROM 
	sales;

-- Look at the most common payment method
SELECT
	payment_method,
    COUNT(payment_method) AS number_of_payment_method
FROM
	sales
GROUP BY
	payment_method
ORDER BY
	number_of_payment_method DESC;

-- Look at the most selling product line
SELECT
	product_line,
    COUNT(product_line) AS number_of_product_line
FROM
	sales
GROUP BY
	product_line
ORDER BY 
	number_of_product_line DESC
    
-- Look at the total revenue by month
SELECT
	month_name AS month,
    SUM(total) AS total_revenue
FROM
	sales
GROUP BY
	month_name
ORDER BY
	total_revenue DESC;

-- Look at the month had the largest COGS
SELECT
	month_name AS month,
    SUM(cogs) AS cogs
FROM
	sales
GROUP BY
	month_name
ORDER BY 	
	cogs DESC;

-- Look at the product line had the largest revenue
SELECT
	product_line,
    SUM(total) AS total_revenue
FROM
	sales
GROUP BY
	product_line
ORDER BY 
	total_revenue DESC

-- Look at the city had the largest revenue
SELECT
	city,
    branch,
    SUM(total) AS total_revenue
FROM
	sales
GROUP BY 
	city,
    branch
ORDER BY 
	total_revenue DESC;

-- Look at the product line had the largest VAT	
SELECT
	product_line,
    AVG(VAT) AS avg_tax
FROM 
	sales
GROUP BY
	product_line
ORDER BY
	avg_tax DESC;SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

-- Look at the branch sold more products than average product sold
SELECT
	branch,
    SUM(quantity) AS quantity
FROM 
	sales
GROUP BY
	branch
HAVING
	SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- Look at the most common product line by gender
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_gender
FROM
	sales
GROUP BY
	gender,
    product_Line
ORDER BY
	total_gender DESC
    
-- Look at the average rating of each product line
SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM 
	sales
GROUP BY 
	product_line
ORDER BY 
	avg_rating DESC;

-- Look at the remark of each product line in the dataset
SELECT 
	AVG(quantity) AS avg_quantity
FROM 
	sales;
SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM 
	sales
GROUP BY 
	product_line;

--------------------------------------------
--------------- Sales ----------------------

-- Look at the number of sales made in each time of the day per weekday
SELECT
	time_of_day,
    COUNT(*) AS total_sales
FROM
	sales
WHERE
	day_name = "Monday"
GROUP BY
	time_of_day
ORDER BY
	total_sales DESC;

-- Look at the customer type brought the most revenue
SELECT
	customer_type,
    SUM(total) AS total_revenue
FROM	
	sales
GROUP BY 
	customer_type
ORDER BY
	total_revenue DESC;

-- Look at the city had the largest tax percent/ VAT (Value Added Tax)
SELECT
	city,
    AVG(VAT) AS average_VAT
FROM 
	sales
GROUP BY
	city,
    VAT
ORDER BY
	VAT DESC;

-- Look at the customer type paid the most in VAT 
SELECT
	customer_type,
    AVG(VAT) AS average_VAT
FROM
	sales
GROUP BY
	customer_type,
    VAT
ORDER BY
	average_VAT DESC

-----------------------------------------
---------------- Customers ---------------

-- Look at unique customer types in the dataset
SELECT
	DISTINCT customer_type
FROM
	sales;
    
-- Look at unique payment methods in the dataset
SELECT
	DISTINCT payment_method
FROM
	sales;

-- Look at the most common customer type
SELECT
	customer_type,
	count(*) as number_of_customer_type
FROM 
	sales
GROUP BY 
	customer_type
ORDER BY 
	number_of_customer_type DESC;
    
-- Look at the customer type bought the most	
SELECT
	customer_type,
    COUNT(*) AS customer_count
FROM
	sales
GROUP BY 
	customer_type

-- Look at the gender of most of the customers
SELECT
	gender,
    COUNT(*) AS gender_count
FROM
	sales
GROUP BY 
	gender
ORDER BY
	gender
    
-- Look at the gender distribution per branch
SELECT
	branch,
	gender,
    COUNT(*) AS gender_count
FROM
	sales
WHERE
	branch = "B"
GROUP BY 
	gender
ORDER BY
	gender DESC
	
-- Look at the time of the day customers give most ratings
SELECT
	time_of_day,
    AVG(rating) AS average_rating
FROM
	sales
GROUP BY 
	time_of_day
ORDER BY
	average_rating DESC;
    
-- Look at the time of the day the customers give most ratings per branch
SELECT
	branch,
    time_of_day,
    AVG(rating) AS average_rating
FROM
	sales
WHERE 
	branch = "A"
GROUP BY
	time_of_day
ORDER BY
	average_rating DESC;
    
-- Look at the day of the week had the best average ratings
SELECT
	day_name,
    AVG(rating) AS average_rating
FROM
	sales
GROUP BY
	day_name
ORDER BY
	average_rating DESC;

-- Look at the day of the week had the best average ratings per branch
SELECT
	day_name,
    AVG(rating) AS average_rating
FROM
	sales
WHERE 
	branch = "B"
GROUP BY 
	day_name
ORDER BY
	average_rating DESC;