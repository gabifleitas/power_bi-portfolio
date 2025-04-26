-- Distribution by ZIP code
SELECT customer_zip_code_prefix, COUNT(*) AS customer_count
FROM customers
GROUP BY customer_zip_code_prefix
ORDER BY customer_count DESC;

-- Distribution by city
SELECT customer_city, COUNT(*) AS customer_count
FROM customers
GROUP BY customer_city
ORDER BY customer_count DESC;

-- Distribution by state
SELECT customer_state, COUNT(*) AS customer_count
FROM customers
GROUP BY customer_state
ORDER BY customer_count DESC;


-------------------------------------------------------------------------

-- Average order value by ZIP code
SELECT customer_zip_code_prefix, AVG(payment_value) AS avg_order_value
FROM customers
JOIN orders ON customers.customers_id = orders.customer_id
JOIN payment ON orders.order_id = payment.order_id
GROUP BY customer_zip_code_prefix;


-- Average order value by city
SELECT customer_city, AVG(payment_value) AS avg_order_value
FROM customers
JOIN orders ON customers.customers_id = orders.customer_id
JOIN payment ON orders.order_id = payment.order_id
GROUP BY customer_city;

-- Average order value by state
SELECT customer_state, AVG(payment_value) AS avg_order_value
FROM Customers
JOIN Orders ON Customers.customers_id = Orders.customer_id
JOIN Payment ON Orders.order_id = Payment.order_id
GROUP BY customer_state;



-----------------------------------------------------------

----- Identifying Repeat Customers and the Purchase Frequency

WITH repeat_customers AS (
  SELECT customer_id
  FROM orders
  GROUP BY customer_id
  HAVING COUNT(*) > 1
)
SELECT
  repeat_customers.customer_id,
  customers.customer_city,
  COUNT(orders.order_id) AS purchase_frequency
FROM repeat_customers 
JOIN customers ON repeat_customers.customer_id = customers.customers_id
JOIN orders ON repeat_customers.customer_id = orders.customer_id
GROUP BY repeat_customers.customer_id, customers.customer_city;


--------------------------------------------------------------------------

--------customer churn rates

WITH LastPurchase AS (
  SELECT customer_id, MAX(order_purchase_date) AS last_purchase_date
  FROM orders
  GROUP BY customer_id
)
SELECT
  COUNT(CASE WHEN EXTRACT(EPOCH FROM AGE(CURRENT_DATE, last_purchase_date)) / 86400 > 90 THEN 1 END) AS churned_customers,
  COUNT(*) AS total_customers,
  (COUNT(CASE WHEN EXTRACT(EPOCH FROM AGE(CURRENT_DATE, last_purchase_date)) / 86400 > 90 THEN 1 END) / COUNT(*)) * 100 AS churn_rate
FROM LastPurchase;





--------------------------------------------------------------------------
---- High-value customers

SELECT
  customer_id,
  SUM(payment_value) AS total_spending
FROM orders
JOIN payment ON orders.order_id = payment.order_id
GROUP BY customer_id
ORDER BY total_spending DESC
LIMIT 10;


--------------------------------------------------------------------------------
------- High-value customers, city, payment type and total spending

SELECT
  customers.customers_id,
  customers.customer_city,
  payment.payment_type,
  SUM(oder_items.shipping_charges) AS total_spending
FROM orders 
JOIN customers ON orders.customer_id = customers.customers_id
JOIN payment ON orders.order_id = payment.order_id
JOIN oder_items ON orders.order_id = oder_items.order_id
GROUP BY customers.customers_id, customers.customer_city, payment.payment_type
ORDER BY total_spending DESC
LIMIT 10;


------- High-value customers, city, payment type, total spending, total items

SELECT
  customers.customers_id,
  customers.customer_city,
  payment.payment_type,
  SUM(oder_items.shipping_charges) AS total_spending,
  COUNT(oder_items.product_id) AS total_items
FROM orders
JOIN customers ON orders.customer_id = customers.customers_id
JOIN payment ON orders.order_id = payment.order_id
JOIN oder_items ON orders.order_id = oder_items.order_id
GROUP BY customers.customers_id, customers.customer_city, payment.payment_type
ORDER BY total_spending DESC
LIMIT 10; ------- We will upload without the LIMIT 10





------------------------------------------------------------

-------Frequent buyers, cities, amount of purchases

SELECT
  customers.customers_id,
  customers.customer_city,
  COUNT(*) AS total_purchases
FROM orders 
JOIN customers ON orders.customer_id = customers.customers_id
GROUP BY customers.customers_id, customers.customer_city
ORDER BY total_purchases DESC
LIMIT 10;

----Frequent buyers, cities, amount of purchases and money spent

SELECT
  customers.customers_id,
  customers.customer_city,
  COUNT(*) AS total_purchases,
  SUM(payment.payment_value) AS total_spending
FROM orders 
JOIN customers ON orders.customer_id = customers.customers_id
JOIN payment  ON orders.order_id = payment.order_id
GROUP BY customers.customers_id, customers.customer_city
ORDER BY total_purchases DESC
LIMIT 10;------- We will upload without the LIMIT 10


-------------------------------------------------------------------------
---Loyal customer, city, purchase, spending

WITH repeat_customers AS (
  SELECT customer_id
  FROM orders
  GROUP BY customer_id
  HAVING COUNT(*) > 1
)
SELECT
  repeat_customers.customer_id,
  customers.customer_city,
  COUNT(*) AS total_purchases,
  SUM(payment.payment_value) AS total_spending
FROM repeat_customers 
JOIN customers  ON repeat_customers.customer_id = customers.customers_id
JOIN orders ON repeat_customers.customer_id = orders.customer_id
JOIN payment ON orders.order_id = payment.order_id
GROUP BY repeat_customers.customer_id, customers.customer_city
ORDER BY total_spending DESC;