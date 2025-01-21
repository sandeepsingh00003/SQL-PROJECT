WITH sales_comparison AS (
    SELECT 
        state,
        SUM(CASE WHEN YEAR(STR_TO_DATE(date, '%d-%b-%y')) = 2022 THEN electric_vehicles_sold ELSE 0 END) AS sales_2022,
        SUM(CASE WHEN YEAR(STR_TO_DATE(date, '%d-%b-%y')) = 2024 THEN electric_vehicles_sold ELSE 0 END) AS sales_2024
    FROM 
        electric_vehicle_sales_by_state
    WHERE 
        YEAR(STR_TO_DATE(date, '%d-%b-%y')) IN (2022, 2024)
    GROUP BY 
        state
)
SELECT 
    state,
    sales_2022,
    sales_2024,
    (sales_2024 - sales_2022) AS sales_difference
FROM 
    sales_comparison
WHERE 
   (sales_2024 - sales_2022) < 0
   order by sales_difference desc;