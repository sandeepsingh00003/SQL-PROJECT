WITH filtered_data AS (
    SELECT 
        e.maker, 
        e.vehicle_category, 
        YEAR(STR_TO_DATE(e.date, '%d-%b-%y')) AS year,  -- Extracting year from date
        d.quarter,  -- Using the quarter from dim_date table
        SUM(e.electric_vehicles_sold) AS total_sales
    FROM electric_vehicle_sales_by_makers e
    JOIN dim_date d 
      ON e.date = d.date
    WHERE 
        e.vehicle_category = '4-Wheelers' 
        AND YEAR(STR_TO_DATE(e.date, '%d-%b-%y')) BETWEEN 2022 AND 2024
    GROUP BY e.maker, e.vehicle_category, year, d.quarter 
), 

top_makers AS (
    SELECT maker, SUM(total_sales) AS total_maker_sales
    FROM filtered_data
    GROUP BY maker
    ORDER BY total_maker_sales DESC
    LIMIT 5
)

SELECT 
    f.maker, 
    f.year,  -- Using the extracted year
    f.quarter, 
    f.total_sales
FROM filtered_data f
JOIN top_makers t 
  ON f.maker = t.maker
ORDER BY f.total_sales DESC;