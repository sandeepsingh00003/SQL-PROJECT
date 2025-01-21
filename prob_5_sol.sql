-- how do the EV sales and penetration rates in Delhi compare to Karnataka for 2024?

WITH state_sales_2024 AS (
    SELECT 
        state, 
        SUM(electric_vehicles_sold) AS total_ev_sales, 
        SUM(total_vehicles_sold) AS total_vehicle_sales
    FROM electric_vehicle_sales_by_state
    JOIN dim_date 
      ON electric_vehicle_sales_by_state.date = dim_date.date
    WHERE 
        fiscal_year = '2024' 
        AND state IN ('Delhi', 'Karnataka')
    GROUP BY state
)

SELECT 
    state, 
    total_ev_sales, 
    total_vehicle_sales, 
    ROUND((total_ev_sales / total_vehicle_sales) * 100, 2) AS penetration_rate
FROM state_sales_2024;