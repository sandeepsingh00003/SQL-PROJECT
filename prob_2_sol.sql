WITH EV_Sales AS (
    SELECT 
        e.state,
        e.vehicle_category,
        SUM(electric_vehicles_sold) AS total_electric_sold,
        SUM(total_vehicles_sold) AS total_sold
    FROM 
        electric_vehicle_sales_by_state e
        join dim_date d
        on 
           e.date = d.date
    WHERE 
        fiscal_year = 2024
    GROUP BY 
        state, vehicle_category
),
Penetration AS (
    SELECT 
        state,
        vehicle_category,
        total_electric_sold,
        total_sold,
        (total_electric_sold * 100.0 / NULLIF(total_sold, 0)) AS penetration_rate
    FROM 
        EV_Sales
)
SELECT 
    state,
    vehicle_category,
    penetration_rate
FROM 
    Penetration
WHERE 
    vehicle_category IN ('2-Wheelers', '4-Wheelers')
ORDER BY 
    penetration_rate DESC
   LIMIT 5;