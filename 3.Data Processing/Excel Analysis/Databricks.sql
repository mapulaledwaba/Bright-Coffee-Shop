-----Query 1 : We want to see the first 100 entries
SELECT * 
from `bright_coffee_shop`.`default`.`bright_coffee_shop_case_study` 
limit 100;

---------------------------------------------------------------------------------------------------------------------
--------CHECKING THE DATE RANGE
--------They started collecting the data 2023-01-01 and they last collected the data 2023-06-30
SELECT MIN(transaction_date) AS first_date,
       MAX(transaction_date) AS last_date
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_case_study`;
------------------------------------------------------------------------------------------------------------------------
----Query 2.1 : we want to know how many store locations we have
---- We have 3 stores in total
SELECT Count(store_location) AS number_of_stores
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_case_study`;

---Query 2.2: we want to know the names of store locations
-----The names of the stores are Lower Manhattan, Hell's Kitchen and Astoria
SELECT DISTINCT store_location
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_case_study`;
-----------------------------------------------------------------------------------------------------------------------
----
----Calculating the revenue
SELECT unit_price,
       transaction_qty,
       unit_price*transaction_qty AS Revenue
 FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_case_study`;      

---Query 3.1 : Total sales made
SELECT SUM(unit_price * transaction_qty) AS total_sales
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_case_study`;

---Query3.2 : Total sales made in each product category
SELECT SUM(unit_price * transaction_qty) AS total_sales,
        product_category
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_case_study`
GROUP BY product_category;      

---Query3.3 : Total sales made in each store location in ascending order
SELECT SUM(unit_price * transaction_qty) AS total_sales,
        store_location
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_case_study`
GROUP BY store_location
ORDER BY store_location ASC;
-------------------------------------------------------------------------------------------------------------------------------

--- Query 4.1 : Grouping transactions into time buckets
SELECT date_trunc('hour',transaction_time) AS time_hours
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_case_study`
GROUP BY date_trunc('hour', transaction_time);

---Query 4.2 : Grouping transations into time buckets
SELECT date_trunc('month',transaction_date) AS time_month
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_case_study`
GROUP BY date_trunc('month',transaction_date);


-----------------------------------------------------------------------------------------------------------------------------------

-----Aggregate Functions


---Query 5.1: Highest and lowest prices
SELECT MAX(unit_price) AS highest_price,
       MIN(unit_price) AS lowest_price
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_case_study`;       

---Query 5.2: Average unit_price
 SELECT AVG(unit_price) AS average_price
 FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_case_study`;  

 ----Query 5.3: How many coffees were bought on 1/1/2023
 SELECT COUNT(product_category) AS coffees_bought,
        transaction_date
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_case_study`
WHERE DATE(transaction_date) = '2023-01-01'
GROUP BY transaction_date;   


-----------------------------------------------------------------------------------------
----Query 6: Checking the products we sell at our stores
SELECT DISTINCT product_category,
                product_detail,
                product_type
 FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_case_study`; 

 
 
 ---Query 7 : Different product categories
 SELECT product_category 
 FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_case_study`
 WHERE product_category IN('Coffee','Tea','Bakery'); 

   

 ---Query 8: product detail is not oatmeal
 SELECT product_category,
        product_type,
        product_detail
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_case_study`
WHERE NOT product_detail= 'oatmeal scone';          



---Query 9: The first 110 entries with unit prices ranging between 1 and 5
SELECT unit_price,
       product_category,
       product_type
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_case_study`
WHERE unit_price BETWEEN 1 AND 5
ORDER BY unit_price ASC
LIMIT 150;   


-------------------------------------CASE STATEMENTS---------------------------------------------------------------------------------------
---Query 10.1: Case statement
SELECT product_id,
       product_category,
       product_type,
       product_detail,
       unit_price,
        CASE 
             WHEN unit_price< 3 THEN 'cheap'
             WHEN unit_price BETWEEN 2 AND 4 THEN 'mid-range'
             WHEN unit_price> 4 THEN 'expensive'
         END AS TYPE
 FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_case_study`;        


 ---Query 10.2 : case statement
 SELECT transaction_time,
        transaction_date,
         CASE
         WHEN HOUR(transaction_time) <9 THEN 'early'
         WHEN HOUR(transaction_time) BETWEEN 9 AND 12 THEN 'on-time'
         WHEN HOUR(transaction_time) > 12 THEN 'late'
         END AS time_bucket
         FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_case_study`;

----------------------------------------------------------------------------------------------------------------------------------------


 ---Query 12 : Unique store locations that offer brewed herbal tea 
 SELECT DISTINCT  store_location,
         product_type
  FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_case_study`
  WHERE product_type='Brewed herbal tea';
        
  ---Query 13 : First 30 customers to purchase Brewed Chai tea, Scone or Biscotti in lower manhattan
  SELECT store_location,
         product_type
  FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_case_study`
  WHERE store_location ='Lower Manhattan'AND product_type IN('Brewed Chai tea', 'Scone','Biscotti')
  LIMIT 30;

---How many quanties were bought at each store location
SELECT SUM(transaction_qty) AS number_of_products_sold,
       store_location
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_case_study`
GROUP BY store_location;       

---Checking for nulls
SELECT *
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_case_study`
WHERE product_category IS NULL
   OR unit_price IS NULL
   OR transaction_date IS NULL;


----Checking the number of sales and revenue by per day for each month
SELECT 
      transaction_date,
      Dayname(transaction_date) AS Day_name,
      Monthname(transaction_date) AS Month_name,
      COUNT(DISTINCT transaction_id) AS Number_of_sales,
      SUM(transaction_qty*unit_price) AS revenue_per_day

FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_case_study`
GROUP BY transaction_date,
         Day_name,
         Month_name;


---   Extracting the day and month names
SELECT transaction_date, 
       Dayname(transaction_date) AS Day_name,
       Monthname(transaction_date) AS Month_name
FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_case_study`;       




---Combining all queries to get an enhanced dataset
SELECT transaction_id,
       transaction_date,
       transaction_time,
       transaction_qty,
       store_id,
       store_location,
       product_id,
       unit_price,
       product_category,
       product_type,
       product_detail,
---Adding columns to enhance the table for better insights
---New column added 1
       Dayname(transaction_date) AS Day_name,
 ----New column 2      
       Monthname(transaction_date) AS Month_name,
---New column 3       
       Dayofmonth(transaction_date) AS Date_of_month,
---New column 4, determining weekday and weekend       
       CASE
           WHEN Dayname(transaction_date) IN('Sun','Sat') THEN 'Weekend'
           ELSE 'Weekday'
           END AS Day_classification,    
---New column time bucket
       CASE 
           WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '05:00:00' AND '08:59:59' THEN '01.RUSH.HOUR'
           WHEN  date_format(transaction_time, 'HH:mm:ss') BETWEEN '09:00:00' AND '11:59:59' THEN '02.BRUNCH.HOUR'
           WHEN  date_format(transaction_time, 'HH:mm:ss') BETWEEN '12:00:00' AND '15:59:59' THEN '03.AFTERNOON'
           WHEN  date_format(transaction_time, 'HH:mm:ss') BETWEEN '16:00:00' AND '18:59:59' THEN '04.AFTERHOURS'
           ELSE '05.Night'
           END AS Time_classification,
---New column added 6 : Spend buckets
 CASE
        WHEN (transaction_qty*unit_price) <=50 THEN '01.LOW SPENDER'
        WHEN (transaction_qty*unit_price) BETWEEN 51 AND 200 THEN '02.MEDIUM SPENDER'
        WHEN (transaction_qty*unit_price) BETWEEN 201 AND 300 THEN '03. MODERATE SPENDER'
        ELSE '04.WEALTHY SPENDER'
        END AS spend_bucket,

---New column added 7 : Revenue
       transaction_qty*unit_price AS Revenue

FROM `bright_coffee_shop`.`default`.`bright_coffee_shop_case_study`;       
