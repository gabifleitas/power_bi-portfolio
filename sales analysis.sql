----- trends in year, quarter and month

SELECT
  EXTRACT(YEAR FROM order_purchase_date) AS year,
  EXTRACT(QUARTER FROM order_purchase_date) AS quarter,
  EXTRACT(MONTH FROM order_purchase_date) AS month,
  SUM(payment_value) AS total_sales
FROM orders
JOIN payment ON orders.order_id = payment.order_id
GROUP BY EXTRACT(YEAR FROM order_purchase_date), EXTRACT(QUARTER FROM order_purchase_date), EXTRACT(MONTH FROM order_purchase_date)
ORDER BY EXTRACT(YEAR FROM order_purchase_date), EXTRACT(QUARTER FROM order_purchase_date), EXTRACT(MONTH FROM order_purchase_date);




--------------------------------
----------monthly trend


SELECT EXTRACT(MONTH FROM (order_purchase_date)) AS month, SUM(payment_value) AS total_sales
FROM orders
JOIN payment ON orders.order_id = payment.order_id
GROUP BY month
ORDER BY month;