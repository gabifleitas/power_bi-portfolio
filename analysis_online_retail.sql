---------------------------------- Avg quantity per year

SELECT _retail_20092010_.description,
       SUM(_retail_20092010_.quantity) AS total_quantity_2009_2010,
       SUM(_retail_20102011_.quantity) AS total_quantity_2010_2011
FROM _retail_20092010_
JOIN _retail_20102011_ ON _retail_20092010_.description =  _retail_20102011_.description
GROUP BY _retail_20092010_.description;



--------------------------------- Top  products per year 

SELECT _retail_20092010_.description,
       SUM(_retail_20092010_.quantity) AS total_quantity
FROM _retail_20092010_
GROUP BY _retail_20092010_.description
ORDER BY total_quantity DESC
LIMIT 5;

SELECT _retail_20102011_.description,
       SUM(_retail_20102011_.quantity) AS total_quantity
FROM _retail_20102011_
GROUP BY _retail_20102011_.description
ORDER BY total_quantity DESC
LIMIT 5;


---------------------- top quantity per country

SELECT country,
       SUM(quantity) AS total_quantity
FROM (
    SELECT country, quantity
    FROM _retail_20092010_
    UNION ALL
    SELECT country, quantity
    FROM _retail_20102011_
) AS combined_data
GROUP BY country
ORDER BY total_quantity DESC;
