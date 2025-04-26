
-------------- correlation size and price
SELECT
  CORR(size_sqft, price) AS correlation_coefficient
FROM uae_estate;


---- avg price per size
SELECT
  AVG(price / size_sqft) AS average_price_per_square_foot
FROM uae_estate;


--------- impact of number bathroom and bedroom on price
SELECT
  bedroom,
  bathroom,
  AVG(price) AS average_price
FROM uae_estate


-------- fournished not fournishe price comparison
SELECT
  furnished,
  AVG(price) AS average_price
FROM uae_estate
GROUP BY furnished;
GROUP BY bedroom, bathroom;