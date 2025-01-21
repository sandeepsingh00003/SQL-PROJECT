WITH total_vehicles AS (
    SELECT 
        state,
        SUM(CASE WHEN YEAR(STR_TO_DATE(date, '%d-%b-%y')) = 2022 THEN total_vehicles_sold ELSE 0 END) AS total_2022,
        SUM(CASE WHEN YEAR(STR_TO_DATE(date, '%d-%b-%y')) = 2024 THEN total_vehicles_sold ELSE 0 END) AS total_2024
    FROM 
        electric_vehicle_sales_by_state
    WHERE 
        YEAR(STR_TO_DATE(date, '%d-%b-%y')) IN (2022, 2024)
    GROUP BY 
        state
)

SELECT 
    state,
    total_2022,
    total_2024,
    CASE 
        WHEN total_2022 = 0 AND total_2024 > 0 THEN 100.0  -- New growth scenario
        WHEN total_2022 = 0 AND total_2024 = 0 THEN 0.0    -- No growth
        ELSE ROUND((POWER(total_2024 / total_2022, 1.0 / 2) - 1) * 100, 2)  -- Calculate CAGR
    END AS cagr_percent
FROM 
    total_vehicles
ORDER BY 
    cagr_percent DESC  
LIMIT 10;  -- Get the top 10 states