WITH maker_sales AS (
    SELECT 
        e.maker,
        SUM(CASE WHEN d.fiscal_year = '2022' THEN e.electric_vehicles_sold ELSE 0 END) AS sales_2022,
        SUM(CASE WHEN d.fiscal_year = '2024' THEN e.electric_vehicles_sold ELSE 0 END) AS sales_2024
    FROM electric_vehicle_sales_by_makers e
    JOIN dim_date d ON e.date = d.date
    WHERE e.vehicle_category = '4-Wheelers'
    GROUP BY e.maker
    ORDER BY sales_2024 DESC
    LIMIT 5
)
SELECT 
    maker, 
    sales_2022, 
    sales_2024, 
    ABS(sales_2024 - sales_2022) AS abs_sales_growth,
    CASE 
        WHEN sales_2022 = 0 AND sales_2024 > 0 THEN 100.0  -- New growth scenario
        WHEN sales_2022 = 0 AND sales_2024 = 0 THEN 0.0    -- No growth
        ELSE ROUND((POWER(sales_2024 / NULLIF(sales_2022, 0), 1.0 / 2) - 1) * 100, 2)
    END AS cagr_percent
FROM maker_sales;