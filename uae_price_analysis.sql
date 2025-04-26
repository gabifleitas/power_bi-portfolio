-------------------Average, median, and mode prices

WITH ranked_data AS (
  SELECT price,
         ROW_NUMBER() OVER (ORDER BY price) AS row_num,
         COUNT(*) OVER () AS total_rows
  FROM uae_estate
)
SELECT
  AVG(price) AS average_price,
  (SELECT price FROM ranked_data WHERE row_num = CEILING(total_rows / 2)) AS median_price,
  (SELECT price FROM ranked_data GROUP BY price ORDER BY COUNT(*) DESC LIMIT 1) AS mode_price
FROM ranked_data;


-------- price distribution over time
SELECT
  EXTRACT(YEAR FROM date) AS year,
  EXTRACT(MONTH FROM date) AS month,
  AVG(price) AS average_price
FROM uae_estate
GROUP BY EXTRACT(YEAR FROM date), EXTRACT(MONTH FROM date)
ORDER BY EXTRACT(YEAR FROM date), EXTRACT(MONTH FROM date);



-------- price distribution per month
SELECT
  EXTRACT(MONTH FROM date) AS month,
  AVG(price) AS average_price
FROM uae_estate
GROUP BY EXTRACT(MONTH FROM date)
ORDER BY EXTRACT(MONTH FROM date);



-------- price distribution per year
SELECT
  EXTRACT(YEAR FROM date) AS year,
  AVG(price) AS average_price
FROM uae_estate
GROUP BY EXTRACT(YEAR FROM date)
ORDER BY EXTRACT(YEAR FROM date);



------------ total sales over month and year
SELECT
  EXTRACT(YEAR FROM date) AS year,
  EXTRACT(MONTH FROM date) AS month,
  COUNT(*) AS total_sales
FROM uae_estate
GROUP BY EXTRACT(YEAR FROM date), EXTRACT(MONTH FROM date)
ORDER BY EXTRACT(YEAR FROM date), EXTRACT(MONTH FROM date);


------------ total sales per year
SELECT
  EXTRACT(YEAR FROM date) AS year,
  COUNT(*) AS total_sales
FROM uae_estate
GROUP BY EXTRACT(YEAR FROM date)
ORDER BY EXTRACT(YEAR FROM date);


------------ total sales per month
SELECT
  EXTRACT(MONTH FROM date) AS month,
  COUNT(*) AS total_sales
FROM uae_estate
GROUP BY EXTRACT(MONTH FROM date)
ORDER BY EXTRACT(MONTH FROM date);



---------- price variation size and fournished
SELECT
  size_sqft,
  furnished,
  AVG(price) AS average_price
FROM uae_estate
GROUP BY size_sqft, furnished
ORDER BY furnished;


---------- price variation size
SELECT
  size_sqft,
  AVG(price) AS average_price
FROM uae_estate
GROUP BY size_sqft
ORDER BY average_price DESC;





------------- comparison between verified and unverified
SELECT
  EXTRACT(YEAR FROM date) AS year,
  EXTRACT(MONTH FROM date) AS month,
  COUNT(CASE WHEN verified = TRUE THEN 1 END) AS verified_sales,
  COUNT(CASE WHEN verified = FALSE THEN 1 END) AS unverified_sales
FROM uae_estate
GROUP BY EXTRACT(YEAR FROM date), EXTRACT(MONTH FROM date)
ORDER BY EXTRACT(YEAR FROM date), EXTRACT(MONTH FROM date);


------------total sales verified and unverified
SELECT
  COUNT(CASE WHEN verified = TRUE THEN 1 END) AS total_verified_sales,
  COUNT(CASE WHEN verified = FALSE THEN 1 END) AS total_unverified_sales
FROM uae_estate;
