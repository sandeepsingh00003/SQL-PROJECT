WITH sales_data AS (
    SELECT 
        state,
        SUM(CASE WHEN YEAR(STR_TO_DATE(date, '%d-%b-%y')) = 2022 THEN electric_vehicles_sold ELSE 0 END) AS sales_2022,
        SUM(CASE WHEN YEAR(STR_TO_DATE(date, '%d-%b-%y')) = 2024 THEN electric_vehicles_sold ELSE 0 END) AS sales_2024
    FROM 
        electric_vehicle_sales_by_state
    GROUP BY 
        state
),
cagr_calculation AS (
    SELECT 
        state,
        sales_2022,
        sales_2024,
        CASE 
            WHEN sales_2022 = 0 THEN 0
            ELSE ROUND(POWER(sales_2024 / sales_2022, 1.0 / 2) - 1, 4)  -- Fixed POWER() usage
        END AS cagr
    FROM 
        sales_data
),
projected_sales AS (
    SELECT 
        state,
        sales_2024,
        cagr,
        ROUND(sales_2024 * POWER(1 + cagr, 6), 2) AS projected_sales_2030  -- 6 years from 2024 to 2030
    FROM 
        cagr_calculation
)

SELECT 
    state, 
    projected_sales_2030
FROM 
    projected_sales
ORDER BY 
    projected_sales_2030 DESC
LIMIT 10;