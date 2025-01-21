WITH yearly_revenue AS (
    SELECT 
        YEAR(STR_TO_DATE(date, '%d-%b-%y')) AS year,
        vehicle_category,
        SUM(electric_vehicles_sold) AS total_units,
        SUM(
            CASE 
                WHEN vehicle_category = '4-Wheelers' AND electric_vehicles_sold > 0 THEN electric_vehicles_sold * 1500000  -- Price for 4-wheelers
                WHEN vehicle_category = '2-Wheelers' AND electric_vehicles_sold > 0 THEN electric_vehicles_sold * 85000    -- Price for 2-wheelers
                ELSE 0
            END
        ) AS total_revenue
    FROM 
        electric_vehicle_sales_by_state
    WHERE 
        YEAR(STR_TO_DATE(date, '%d-%b-%y')) BETWEEN 2022 AND 2024
    GROUP BY 
        year, vehicle_category
)

SELECT 
    r1.vehicle_category,
    r1.year AS start_year,
    r2.year AS end_year,
    r1.total_revenue AS start_revenue,
    r2.total_revenue AS end_revenue,
    -- Calculate revenue growth percentage
    ROUND(
        CASE 
            WHEN r1.total_revenue = 0 THEN 0
            ELSE ((r2.total_revenue - r1.total_revenue) / r1.total_revenue) * 100
        END, 2
    ) AS growth_rate_percent
FROM 
    yearly_revenue r1
JOIN 
    yearly_revenue r2 
ON 
    r1.vehicle_category = r2.vehicle_category 
    AND r2.year > r1.year 
WHERE 
    (r1.year, r2.year) IN ((2022, 2024), (2023, 2024))
ORDER BY 
    r1.vehicle_category, r1.year;